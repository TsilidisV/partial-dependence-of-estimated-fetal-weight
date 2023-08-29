using XLSX, DataFrames, CSV
using GlobalSensitivity, QuasiMonteCarlo

df = DataFrame(XLSX.readtable("bounds.xlsx", "Sheet1"))

bootStrapN = 20
samplesN = 100000

########################################################
#####################  BPD AC  #########################

function BDP_AC_gsa(; save = false)
    samples = samplesN
    sampler = SobolSample()

    #dataframe
    columns = Dict(:BDP => Float64[], :AC => Float64[], :BDP_Conf_Int => Float64[], :AC_Conf_Int => Float64[])
    dfs = Array{DataFrame}(undef, length(BDP_AC_fun))
    for i in 1:length(BDP_AC_fun)
        dfs[i] = DataFrame(columns)
    end

    for t in 1:26
        lb = [df.BDP_min[t], df.AC_min[t]]
        up = [df.BDP_max[t], df.AC_max[t]]
        A, B = QuasiMonteCarlo.generate_design_matrices(samples, lb, up, sampler)

        for (f,df) in zip(BDP_AC_fun,dfs)
            res = gsa(f, Sobol(order = [0,1,2], nboot = bootStrapN), A, B)
            push!(df, Dict(:BDP => res.S1[1], :AC => res.S1[2],
                :BDP_Conf_Int => res.S1_Conf_Int[1], :AC_Conf_Int => res.S1_Conf_Int[2])
            )
        end
    end
    
    if save == true
        for (f,df) in zip(BDP_AC_fun,dfs)
            CSV.write("GSA_results/$(f).csv", df)
        end
    end

    return dfs
end

df_f1, df_f3, df_f4, df_f6, df_f16, df_f17, df_f24, df_f25, df_f26 = BDP_AC_gsa(save = true)

########################################################
####################### AC HC ##########################

function AC_HC_gsa(; save = false)
    samples = samplesN
    sampler = SobolSample()

    #dataframe
    columns = Dict(:AC => Float64[], :HC => Float64[],
                   :AC_Conf_Int => Float64[], :HC_Conf_Int => Float64[],
            )

    dfs = Array{DataFrame}(undef, length(AC_HC_fun))
    for i in 1:length(AC_HC_fun)
        dfs[i] = DataFrame(columns)
    end
    
    for t in 1:26
        lb = [df.AC_min[t], df.HC_min[t]]
        up = [df.AC_max[t], df.HC_max[t]]
        A, B = QuasiMonteCarlo.generate_design_matrices(samples, lb, up, sampler)

        for (f,df) in zip(AC_HC_fun,dfs)
            res = gsa(f, Sobol(order = [0,1,2], nboot = bootStrapN), A, B)
            push!(df, Dict(:AC => res.S1[1], :HC => res.S1[2],
                    :AC_Conf_Int => res.S1_Conf_Int[1], :HC_Conf_Int => res.S1_Conf_Int[2])
            )
        end
    end
    
    if save == true
        for (f,df) in zip(AC_HC_fun,dfs)
            CSV.write("GSA_results/$(f).csv", df)
        end
    end

    return dfs

end

df_f5, df_f20 = AC_HC_gsa(; save = true)

########################################################
####################  BPD AC FL ########################

