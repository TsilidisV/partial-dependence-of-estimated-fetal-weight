size_inches = (7, 4)
size_pt = 72 .* size_inches

BDP_AC_FL_HC_total_theme = Theme( fontsize = 12, figure_padding = 5, resolution = size_pt, 
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
        xlabelcolor = "#0B2D60"
    ),
    palette = (color = ["#D19FBA", "#9B9F0E", "#F6D891", "#736EB8"], linestyle = [nothing, :dash, :dot, :dashdot]),
    Lines = (
        linewidth = 1.5,
        cycle = Cycle([:color, :linestyle], covary = true)
    ),
    Legend = (
        labelcolor = "#2A3F5F",
        titlecolor = "#0B2D60",
        framevisible = false,
        margin = (0,0,-25,-10),
        orientation = :horizontal,
        tellheight = true,
        tellwidth = false 
    )
)

BDP_AC_FL_HC_1st_theme = Theme( fontsize = 12, figure_padding = 5, resolution = size_pt,
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
        xlabelcolor = "#0B2D60"
    ),
    palette = (color = ["#F32EA1", "#0BD976", "#FFD92E", "#8630BF"],
               linestyle = [nothing, :dash, :dot, :dashdot],
               marker = [:star5, :diamond, :diamond, :hexagon]
    ),
    ScatterLines = (
        linewidth = 1.5,
        markersize = 7,
        cycle = Cycle([:color, :marker], covary = true)
    ),
    Legend = (
        labelcolor = "#2A3F5F",
        titlecolor = "#0B2D60",
        framevisible = false,
        margin = (0,0,-25,-10),
        orientation = :horizontal,
        tellheight = true,
        tellwidth = false 
    )
)
with_theme(BDP_AC_1st_fig, BDP_AC_FL_HC_1st_theme)


AC_FL_HC_1st_theme = Theme( fontsize = 12, figure_padding = 5, resolution = size_pt,
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
        xlabelcolor = "#0B2D60"
    ),
    palette = (color = [var_color[:AC], var_color[:FL], var_color[:HC]],
               linestyle = [var_line[:AC], var_line[:FL], var_line[:HC]],
               marker = [var_marker[:AC], var_marker[:FL], var_marker[:HC]]
    ),
    ScatterLines = (
        linewidth = 1.5,
        markersize = 7,
        cycle = Cycle([:color, :marker], covary = true)
    ),
    Legend = (
        labelcolor = "#2A3F5F",
        titlecolor = "#0B2D60",
        framevisible = false,
        margin = (0,0,-25,-10),
        orientation = :horizontal,
        tellheight = true,
        tellwidth = false 
    )
)
AC_FL_HC_2nd_theme = Theme( fontsize = 12, figure_padding = 5, resolution = size_pt,
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
        xlabelcolor = "#0B2D60"
    ),
    palette = (color = [var_color[:AC_FL], var_color[:AC_HC], var_color[:FL_HC]],
               linestyle = [var_line[:AC], var_line[:FL], var_line[:HC]],
               marker = [var_marker[:AC], var_marker[:FL], var_marker[:HC]]
    ),
    ScatterLines = (
        linewidth = 1.5,
        markersize = 7,
        cycle = Cycle([:color, :marker], covary = true)
    ),
    Legend = (
        labelcolor = "#2A3F5F",
        titlecolor = "#0B2D60",
        framevisible = false,
        margin = (0,0,-25,-10),
        orientation = :horizontal,
        tellheight = true,
        tellwidth = false 
    )
)
with_theme(AC_FL_HC_1st_fig, AC_FL_HC_1st_theme)
with_theme(AC_FL_HC_2nd_fig, AC_FL_HC_2nd_theme)



save("figure6.pdf", with_theme(AC_FL_HC_2nd_fig, AC_FL_HC_2nd_theme),pt_per_unit = 1)



#F32EA1
#0BD976
#FFD92E
#8630BF



#################################################





title_names = [
    L"f(\text{BDP}, \text{AC}) = 10^{-1.599 + 0.144\text{BDP} + 0.032\text{AC} - 0.000111\text{AC}\cdot\text{BDP}^2 }",
    L"f(\text{BDP}, \text{AC}) = 10^{-1.7492 + 0.166\text{BDP} + 0.046\text{AC} - 0.002646\text{BDP}\cdot\text{AC} }",
    L"f(\text{BDP}, \text{AC}) = 10^{-1.1683 + 0.095\text{BDP} + 0.0377\text{AC} - 0.0015\text{BDP}\cdot\text{AC} }",
    L"f(\text{BDP}, \text{AC}) = 9.337\text{BDP}\cdot\text{AC} - 229",
    L"f(\text{BDP}, \text{AC}) = 10^{1.13 + 0.181864\text{BDP} + 0.0517505\text{AC} − 3.34825\text{BDP}\cdot\text{AC}/1000) }",
    L"f(\text{BDP}, \text{AC}) = 10^{1.63 + 0.16\text{BDP} + 0.00111\text{AC}^2 − 0.0000859\text{BDP}\cdot\text{AC}^2) }",
    L"f(\text{BDP}, \text{AC}) = 10^{2.1315 + 0.0056541\text{BDP}\cdot\text{AC} − 0.00015515\text{BDP}\cdot\text{AC}^2 + 0.000019782\text{AC}^3 + 0.052594\text{BDP}) }",
    L"f(\text{BDP}, \text{AC}) = 10^{1.879 + 0.084\text{BDP} + 0.026\text{AC}) }",
    L"f(\text{BDP}, \text{AC}) = −3200.40479 + 157.07186\text{AC} + 15.90391\text{BDP}^2"
]



with_theme(
    Theme(
        palette = (color = [:red, :blue], marker = [:circle, :xcross]),
        ScatterLines = (cycle = [:color, :marker],),
        Lines = (cycle = [:color],)
    )) do
    scatterlines(fill(1, 10))
    scatterlines!(fill(2, 10))
    scatterlines!(fill(3, 10))
    scatterlines!(fill(4, 10))
    scatterlines!(fill(5, 10))
    current_figure()
end