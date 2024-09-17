# Figure
using CairoMakie

function numtogrid(i::Int, numberofcolumns::Int)
    row = divrem(i+numberofcolumns-1, numberofcolumns)[1] 
    col = (i+numberofcolumns-1)%numberofcolumns + 1
    return Dict(:row => row, :col => col)
end

function fig_weight_formula_gsa(df::DataFrame)
    location = "GSA_results/"

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
            title = d.paper, 
            xticks = xtickweek,
            xlabel = "Week"
        )

       Label(fig[numtogrid(i,2)[:row], numtogrid(i,2)[:col], TopLeft()], string("(", Char('a' + i - 1), ")"),
       fontsize = 20,
       font = :bold,
       padding = (0, 0, 5, 0),
       halign = :right,
       tellheight = true
       )

        max_value = maximum(vcat(eachcol(data)...))
        band!(ax[i], collect(12:14) .- 11, zeros(3), max_value*ones(3);
            color = "#7F7D9C",
            alpha = 0.5)
        band!(ax[i], collect(18:22) .- 11, zeros(5), max_value*ones(5);
            color = "#C5C6D0",
            alpha = 0.5)
        band!(ax[i], collect(22:24) .- 11, zeros(3), max_value*ones(3);
            color = "#7F7D9C",
            alpha = 0.5)   
        band!(ax[i], collect(32:34) .- 11, zeros(3), max_value*ones(3);
            color = "#C5C6D0",
            alpha = 0.5)

            
        for (j, var) in enumerate(vars)
            scatterlines!(ax[i], data[!, var];
                label = var,
                color = var_color[Symbol(var)],
                marker = var_marker[Symbol(var)]
            )
        end


    end

    Legend(fig[end+1, :], ax[5];
        tellheight = true,
        orientation = :horizontal,
        framevisible = :false
    )

    Label(fig[0, :], "First order indices";
        fontsize = 20,
        font = :bold,   
        tellheight = true
    )

    resize_to_layout!(fig)
    return fig
end

var_color = Dict(
    :BPD    => "#F32EA1",
    :AC     => "#0BD976",
    :FL     => "#FFD92E",
    :HC     => "#8630BF",
    :BPD_T  => "#D19FBA", 
    :AC_T   => "#9B9F0E", 
    :FL_T   => "#F6D891",
    :HC_T   => "#736EB8",
    :BPD_AC => "#7f848c", # https://colordesigner.io/color-mixer/?mode=rgb#F32EA1%7B0%7D-0BD976%7B0%7D-FFD92E%7B1%7D-8630BF%7B1%7D
    :BPD_FL => "#f98468",
    :BPD_HC => "#bd2fb0",
    :AC_FL  => "#85d952",
    :AC_HC  => "#49859b",
    :FL_HC  => "#c38577",
)

var_marker = Dict(
    :BPD    => :star5,
    :AC     => :circle,
    :FL     => :xcross,
    :HC     => :diamond,
    :BPD_T  => nothing,
    :AC_T   => :dashed,
    :FL_T   => :dot,
    :HC_T   => :dashdot,
    :BPD_AC => nothing, 
    :BPD_FL => nothing,
    :BPD_HC => nothing,
    :AC_FL  => nothing,
    :AC_HC  => nothing,
    :FL_HC  => nothing,
)

theme_total() = Theme( fontsize = 12, figure_padding = 2,
    Axis = (
        titlesize = 13,
        leftspinevisible = false,
        rightspinevisible = false,
        bottomspinevisible = false,
        topspinevisible = false,
        backgroundcolor = "#E5ECF6",
        xgridcolor = :white,
        ygridcolor = :white,
        xtickcolor = "#E5ECF6",
        ytickcolor = "#E5ECF6",
        yticklabelcolor = "#2A3F5F",
        xticklabelcolor = "#2A3F5F",
        titlecolor = "#0B2D60",
        xlabelcolor = "#0B2D60",
        ylabelcolor = "#0B2D60"
    ),
    ScatterLines = (
        linewidth = 1.5,
        markersize = 7,
    ),
    Legend = (
        labelcolor = "#2A3F5F",
        titlecolor = "#0B2D60",
        framevisible = false,
        orientation = :horizontal,
    ),
    Label = (;
        color = "#2A3F5F"
    )
)

