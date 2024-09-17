using DataFramesMeta, CSV, XLSX

function table_maker(df::DataFrame; save = nothing)
    location = "GSA_results/new_data_2/"
    weeks = 12:42

    week1 = 12:14
    week2 = 18:22
    week3 = 22:24
    week4 = 32:34

    tra_data = DataFrame()
    for (i, d) in enumerate(eachrow(df))
        vars = split(d.vars, ", ")

        str = location * d.id * ".csv"
        data = CSV.read(str, DataFrame)

        tra_data_new = @chain data begin
            transform(All() .=> ByRow(x -> round(x; digits = 2)) .=> All())
            select(vars)
            insertcols(1, :formula => d.paper)
            insertcols!(2, :week => weeks)
            stack()
            unstack([:formula, :variable], :week, :value)
            select(:formula, :variable, string.(week1), string.(week2), string.(week3), string.(week4))
            rename(:formula => "Formula", :variable => "Parameter")
        end

        tra_data = vcat(tra_data, tra_data_new)
    end

    if typeof(save) <: String

        XLSX.openxlsx("tables/result_tables.xlsx", mode="rw") do xf
            # Add a new sheet
            new_sheet = XLSX.addsheet!(xf, save)
            
            XLSX.writetable!(new_sheet, tra_data)
        end
       
    end

    return tra_data
end

function table1maker()
    
    df = @chain DataFrame(XLSX.readtable("data/bounds.xlsx", "metadata")) begin
        filter(:vars => x -> x !== "-", _)
        transform(:LaTeX => (ByRow(x -> string("\$", x, "\$")) => :Formula))
        transform(:paper => identity => :Source)
        select("Source", "Formula")
    end

    XLSX.writetable("tables/Table1.xlsx", collect(eachcol(df)), names(df))
end