function BDP_AC_FL_gsa(; save = false)
    samples = samplesN
    sampler = SobolSample()

    #dataframe
    columns = Dict(:BDP => Float64[], :AC => Float64[], :FL => Float64[],
                 :BDP_Conf_Int => Float64[], :AC_Conf_Int => Float64[], :FL_Conf_Int => Float64[],
                 :BDP_AC => Float64[], :BDP_FL => Float64[], :AC_FL => Float64[],
                 :BDP_AC_Conf_Int => Float64[], :BDP_FL_Conf_Int => Float64[], :AC_FL_Conf_Int => Float64[],
                 :BDP_T => Float64[], :AC_T => Float64[], :FL_T => Float64[],
                 :BDP_T_Conf_Int => Float64[], :AC_T_Conf_Int => Float64[], :FL_T_Conf_Int => Float64[]
            )
    dfs = Array{DataFrame}(undef, length(BDP_AC_FL_fun))
    for i in 1:length(BDP_AC_FL_fun)
        dfs[i] = DataFrame(columns)
    end

    for t in 1:26
        lb = [df.BDP_min[t], df.AC_min[t], df.FL_min[t]]
        up = [df.BDP_max[t], df.AC_max[t], df.FL_max[t]]
        A, B = QuasiMonteCarlo.generate_design_matrices(samples, lb, up, sampler)

        for (f,df) in zip(BDP_AC_FL_fun,dfs)
            res = gsa(f, Sobol(order = [0,1,2], nboot = bootStrapN), A, B)
            push!(df, Dict(:BDP => res.S1[1], :AC => res.S1[2], :FL => res.S1[3],
                :BDP_Conf_Int => res.S1_Conf_Int[1], :AC_Conf_Int => res.S1_Conf_Int[2], :FL_Conf_Int => res.S1_Conf_Int[3],
                :BDP_AC => res.S2[1,2], :BDP_FL => res.S2[1,3], :AC_FL => res.S2[2,3],
                :BDP_AC_Conf_Int => res.S2_Conf_Int[1,2], :BDP_FL_Conf_Int => res.S2_Conf_Int[1,3], :AC_FL_Conf_Int => res.S2_Conf_Int[2,3],
                :BDP_T => res.ST[1], :AC_T => res.ST[2], :FL_T => res.ST[3],
                :BDP_T_Conf_Int => res.ST_Conf_Int[1], :AC_T_Conf_Int => res.ST_Conf_Int[2], :FL_T_Conf_Int => res.ST_Conf_Int[3])
            )
        end
    end
    
    if save == true
        for (f,df) in zip(BDP_AC_fun,dfs)
            CSV.write("GSA_results/$(f).csv", df)
        end
    end

    return dfs
end

df_f7, df_f10, df_f14, df_f15, df_f21 = BDP_AC_FL_gsa(save = true)

########################################################
###################  BPD AC FL HC ######################

function BPD_AC_FL_HC_gsa(; save = false)
    samples = samplesN
    sampler = SobolSample()

    #dataframe
    columns = Dict(:BDP => Float64[], :AC => Float64[], :FL => Float64[], :HC => Float64[], 
                   :BDP_Conf_Int => Float64[], :AC_Conf_Int => Float64[], :FL_Conf_Int => Float64[], :HC_Conf_Int => Float64[],
                   :BDP_AC => Float64[], :BDP_FL => Float64[], :BDP_HC => Float64[], :AC_FL => Float64[], :AC_HC => Float64[], :FL_HC => Float64[],
                   :BDP_AC_Conf_Int => Float64[], :BDP_FL_Conf_Int => Float64[], :BDP_HC_Conf_Int => Float64[], :AC_FL_Conf_Int => Float64[], :AC_HC_Conf_Int => Float64[], :FL_HC_Conf_Int => Float64[],
                   :BDP_T => Float64[], :AC_T => Float64[], :FL_T => Float64[], :HC_T => Float64[],
                   :BDP_T_Conf_Int => Float64[], :AC_T_Conf_Int => Float64[], :FL_T_Conf_Int => Float64[], :HC_T_Conf_Int => Float64[]
                   )
    dfs = Array{DataFrame}(undef, length(BDP_AC_FL_HC_fun))
    for i in 1:length(BDP_AC_FL_HC_fun)
        dfs[i] = DataFrame(columns)
    end

    for t in 1:26
        lb = [df.BDP_min[t], df.AC_min[t], df.FL_min[t], df.HC_min[t]]
        up = [df.BDP_max[t], df.AC_max[t], df.FL_max[t], df.HC_max[t]]
        A, B = QuasiMonteCarlo.generate_design_matrices(samples, lb, up, sampler)

        for (f, df) in zip(BDP_AC_FL_HC_fun, dfs)
            res = gsa(f, Sobol(order = [0,1,2], nboot = bootStrapN), A, B)
            push!(df, Dict(:BDP => res.S1[1], :AC => res.S1[2], :FL => res.S1[3], :HC => res.S1[4], 
                :BDP_Conf_Int => res.S1_Conf_Int[1], :AC_Conf_Int => res.S1_Conf_Int[2], :FL_Conf_Int => res.S1_Conf_Int[3], :HC_Conf_Int => res.S1_Conf_Int[4],
                :BDP_AC => res.S2[1,2], :BDP_FL => res.S2[1,3], :BDP_HC => res.S2[1,4], :AC_FL => res.S2[2,3], :AC_HC => res.S2[2,4], :FL_HC => res.S2[3,4],
                :BDP_AC_Conf_Int => res.S2_Conf_Int[1,2], :BDP_FL_Conf_Int => res.S2_Conf_Int[1,3], :BDP_HC_Conf_Int => res.S2_Conf_Int[1,4], :AC_FL_Conf_Int => res.S2_Conf_Int[2,3], :AC_HC_Conf_Int => res.S2_Conf_Int[2,4], :FL_HC_Conf_Int => res.S2_Conf_Int[3,4],
                :BDP_T => res.ST[1], :AC_T => res.ST[2], :FL_T => res.ST[3], :HC_T => res.ST[4],
                :BDP_T_Conf_Int => res.ST[1], :AC_T_Conf_Int => res.ST[2], :FL_T_Conf_Int => res.ST[3], :HC_T_Conf_Int => res.ST[4])
            ) 
        end
    end

    if save == true
        for (f,df) in zip(BDP_AC_FL_HC_fun,dfs)
            CSV.write("GSA_results/$(f).csv", df)
        end
    end
    
    return dfs

