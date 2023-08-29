using CairoMakie, DataFrames, CSV

xtickweek = (1:2:25, string.(14:2:38))
xtickweek2 = (1:4:25, string.(14:4:38))

function fig_BDP_AC_1st_fig()
        size_inches = (8, 10)
        size_pt = 72 .* size_inches
      
        fig = Figure( resolution = size_pt
                 )

        row = 1
        for i in 1:length(BDP_AC_index)
                p = mod(i,2)
                if p == 0
                        ax = Axis(fig[row,p+2],
                                title = df_titles.function[BDP_AC_index[i]],
                                xticks = xtickweek2,
                                titlesize = 10
                        )
                row += 1
                else
                        ax = Axis(fig[row,p],
                                title = df_titles.function[BDP_AC_index[i]],
                                xticks = xtickweek2,
                                titlesize = 10
                        )
                end
                sc1 = scatterlines!(ax, df_data[BDP_AC_index[i]].BDP; label = "BDP")
                sc2 = scatterlines!(ax, df_data[BDP_AC_index[i]].AC; label = "AC")
                if i == length(BDP_AC_index)
                        Legend(fig[0,:], [sc1, sc2], ["BDP", "AC"],
                        L"1st order indices of $f{(\text{BDP}, \text{AC})}$ type formulas "
                        )
                end
        end
        fig
end
fig_BDP_AC_1st_fig()

function AC_FL_HC_1st_fig()
        size_inches = (8, 5)
        size_pt = 72 .* size_inches
      
        fig = Figure( resolution = size_pt
                 )

        row = 1
        for i in 1:length(AC_FL_HC_index)
                p = mod(i,2)
                if p == 0
                        ax = Axis(fig[row,p+2],
                                title = df_titles.function[AC_FL_HC_index[i]],
                                xticks = xtickweek2,
                                titlesize = 10
                        )
                row += 1
                else
                        ax = Axis(fig[row,p],
                                title = df_titles.function[AC_FL_HC_index[i]],
                                xticks = xtickweek2,
                                titlesize = 10
                        )
                end
                sc1 = scatterlines!(ax, df_data[AC_FL_HC_index[i]].AC; label = "BDP")
                sc2 = scatterlines!(ax, df_data[AC_FL_HC_index[i]].FL; label = "AC")
                sc3 = scatterlines!(ax, df_data[AC_FL_HC_index[i]].HC; label = "AC")
                if i == length(AC_FL_HC_index)
                        Legend(fig[0,:], [sc1, sc2, sc3], ["AC", "FL", "HC"],
                        L"1st order indices of $f{(\text{AC}, \text{FL}, \text{HC})}$ type formulas "
                        )
                end
        end
        fig
end
AC_FL_HC_1st_fig()

function AC_FL_HC_2nd_fig()
        size_inches = (8, 5)
        size_pt = 72 .* size_inches
      
        fig = Figure( resolution = size_pt
                 )

        row = 1
        for i in 1:length(AC_FL_HC_index)
                p = mod(i,2)
                if p == 0
                        ax = Axis(fig[row,p+2],
                                title = df_titles.function[AC_FL_HC_index[i]],
                                xticks = xtickweek2,
                                titlesize = 10
                        )
                row += 1
                else
                        ax = Axis(fig[row,p],
                                title = df_titles.function[AC_FL_HC_index[i]],
                                xticks = xtickweek2,
                                titlesize = 10
                        )
                end
                sc1 = scatterlines!(ax, df_data[AC_FL_HC_index[i]].AC_FL; label = "BDP")
                sc2 = scatterlines!(ax, df_data[AC_FL_HC_index[i]].AC_HC; label = "AC")
                sc3 = scatterlines!(ax, df_data[AC_FL_HC_index[i]].FL_HC; label = "AC")
                if i == length(AC_FL_HC_index)
                        Legend(fig[0,:], [sc1, sc2, sc3], ["AC FL", "AC HC", "FL HC"],
                        L"2nd order indices of $f{(\text{AC}, \text{FL}, \text{HC})}$ type formulas "
                        )
                end
        end
        fig
end
AC_FL_HC_2nd_fig()















############################################################################


DFf5r = DataFrame(CSV.File("GSA_results/f5.csv"))
DFf20r = DataFrame(CSV.File("GSA_results/f20.csv"))

function fig1()
    fig = Figure(backgroundcolor = :tomato,
                resolution = (800, 600))
    axA = Axis(fig[1,1],
            title = "AC")
    scA1 = lines!(axA, DFf5r.AC, label = L"f_5")
    scA2 = lines!(axA, DFf20r.AC, label = L"f_20")

    axB = Axis(fig[2,1],
            title = "HC",
            xlabel = "Week")
    scB1 = lines!(axB, DFf5r.HC, label = L"f_5")
    scB2 = lines!(axB, DFf20r.HC, label = L"f_{20}")
    Legend(fig[1:2,2], [scA1,scA2], [L"f_5",L"f_{20}"])
    display(fig)
