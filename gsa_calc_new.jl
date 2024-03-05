using DataFramesMeta, XLSX, CSV
using Combinatorics
using LinearAlgebra
using GlobalSensitivity, QuasiMonteCarlo

mtdt = DataFrame(XLSX.readtable("data/bounds.xlsx", "metadata"))

#funs = Array{Function}(undef, nrow(mtdt))
#for i in 1:nrow(mtdt)
#    expres = mtdt.function[i]
#    funs[i] = @eval (x) -> $(Meta.parse(expres))
#end
#
#funs[1]([1,1])
#
#split.(mtdt.vars, ", ")
#
#mtdt.vars[1]

uniqvars = unique(mtdt.vars)
vrs = Array{DataFrame}(undef, length(uniqvars))

for (i, variable) in enumerate(uniqvars)
    vrs[i] = @subset(mtdt, :vars .== variable)
end

# splits var into an array of separate elements
splt = split(mtdt.vars[6], ", ") 
# returns the combinations of splt
cmbs = combinations(splt)
# collects cmbs
col = collect(cmbs)
# returns only the elements of col with size smaller than 3, since we won't calculate sobol indices of order larger than 2. 
col_smaller_than_3 = col[length.(col) .<= 2] 
# concatenats the strings of vars
concatenated_col = join.(col_smaller_than_3, "_") 
# adds the total order indices of the vars
vcat(concatenated_col, concatenated_col[1:length(splt)] .* "_T")

##########################################################################################

formulas = @eval (x) -> $(Meta.parse(mtdt.function[j]))

named_tuple = (1 = 2, y = 2)
named_tuple.x(2)

##########################################################################################

formulas = NamedTuple(
    [(Symbol(mtdt.id[i]), 
        @eval (x) -> $(Meta.parse(mtdt.function[i]))
    ) 
    for i in 1:nrow(mtdt)]
)

formulas[Symbol(mtdt.id[1])]


function weight_formula_gsa(mtdt; save = false)
    resulting_directory = "GSA_results/new_data/"

    samplesN = 10^5
    samples = samplesN
    sampler = SobolSample()
    bootStrapN = 1000

    bounds_data = DataFrame(XLSX.readtable("data/bounds.xlsx", "Sheet3"))

    output = Array{DataFrame}(undef, nrow(mtdt))
    for j in 1:nrow(mtdt)

        vars = mtdt.vars[j]
        # splits var into an array of separate elements
        splt = split(vars, ", ")
        var_len = length(splt)
        indices_names = @chain splt begin
            # returns the combinations of the split
            combinations()
            # collects the combinations
            collect()
            # returns only the combinations of size smaller than 3, since we won't calculate sobol indices of order larger than 2
            _[length.(_) .<= 2]
            # concatenats the strings of combinations
            join.("_")
            # adds the total order indices of the vars
            vcat(_, _[1:var_len] .* "_T")
        end 

        formula = @eval (x) -> $(Meta.parse(mtdt.function[j]))

        # initializes an empty dataframe with just the column names being `indices_names`
        df = DataFrame([indices_name => Float64[] for (indices_name) in indices_names])

        # calculate GSA for each week
        for i in 1:nrow(bounds_data)
            # gets the bounds of the vars for the current week, and returns it as a vector
            lb = select(bounds_data, splt.*"_min")[i, :] |> collect
            up = select(bounds_data, splt.*"_max")[i, :] |> collect

            A, B = QuasiMonteCarlo.generate_design_matrices(samples, lb, up, sampler)

            res = gsa(formulas[Symbol(mtdt.id[j])], Sobol(order = [0,1,2], nboot = bootStrapN), A, B)

            M = res.S2
            # M[triu(trues(size(M)), 1)] returns a vector of the elemets of the upper triangular matrix M,
            # by creating the upper triangular BitMatrix triu(trues(size(M)), 1).
            # Then, concatenates all the indices into a vector
            new_data = vcat(res.S1, M[triu(trues(size(M)), 1)], res.ST)

            # Pushes the indices to df
            push!(df, new_data)
        end
        output[j] = df

        if save == true
            mkpath(resulting_directory) 
            strdr = resulting_directory * "$(mtdt.id[j])" * ".csv"
            CSV.write(strdr, df)
        end
    end

    return output
end

weight_formula_gsa(@subset(mtdt, :id .!= "f2",  :id .!= "f23" ); save = true)