end

df_f8, df_f13 = BPD_AC_FL_HC_gsa()

########################################################
####################  BPD FL HC ########################

function BDP_FL_HC_gsa(; save = false)
    samples = samplesN
    sampler = SobolSample()

    #dataframe
    columns = Dict(:BDP => Float64[], :FL => Float64[], :HC => Float64[],
                 :BDP_Conf_Int => Float64[], :FL_Conf_Int => Float64[], :HC_Conf_Int => Float64[],
                 :BDP_FL => Float64[], :BDP_HC => Float64[], :FL_HC => Float64[],
                 :BDP_FL_Conf_Int => Float64[], :BDP_HC_Conf_Int => Float64[], :FL_HC_Conf_Int => Float64[],
                 :BDP_T => Float64[], :FL_T => Float64[], :HC_T => Float64[],
                 :BDP_T_Conf_Int => Float64[], :FL_T_Conf_Int => Float64[], :HC_T_Conf_Int => Float64[]
            )

    dfs = Array{DataFrame}(undef, length(BDP_FL_HC_fun))
    for i in 1:length(BDP_FL_HC_fun)
        dfs[i] = DataFrame(columns)
    end

    for t in 1:26
        lb = [df.BDP_min[t], df.FL_min[t], df.HC_min[t]]
        up = [df.BDP_max[t], df.FL_max[t], df.HC_max[t]]
        A, B = QuasiMonteCarlo.generate_design_matrices(samples, lb, up, sampler)

        for (f,df) in zip(BDP_FL_HC_fun,dfs)
            res = gsa(f, Sobol(order = [0,1,2], nboot = bootStrapN), A, B)
            push!(df, Dict(:BDP => res.S1[1], :FL => res.S1[2], :HC => res.S1[3],
                :BDP_Conf_Int => res.S1_Conf_Int[1], :FL_Conf_Int => res.S1_Conf_Int[2], :HC_Conf_Int => res.S1_Conf_Int[3],
                :BDP_FL => res.S2[1,2], :BDP_HC => res.S2[1,3], :FL_HC => res.S2[2,3],
                :BDP_FL_Conf_Int => res.S2_Conf_Int[1,2], :BDP_HC_Conf_Int => res.S2_Conf_Int[1,3], :FL_HC_Conf_Int => res.S2_Conf_Int[2,3],
                :BDP_T => res.ST[1], :FL_T => res.ST[2], :HC_T => res.ST[3],
                :BDP_T_Conf_Int => res.ST_Conf_Int[1], :FL_T_Conf_Int => res.ST_Conf_Int[2], :HC_T_Conf_Int => res.ST_Conf_Int[3])
            )
        end
    end
    
    if save == true
        for (f,df) in zip(BDP_FL_HC_fun,dfs)
            CSV.write("GSA_results/$(f).csv", df)
        end
    end

    return dfs
end

BDP_FL_HC_gsa(; save = true)

########################################################
###################### AC FL ########################