end
fig1()

function fig2()
    fig = Figure(backgroundcolor = :tomato,
             resolution = (800, 600))
    axA = Axis(fig[1,1],
            title = L"f_5")
    scA1 = scatter!(axA, DFf5r.AC)
    scA2 = scatter!(axA, DFf5r.HC)

    axB = Axis(fig[2,1],
            title = L"f_{20}",
            xlabel = "Week")
    scB1 = scatter!(axB, DFf20r.AC)
    scB2 = scatter!(axB, DFf20r.HC)
    Legend(fig[1:2,2], [scA1,scA2], ["AC","HC"])
    display(fig)    
end
fig2()

DFf8r = DataFrame(CSV.File("GSA_results/f8.csv"))
DFf13r = DataFrame(CSV.File("GSA_results/f13.csv"))

function figBDP_AC_FL_HC_1st()
    size_inches = (7, 5)
    size_pt = 72 .* size_inches

    fig = Figure(backgroundcolor = :tomato, figure_padding = 2,
             resolution = size_pt, fontsize = 12)

    axA = Axis(fig[1,1],
            title = L"f_8")
    scA1 = lines!(axA, DFf8r.BDP, color = "#F32EA1")
    scA2 = lines!(axA, DFf8r.AC,  color = "#0BD976", linestyle = :dash)
    scA3 = lines!(axA, DFf8r.FL,  color = "#FFD92E", linestyle = :dot)
    scA4 = lines!(axA, DFf8r.HC,  color = "#8630BF", linestyle = :dashdot)

    axB = Axis(fig[2,1],
            title = L"f_{13}",
            xlabel = "Week")
    scB1 = lines!(axB, DFf13r.BDP, color = "#F32EA1")
    scB2 = lines!(axB, DFf13r.AC,  color = "#0BD976", linestyle = :dash)
    scB3 = lines!(axB, DFf13r.FL,  color = "#FFD92E", linestyle = :dot)
    scB4 = lines!(axB, DFf13r.HC,  color = "#8630BF", linestyle = :dashdot)
    Legend(fig[:,2], [scA1,scA2,scA3,scA4], ["BDP", "AC", "FL", "HC"]
        )
    fig
end

fig = figBDP_AC_FL_HC_1st()
save("figure2.pdf", fig,pt_per_unit = 1)

function figBDP_AC_FL_HC_2nd()
    linewidth_theme = Theme(linewidth = 2)
    set_theme!(linewidth_theme)

    size_inches = (7, 5)
    size_pt = 72 .* size_inches

    fig = Figure(backgroundcolor = :tomato, figure_padding = 2,
             resolution = size_pt, fontsize = 12)

    axA = Axis(fig[1,1],
            title = L"f_8")
    scA1 = lines!(axA, DFf8r.BDP_AC, color = "#C90130")
    scA2 = lines!(axA, DFf8r.BDP_FL, color = "#574240", linestyle = :dash)
    scA3 = lines!(axA, DFf8r.BDP_HC, color = "#BFA5A3", linestyle = :dot)
    scA4 = lines!(axA, DFf8r.AC_FL,  color = "#427000", linestyle = :dashdot)
    scA5 = lines!(axA, DFf8r.AC_HC,  color = "#7AA400", linestyle = :dashdotdot)
    scA6 = lines!(axA, DFf8r.FL_HC,  color = "#0078D5")

    axB = Axis(fig[2,1],
            title = L"f_{13}",
            xlabel = "Week")
    scB1 = lines!(axB, DFf13r.BDP_AC, color = "#C90130")
    scB2 = lines!(axB, DFf13r.BDP_FL, color = "#574240", linestyle = :dash)
    scB3 = lines!(axB, DFf13r.BDP_HC, color = "#BFA5A3", linestyle = :dot)
    scB4 = lines!(axB, DFf13r.AC_FL,  color = "#427000", linestyle = :dashdot)
    scB5 = lines!(axB, DFf13r.AC_HC,  color = "#7AA400", linestyle = :dashdotdot)
    scB6 = lines!(axB, DFf13r.FL_HC,  color = "#0078D5")
    Legend(fig[:,2], [scA1,scA2,scA3,scA4, scA5, scA6],
        ["BDP and AC", "BDP and FL", "BDP and HC", "AC and FL", "AC and HC", "FL and HC"]
        )
    fig
end

fig = figBDP_AC_FL_HC_2nd()
save("figure2.pdf", fig,pt_per_unit = 1)

