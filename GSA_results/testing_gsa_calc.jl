using DataFramesMeta, XLSX, CSV
using Combinatorics
using LinearAlgebra
using GlobalSensitivity, QuasiMonteCarlo

formulas = NamedTuple(
    [(Symbol(mtdt.id[i]), 
        @eval (x) -> $(Meta.parse(mtdt.function[i]))
    ) 
    for i in 1:nrow(mtdt)]
)


function weight_formula_gsa_med(mtdt; save = false)
    resulting_directory = "GSA_results/new_data_3_50cent/"

    samplesN = 10^6
    samples = samplesN
    sampler = SobolSample()
    bootStrapN = 1

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

            for j in 1:length(splt)
                if splt[j] == "HC"
                    lb[j] = select(bounds_data, splt[j].*"_med")[i, :]
                    @show true
                end
            end

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

weight_formula_gsa_med(@subset(mtdt, :id .== "f9"); save = true)