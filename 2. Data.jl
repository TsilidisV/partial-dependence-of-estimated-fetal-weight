# Data
using DataFramesMeta, XLSX, CSV

mtdt = DataFrame(XLSX.readtable("data/bounds.xlsx", "metadata"))

bounds_data = DataFrame(XLSX.readtable("data/bounds.xlsx", "Sheet3"; infer_eltypes=true))

formulas = NamedTuple(
    [(Symbol(mtdt.id[i]), 
        @eval (x) -> $(Meta.parse(mtdt.function[i]))
    ) 
    for i in 1:nrow(mtdt)]
)