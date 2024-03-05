using Symbolics

@variables x_1 x_2 x_3 x_4

x_variables = [x_1, x_2, x_3, x_4]

f8d = [build_function( Symbolics.derivative(f8(x_variables), x) , x_variables, expression = Val{false}) for x in x_variables]

f8d[1]([1,1,1,1])

using LinearAlgebra

f8td(x) = sum([f8d[i](x) for (i,xv) in enumerate(x_variables)])

r(x) = [f8d[i](x) ./ f8td(x) for (i,xv) in enumerate(x_variables)]

r([1,1,1,1])

df = DataFrame(XLSX.readtable("data/bounds.xlsx", "mean")) 

using DataFramesMeta


df_w = @subset(df, :week .== 14)
[df[j,i]  for i in 2:ncol(df), j in 1:57]


using CairoMakie

with_theme(theme_black()) do 
    xss = [df[j,i]  for i in 2:ncol(df), j in 1:57]
    yss = [r(xss[:,i]) for i in 1:57]

    fig, ax, sp = series(12:0.5:40, reshape(vcat(yss...), (4,57)),
                labels =["BDP", "AC", "FL", "HC"])
    axislegend(ax)
    fig
end


