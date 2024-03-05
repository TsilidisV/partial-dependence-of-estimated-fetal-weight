using CairoMakie, DataFramesMeta, CSV

df_f8  = DataFrame(CSV.File("GSA_results/f13.csv"))

lines(14:1:39, df_f8.AC, label = "AC")
lines!(14:1:39,df_f8.BDP, label = "BDP")
lines!(14:1:39,df_f8.HC, label = "HC")
lines!(14:1:39,df_f8.FL, label = "FL")
axislegend()
current_figure()

df_f8.AC



function numtogrid(i::Int, numberofcolumns::Int)
    row = divrem(i+numberofcolumns-1, numberofcolumns)[1] 
    col = (i+numberofcolumns-1)%numberofcolumns + 1
    return Dict(:row => row, :col => col)
end

function fig_weight_formula_gsa(df::DataFrame)
    location = "GSA_results/new_data/"

    # NOT DYNAMIC
    xtickweek = (1:3:31, string.(12:3:42))

    size_inches = (8, 10)
    size_pt = 72 .* size_inches
  
    fig = Figure()
    ax = Vector{Axis}(undef, nrow(df))
    for (i, d) in enumerate(eachrow(df))

        # returns the vars of the formula in the current row
        vars = split(d.vars, ", ")

        # reads the GSA result from the specified folder
        str = location * d.id * ".csv"
        data = CSV.read(str, DataFrame)
        
        ax[i] = Axis(fig[numtogrid(i,2)[:row], numtogrid(i,2)[:col]];
            width = 10*28.3465, height = 2.5*28.3465,
            title = d.id, 
            xticks = xtickweek,
            xlabel = "Week"
        )

        for (j, var) in enumerate(vars)
            scatterlines!(ax[i], data[!, var];
                label = var,
                color = var_color[Symbol(var)],
                marker = var_marker[Symbol(var)]
            )
        end

    end

    Legend(fig[end+1, :], ax[1];
        tellheight = true,
        orientation = :horizontal,
        framevisible = :false
    )

    Label(fig[0, :], "___ order indices of formulas that depend on $(df.vars[1])";
    )

    resize_to_layout!(fig)
    return fig
end

fig1 = fig_weight_formula_gsa(@subset(mtdt, :vars .== "BPD, AC"))

fig1 = with_theme(theme_total()) do 
    fig_weight_formula_gsa(@subset(mtdt, :vars .== "AC, FL, HC"))
end

save("figs/new/fig2.pdf", fig1; px_per_unit = 1)