function figBDP_AC_FL_HC_Total()
    size_inches = (7, 4)
    size_pt = 72 .* size_inches

    fig = Figure(
             )

    axA = Axis(fig[1,1],
            title = L"f\left(\text{BDP}, \text{AC}, \text{FL}, \text{HC} \right) = 10^{1.3596 + 0.00061\text{BDP}\cdot\text{AC} + 0.424\text{AC} + 0.174\text{FL} + 0.0064\text{HC} − 0.00386\text{AC}\cdot\text{FL}}",
            xticks = xtickweek)
    scA1 = lines!(axA, DFf8r.BDP_T)
    scA2 = lines!(axA, DFf8r.AC_T)
    scA3 = lines!(axA, DFf8r.FL_T)
    scA4 = lines!(axA, DFf8r.HC_T)

    axB = Axis(fig[2,1],
            title = L"f\left(\text{BDP}, \text{AC}, \text{FL}, \text{HC} \right) = 10^{1.6758 + 0.042478\text{BDP} + 0.01707\text{AC} + 0.05216\text{FL} + 0.01604\text{HC}}",
            xticks = xtickweek,
            xlabel = "Week")
    scB1 = lines!(axB, DFf13r.BDP_T)
    scB2 = lines!(axB, DFf13r.AC_T)
    scB3 = lines!(axB, DFf13r.FL_T)
    scB4 = lines!(axB, DFf13r.HC_T)
    Legend(fig[0,:], [scA1, scA2, scA3, scA4], ["BDP", "AC", "FL", "HC"], "Total order"
        )
    fig
end

 fig = figBDP_AC_FL_HC_Total()
save("figure2.pdf", fig,pt_per_unit = 1)


df_f1  = DataFrame(CSV.File("GSA_results/f1.csv"))
df_f3  = DataFrame(CSV.File("GSA_results/f3.csv"))
df_f4  = DataFrame(CSV.File("GSA_results/f4.csv"))
df_f6  = DataFrame(CSV.File("GSA_results/f6.csv"))
df_f16 = DataFrame(CSV.File("GSA_results/f16.csv"))
df_f17 = DataFrame(CSV.File("GSA_results/f17.csv"))
df_f24 = DataFrame(CSV.File("GSA_results/f24.csv"))
df_f25 = DataFrame(CSV.File("GSA_results/f25.csv"))
df_f26 = DataFrame(CSV.File("GSA_results/f26.csv"))

function fig_BDP_AC()
        size_inches = (8, 10)
        size_pt = 72 .* size_inches
    
        dfs = [df_f1, df_f3, df_f4, df_f6, df_f16, df_f17, df_f24, df_f25, df_f26]


        fig = Figure( resolution = size_pt
                 )
        
        row = 1
        for (i,df) in enumerate(dfs)
                p = mod(i,2)
                if p == 0
                        ax = Axis(fig[row,p+2],
                                title = df_titles.function[BDP_AC_index[i]],
                                xticks = xtickweek2,
                                titlesize = 10
                        )
                row += 1
                else
                        ax = Axis(fig[row,p],
                                title = df_titles.function[BDP_AC_index[i]],
                                xticks = xtickweek2,
                                titlesize = 10
                        )
                end
                sc1 = scatterlines!(ax, df.BDP; label = "BDP")
                sc2 = scatterlines!(ax, df.AC; label = "AC")
                if i == length(dfs)
                        Legend(fig[0,:], [sc1, sc2], ["BDP", "AC"],
                        L"1st order indices of $f{(\text{BDP}, \text{AC})}$ type formulas "
                        )
                end
        end
        fig
    end







df_f9  = DataFrame(CSV.File("GSA_results/f9.csv"))

function fig_FL_HC()
        size_inches = (8, 10)
        size_pt = 72 .* size_inches
    
        dfs = [df_f9]

        title_names = [
                L"f(\text{BDP}, \text{AC}) = 10^{-1.599 + 0.144\text{BDP} + 0.032\text{AC} - 0.000111\text{AC}\cdot\text{BDP}^2 }"
        ]
        fig = Figure( resolution = size_pt
                 )
        ax = Axis(fig[1,1],
                xticks = xtickweek2,
                titlesize = 10
                        )
        sc1 = lines!(ax, df_f9.BDP; label = "BDP")
        sc2 = lines!(ax, df_f9.FL; label = "FL")
        sc3 = lines!(ax, df_f9.HC; label = "HC")

        Legend(fig[0,:], [LineElement(color = "#F32EA1", linestyle = nothing), LineElement(color = "#0BD976", linestyle = :dash)],
                ["BDP", "AC"], L"1st order indices of $f(\text{BDP}, \text{AC})$ type formulas "
        )

        fig
end

fig_FL_HC()

#F32EA1
#0BD976