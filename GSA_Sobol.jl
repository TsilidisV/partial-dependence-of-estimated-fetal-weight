f1(x)  = 10^(-1.599 + 0.144*x[1] + 0.032*x[2] - 0.000111*x[2]*x[1]^2) # BPD, AC
f2(x)  = ?
f3(x)  = 10^(-1.7492 + 0.166*x[1] + 0.046*x[2] - 0.002646*x[1]*x[2]) # BPD, AC
f4(x)  = 10^(-1.1683 + 0.095*x[1] + 0.0377*x[2] - 0.0015*x[1]*x[2])   # BPD, AC
f5(x)  = 10^(0.9119 + 0.0824*x[1] + 0.0488*x[2] - 0.001599*x[1]*x[2]) # AC, HC
f6(x)  = 9.337*x[1]*x[2] - 229 # BPD, AC
f7(x)  = 10^(1.1134 + 0.1694*x[1] + 0.05845*x[2] - 0.007365*x[1]^2 - 0.000604*x[2]^2 + 0.000595*x[1]*x[2]) # BPD, AC, FL
f8(x)  = 10^(1.3596 + 0.00061*x[1]*x[2] + 0.424*x[2] + 0.174*x[3] + 0.0064*x[4] − 0.00386*x[2]*x[3]) # BPD, AC, FL, HC
f9(x)  = 10^(1.326 − 0.00326*x[1]*x[2] + 0.0107*x[3] + 0.0438*x[1] + 0.158*x[2]) # BPD, FL, HC
f10(x) = 10^(1.335 − 0.0034*x[2]*x[3] + 0.0316*x[1] + 0.0457*x[2] + 0.1623*x[3]) # BPD, AC, FL
f11(x) = 10^(1.304 + 0.05281*x[1] + 0.1938*x[2] − 0.004*x[1]*x[2]) # AC, FL
f12(x) = 10^(-2.0661 + 0.04355*x[3] + 0.05394*x[1] − 0.0008582*x[1]*x[3] + 1.2594*(x[2]/x[1]) ) # AC, FL, HC
f13(x) = 10^(1.6758 + 0.01707*x[2] + 0.042478*x[1] + 0.05216*x[3] + 0.01604*x[4])   # BPD, AC, FL, HC
f14(x) = 10^(1.54 + 0.15*x[1] + 0.00111*x[2]^2 − 0.0000764*x[1]*x[2]^2 + 0.05*x[3] − 0.000992*x[2]*x[3]) # BPD, AC, FL
f15(x) = 10^(1.13705 + 0.15549*x[1] + 0.04864*x[2] − 2.79682*x[1]*x[2]/1000 + 0.037769*x[3] − 4.94529*x[2]*x[3]/10000) # BPD, AC, FL
f16(x) = 10^(1.13 + 0.181864*x[1] + 0.0517505*x[2] − 3.34825*x[1]*x[2]/1000)  # BPD, AC
f17(x) = 10^(1.63 + 0.16*x[1] + 0.00111*x[2]^2 − 0.0000859*x[1]*x[2]^2)     # BPD, AC
f18(x) = 10^(0.59 + 0.08*x[1] + 0.28*x[2] − 0.00716*x[1]*x[2])              # AC, FL
f19(x) = 10^(1.6961 + 0.02253*x[3] + 0.01645*x[1] + 0.06439*x[2])           # AC, FL, HC
f20(x) = 10^(1.6575 + 0.04035*x[2] + 0.01285*x[1])                          # AC, HC
f21(x) = 1.4*x[1]*x[2]*x[3] − 200                                           # BPD, AC, FL
f22(x) = 10^(2.792 + 0.108*x[2] + 0.000036*x[1]^2 − 0.00027*x[1]x[2])       # AC, FL
f23(x) = ?
f24(x) = 10^(2.1315 + 0.0056541*x[1]*x[2] − 0.00015515*x[1]*x[2]^2 + 0.000019782*x[2]^3 + 0.052594*x[1]) # BPD, AC
f25(x) = 10^(1.879 + 0.084*x[1] + 0.026*x[2])               # BPD, AC
f26(x) = -3200.40479 + 157.07186*x[2] + 15.90391*x[1]^2     # BPD, AC
f27(x) = 0.23718*x[1]^2 * x[2] + 0.03312*x[3]^3             # AC, FL, HC
f28(x) = 10^(0.77125 + 0.13244*x[1] − 0.12996*x[2] − (1.73588*x[1]^2)/1000 + 3.09212*x[1]*x[2]/1000 + 2.18984*x[2]/x[1]) # AC, FL