function AC_FL_gsa(; save = false)
    samples = samplesN
    sampler = SobolSample()

    #dataframe
    columns = Dict(:AC => Float64[], :FL => Float64[], 
                   :AC_Conf_Int => Float64[], :FL_Conf_Int => Float64[],
                   :AC_T => Float64[], :FL_T => Float64[],
                   :AC_T_Conf_Int => Float64[], :FL_T_Conf_Int => Float64[]
                   )
    dfs = Array{DataFrame}(undef, length(AC_FL_fun))
    for i in 1:length(AC_FL_fun)
        dfs[i] = DataFrame(columns)
    end

    for t in 1:26
        lb = [df.AC_min[t], df.FL_min[t]]
        up = [df.AC_max[t], df.FL_max[t]]
        A, B = QuasiMonteCarlo.generate_design_matrices(samples, lb, up, sampler)

        for (f, df) in zip(AC_FL_fun, dfs)
            res = gsa(f, Sobol(order = [0,1,2], nboot = bootStrapN), A, B)
            push!(df, Dict(:AC => res.S1[1], :FL => res.S1[2],
                :AC_Conf_Int => res.S1_Conf_Int[1], :FL_Conf_Int => res.S1_Conf_Int[2],
                :AC_T => res.ST[1], :FL_T => res.ST[2],
                :AC_T_Conf_Int => res.ST[1], :FL_T_Conf_Int => res.ST[2])
            ) 
        end
    end

    if save == true
        for (f,df) in zip(AC_FL_fun,dfs)
            CSV.write("GSA_results/$(f).csv", df)
        end
    end
    
    return dfs

end

df_f11, df_f18, df_f22, df_f28 = AC_FL_gsa(; save = true)


########################################################
###################### AC FL HC ########################

function AC_FL_HC_gsa(; save = false)
    samples = samplesN
    sampler = SobolSample()

    #dataframe
    columns = Dict(:AC => Float64[], :FL => Float64[], :HC => Float64[], 
                   :AC_Conf_Int => Float64[], :FL_Conf_Int => Float64[], :HC_Conf_Int => Float64[],
                   :AC_FL => Float64[], :AC_HC => Float64[], :FL_HC => Float64[],
                   :AC_FL_Conf_Int => Float64[], :AC_HC_Conf_Int => Float64[], :FL_HC_Conf_Int => Float64[],
                   :AC_T => Float64[], :FL_T => Float64[], :HC_T => Float64[],
                   :AC_T_Conf_Int => Float64[], :FL_T_Conf_Int => Float64[], :HC_T_Conf_Int => Float64[]
                   )
    dfs = Array{DataFrame}(undef, length(AC_FL_HC_fun))
    for i in 1:length(AC_FL_HC_fun)
        dfs[i] = DataFrame(columns)
    end

    for t in 1:26
        lb = [df.AC_min[t], df.FL_min[t], df.HC_min[t]]
        up = [df.AC_max[t], df.FL_max[t], df.HC_max[t]]
        A, B = QuasiMonteCarlo.generate_design_matrices(samples, lb, up, sampler)

        for (f, df) in zip(AC_FL_HC_fun, dfs)
            res = gsa(f, Sobol(order = [0,1,2], nboot = bootStrapN), A, B)
            push!(df, Dict(:AC => res.S1[1], :FL => res.S1[2], :HC => res.S1[3], 
                :AC_Conf_Int => res.S1_Conf_Int[1], :FL_Conf_Int => res.S1_Conf_Int[2], :HC_Conf_Int => res.S1_Conf_Int[3],
                :AC_FL => res.S2[1,2], :AC_HC => res.S2[1,3], :FL_HC => res.S2[2,3],
                :AC_FL_Conf_Int => res.S2_Conf_Int[1,2], :AC_HC_Conf_Int => res.S2_Conf_Int[1,3], :FL_HC_Conf_Int => res.S2_Conf_Int[2,3],
                :AC_T => res.ST[1], :FL_T => res.ST[2], :HC_T => res.ST[3],
                :AC_T_Conf_Int => res.ST[1], :FL_T_Conf_Int => res.ST[2], :HC_T_Conf_Int => res.ST[3])
            ) 
        end
    end

    if save == true
        for (f,df) in zip(AC_FL_HC_fun,dfs)
            CSV.write("GSA_results/$(f).csv", df)
        end
    end
    
    return dfs

end

df_f12, df_f19, df_f27 = AC_FL_HC_gsa()