theme_UOG() = Theme( fontsize = 12, figure_padding = 2, 
    fonts = (;
        regular = "Sabon LP Paneuropean",
        bold = "Sabon LP Paneuropean Bold",
        bold_italic = "Sabon LP Paneuropean Bold Italic",
        italic = "Sabon LP Paneuropean Italic"
    ),
    Axis = (
        titlesize = 13,
        leftspinevisible = true,
        rightspinevisible = false,
        bottomspinevisible = true,
        topspinevisible = false,
        xgridcolor = :white,
        ygridcolor = :white,
        xtickcolor = :black,
        ytickcolor = :black,
        yticklabelcolor = :black,
        xticklabelcolor = :black,
    ),
    Lines = (;
        alpha = 0.7
    ),
    Scatter = (;
        alpha = 0.7
    ),
    ScatterLines = (
        linewidth = 1.5,
        markersize = 7,
    ),
    Legend = (
        framevisible = false,
        orientation = :horizontal,
    ),
    Label = (;
    )
)

function fun8_barplot()
    id = 8

    xtickweek = (1:3:31, string.(12:3:42))
    color_5th = "#233867"
    color_95th = "#BC152F"

    dtMed = [formulas[id]([x1, x2, x3, x4]) for (x1, x2, x3, x4) in zip(bounds_data.BPD_med, bounds_data.AC_med, bounds_data.FL_med, bounds_data.HC_med)]
    dtMinBPD = [formulas[id]([x1, x2, x3, x4]) for (x1, x2, x3, x4) in zip(bounds_data.BPD_min, bounds_data.AC_med, bounds_data.FL_med, bounds_data.HC_med)]
    dtMaxBPD = [formulas[id]([x1, x2, x3, x4]) for (x1, x2, x3, x4) in zip(bounds_data.BPD_max, bounds_data.AC_med, bounds_data.FL_med, bounds_data.HC_med)]
    dtMinAC = [formulas[id]([x1, x2, x3, x4]) for (x1, x2, x3, x4) in zip(bounds_data.BPD_med, bounds_data.AC_min, bounds_data.FL_med, bounds_data.HC_med)]
    dtMaxAC = [formulas[id]([x1, x2, x3, x4]) for (x1, x2, x3, x4) in zip(bounds_data.BPD_med, bounds_data.AC_max, bounds_data.FL_med, bounds_data.HC_med)]
    dtMinAll = [formulas[id]([x1, x2, x3, x4]) for (x1, x2, x3, x4) in zip(bounds_data.BPD_min, bounds_data.AC_min, bounds_data.FL_min, bounds_data.HC_min)]
    dtMaxAll = [formulas[id]([x1, x2, x3, x4]) for (x1, x2, x3, x4) in zip(bounds_data.BPD_max, bounds_data.AC_max, bounds_data.FL_max, bounds_data.HC_max)]
 
    resMinA = (dtMed .- dtMinBPD) ./ abs.(dtMinAll .- dtMaxAll) 
    resMaxA = (dtMed .- dtMaxBPD) ./ abs.(dtMinAll .- dtMaxAll)
    resMinB = (dtMed .- dtMinAC) ./ abs.(dtMinAll .- dtMaxAll) 
    resMaxB = (dtMed .- dtMaxAC) ./ abs.(dtMinAll .- dtMaxAll) 


    fig = Figure()
    axA = Axis(fig[1, 1];
            width = 2*10*28.3465, height = 2.5*28.3465,
            title = "median versus 5th and 95th BDP percentile", 
            xticks = xtickweek,
            xlabel = "Week",
            ytickformat = values -> ["$(value)%" for value in values]
        )
    barplot!(axA, resMaxA .* 100; color = color_95th)
    barplot!(axA, resMinA .* 100; color = color_5th)
    
    axB = Axis(fig[2, 1];
            width = 2*10*28.3465, height = 2.5*28.3465,
            title = "median versus 5th and 95th AC percentile", 
            xticks = xtickweek,
            xlabel = "Week",
            ytickformat = values -> ["$(value)%" for value in values]
    )
    barplot!(axB, resMaxB .* 100;
        label = "95th percentile",
        color = color_95th
    )
    barplot!(axB, resMinB .* 100;
        label = "5th percentile",
        color = color_5th
    )

    Label(fig[1, 1, TopLeft()], "A",
        fontsize = 26,
        font = :bold,
        padding = (0, 5, 5, 0),
        halign = :right,
        tellheight = true
    )

    Label(fig[2, 1, TopLeft()], "B",
        fontsize = 26,
        font = :bold,
        padding = (0, 5, 5, 0),
        halign = :right
    )

    Label(fig[0, :], "Change in estimated weight using Hadlock IV";
        fontsize = 20,
        font = :bold,
        tellheight = true
        )

    Legend(fig[end+1, :], axB;
        tellheight = true,
        orientation = :horizontal,
        framevisible = :false
    )
    
    resize_to_layout!(fig)
    
    return fig
end