BPD_AC_fun = [f1, f3, f4, f6, f16, f17, f24, f25, f26]
BPD_AC_index = [1, 3, 4, 6, 16, 17, 24, 25, 26]
AC_HC_fun = (f5, f20)
AC_HC_index = [5, 20]
BPD_AC_FL_fun = [f7, f10, f14, f15, f21]
BPD_AC_FL_index = [7, 10, 14, 15, 21]
BPD_AC_FL_HC_fun = [f8, f13]
BPD_AC_FL_HC_index = [8, 13]
BPD_FL_HC_fun = [f9]
BPD_FL_HC_index = [9]
AC_FL_fun = [f11, f18, f22, f28]
AC_FL_index = [11, 18, 22, 28]
AC_FL_HC_fun = [f12, f19, f27]
AC_FL_HC_index = [12, 19, 27]


df_data = Array{DataFrame}(undef, 28)
for i in 1:28
    df_data[i] = DataFrame(CSV.File("GSA_results/f$(i).csv"))
end


titles = [
["Warsof (1977)"	     L"10^{-1.599+0.144\left(\text{BPD}\right)+0.032\left(\text{AC}\right)-0.000111\left(\text{BPD}\right)^2\left(\text{AC}\right)}"]
["Shepard (1982)"	     ""]
["Shepard (1982)"	     L"10^{-1.7492+0.166\left(\text{BPD}\right)+0.046\left(\text{AC}\right)-0.002646\left(\text{BPD}\right)\left(\text{AC}\right)}"]
["Jordaan (1983)"	     L"10^{-1.1683+0.0377\left(\text{AC}\right)+0.095\left(\text{BPD}\right)-0.0015\left(\text{BPD}\right)\left(\text{AC}\right)}"]
["Jordaan (1983)"	     L"10^{0.9119+0.0488\left(\text{HC}\right)+0.0824\left(\text{AC}\right)+0.001599\left(\text{AC}\right)\left(\text{HC}\right)}"]
["Thurnau	 "           L"9.337\left(\text{BPD}\right)\left(\text{AC}\right) - 229"]
["Hadlock (1984)"	     L"10^{1.1134+0.05845\left(\text{AC}\right)-0.000604\left(\text{AC}\right)^2-0.007365\left(\text{BPD}\right)^2+0.000595\left(\text{BPD}\right)\left(\text{AC}\right)+0.1694\left(\text{BPD}\right)}"]
["Hadlock (1985)"	     L"10^{1.3596+0.00061\left(\text{BPD}\right)\left(\text{AC}\right)+0.424\left(\text{AC}\right)+0.174\left(\text{FL}\right)+0.0064\left(\text{HC}\right)-0.00386\left(\text{AC}\right)\left(\text{FL}\right)}"]
["Hadlock (1985)"	     L"10^{1.326-0.00326\left(\text{AC}\right)\left(\text{FL}\right)+0.0107\left(\text{HC}\right)+0.0438\left(\text{AC}\right)+0.158\left(\text{FL}\right)}"]
["Hadlock (1985)"	     L"10^{1.335-0.0034\left(\text{AC}\right)\left(\text{FL}\right)+0.0316\left(\text{BPD}\right)+0.0457\left(\text{AC}\right)+0.1623\left(\text{FL}\right)}"]
["Hadlock (1985)"	     L"10^{1.304+0.05281\left(\text{AC}\right)+0.1938\left(\text{FL}\right)-0.004\left(\text{AC}\right)\left(\text{FL}\right)}"]
["Ott (1985)"	         L"10^{-2.0661+0.04355\left(\text{HC}\right)+0.05394\left(\text{AC}\right)-0.0008582\left(\text{AC}\right)\left(\text{HC}\right)+1.2594\frac{\left(\text{FL}\right)}{\left(\text{AC}\right)}}"]
["Roberts (1985)"	     L"10^{1.6758+0.01707\left(\text{AC}\right)+0.042478\left(\text{BPD}\right)+0.05216\left(\text{FL}\right)+0.01604\left(\text{HC}\right)}"]
["Woo (1985)"	         L"10^{1.54+0.15\left(\text{BPD}\right)+0.00111\left(\text{AC}\right)^2-0.0000764\left(\text{BPD}\right)\left(\text{AC}\right)^2+0.05\left(\text{FL}\right)-0.000992\left(\text{AC}\right)\left(\text{FL}\right)}"]
["Woo (1985)"	         L"10^{1.13705+0.15549\left(\text{BPD}\right)+0.04864\left(\text{AC}\right)-2.79682\left(\text{BPD}\right)\left(\text{AC}\right)/1000+0.037769\left(\text{FL}\right)-4.94529\left(\text{AC}\right)\left(\text{FL}\right)/10000}"]
["Woo (1985)"	         L"10^{1.13+0.181864\left(\text{BPD}\right)+0.0517505\left(\text{AC}\right)-3.34825\left(\text{BPD}\right)\left(\text{AC}\right)/1000}"]
["Woo (1985)"	         L"10^{1.63+0.16\left(\text{BPD}\right)+0.00111\left(\text{AC}\right)^2-0.0000859\left(\text{BPD}\right)\left(\text{AC}\right)^2}"]
["Woo (1985)"	         L"10^{0.59+0.08\left(\text{AC}\right)+0.28\left(\text{FL}\right)-0.00716\left(\text{AC}\right)\left(\text{FL}\right)}"]
["Weiner (1985)"	     L"10^{1.6961+0.02253\left(\text{HC}\right)+0.01645\left(\text{AC}\right)+0.06439\left(\text{FL}\right)}"]
["Weiner (1985)"	     L"10^{1.6575+0.04035\left(\text{HC}\right)+0.01285\left(\text{AC}\right)}"]
["Woo (1986)"	         L"1.4\left(\text{BPD}\right)\left(\text{AC}\right)\left(\text{HC}\right)-200"]
["Warsof (1986)"	     L"10^{2.792+0.108\left(\text{FL}\right)+0.000036\left(\text{AC}\right)^2-0.00027\left(\text{AC}\right)\left(\text{FL}\right)}"]
["Shinozuka (1987)"	     ""]
["Hsieh (1987)"	         L"10^{2.1315+0.0056541\left(\text{BPD}\right)\left(\text{AC}\right)-0.00015515\left(\text{BPD}\right)\left(\text{AC}\right)^2+0.000019782\left(\text{AC}\right)^3+0.052594\left(\text{BPD}\right)}"]
["Vintzileos (1987)"	 L"10^{1.879+0.084\left(\text{BPD}\right)+0.026\left(\text{AC}\right)}"]
["Merz (1988)"	         L"3200.40479+157.07186\left(\text{AC}\right)+15.90391\left(\text{BPD}\right)^2"]
["Combs (1993)"	         L"0.23718\left(\text{AC}\right)^2\left(\text{FL}\right)+0.03312\left(\text{HC}\right)^3"]
["Ferrero (1994)"	     L"10^{ 0.77125+0.13244\left(\text{AC}\right)-0.12996\left(\text{FL}\right)-1.73588\left(\text{AC}\right)^2/1000+3.09212\left(\text{AC}\right)\left(\text{FL}\right)/1000+2.18984\left(\text{FL}\right)/\left(\text{AC}\right)}"]
]

df_titles = DataFrame(titles, [:name, :function])

df_titles.name

AM = [x-> x[1]+1+x[2], x->x[1]*x[2]]

AM[1]([2,4])

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

var_line = Dict(
    :BPD    => nothing,
    :AC     => :dashed,
    :FL     => :dot,
    :HC     => :dashdot,
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


df_data[3]