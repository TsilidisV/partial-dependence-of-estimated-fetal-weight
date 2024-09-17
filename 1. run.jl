using DataFramesMeta, XLSX, CSV
using Combinatorics
using LinearAlgebra
using GlobalSensitivity, QuasiMonteCarlo
using CairoMakie

include("2. Data.jl")
include("3. Figure.jl")
include("4. Tables.jl")

include("gsa_calc_new.jl")



fig1 = with_theme(theme_UOG()) do
    fig_weight_formula_gsa(@rsubset(mtdt, :id in ["f3", "f7", "f11", "f8", "f9", "f10","f22", "f29", "f30", "f31"]))
end
save("figs/fig1.png", fig1)

weight_formula_gsa(@subset(mtdt, :id .!= "f23" ); save = true)
weight_formula_gsa(@subset(mtdt, :id .== "f22" ); save = true)

table_maker(@rsubset(mtdt, :vars in ["AC, FL"]); save = "AC, FL")
table_maker(@rsubset(mtdt, :vars in ["AC, FL, HC"]); save = "AC, FL, HC")
table_maker(@rsubset(mtdt, :vars in ["AC, HC"]); save = "AC, HC")
table_maker(@rsubset(mtdt, :vars in ["BPD, AC"]); save = "BPD, AC")
table_maker(@rsubset(mtdt, :vars in ["BPD, AC, FL"]); save = "BPD, AC, FL")
table_maker(@rsubset(mtdt, :vars in ["BPD, AC, FL, HC"]); save = "BPD, AC, FL, HC")

formulas[Symbol(mtdt.id[22])]

@subset(mtdt, :id .== "f22" )

fig2 = with_theme(theme_UOG()) do
    fig_weight_formula_gsa((@subset(mtdt, :id .!= "f23" )))
end

figSup = with_theme(theme_UOG()) do
    fig_weight_formula_gsa((@subset(mtdt, :id .!= "f23" )))
end
save("figs/figSup.pdf", figSup)

