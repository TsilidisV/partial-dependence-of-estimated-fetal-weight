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

using XLSX, DataFrames, CSV
using GlobalSensitivity, QuasiMonteCarlo

sheet = "Sheet3"
resulting_directory = "GSA_results/$(sheet)/"
df = DataFrame(XLSX.readtable("data/bounds.xlsx", sheet))     # Reads the bounds of each variable for every week

bootStrapN = 1      # Number of boostrap runs
samplesN = 100000   # Number of sobol samples

########################################################
#####################  BPD AC  #########################

function BPD_AC_gsa(; save = false)
    samples = samplesN
    sampler = SobolSample()

    # Initializes an empty dataframe
    columns = Dict(:BPD => Float64[], :AC => Float64[],
                   :BPD_AC => Float64[],
                   :BPD_T => Float64[], :AC_T => Float64[])
    dfs = Array{DataFrame}(undef, length(BPD_AC_fun))
    for i in 1:length(BPD_AC_fun)
        dfs[i] = DataFrame(columns)
    end

    # Computes the sobol indices and updates the dataframe for each week
    for t in 1:26
        lb = [df.BPD_min[t], df.AC_min[t]]
        up = [df.BPD_max[t], df.AC_max[t]]
        A, B = QuasiMonteCarlo.generate_design_matrices(samples, lb, up, sampler)

        for (f,df) in zip(BPD_AC_fun,dfs)
            res = gsa(f, Sobol(order = [0,1,2], nboot = bootStrapN), A, B)
            push!(df, Dict(:BPD => res.S1[1], :AC => res.S1[2],
                           :BPD_AC => res.S2[1,2],
                           :BPD_T => res.ST[1], :AC_T => res.ST[2])
            )
        end
    end
    
    if save == true
        for (f,df) in zip(BPD_AC_fun,dfs)
            CSV.write(resulting_directory*"$(f).csv", df)
        end
    end

    return dfs
end

df_f1, df_f3, df_f4, df_f6, df_f16, df_f17, df_f24, df_f25, df_f26 = BPD_AC_gsa(save = true)

########################################################
####################### AC HC ##########################

function AC_HC_gsa(; save = false)
    samples = samplesN
    sampler = SobolSample()

    # Initializes an empty dataframe
    columns = Dict(:AC => Float64[], :HC => Float64[],
                   :AC_HC => Float64[],
                   :AC_T => Float64[], :HC_T => Float64[]
            )

    dfs = Array{DataFrame}(undef, length(AC_HC_fun))
    for i in 1:length(AC_HC_fun)
        dfs[i] = DataFrame(columns)
    end

    # Computes the sobol indices and updates the dataframe for each week
    for t in 1:26
        lb = [df.AC_min[t], df.HC_min[t]]
        up = [df.AC_max[t], df.HC_max[t]]
        A, B = QuasiMonteCarlo.generate_design_matrices(samples, lb, up, sampler)

        for (f,df) in zip(AC_HC_fun,dfs)
            res = gsa(f, Sobol(order = [0,1,2], nboot = bootStrapN), A, B)
            push!(df, Dict(:AC => res.S1[1], :HC => res.S1[2],
                           :AC_HC => res.S2[1,2],
                           :AC_T => res.ST[1], :HC_T => res.ST[2]
                )
            )
        end
    end
    
    if save == true
        for (f,df) in zip(AC_HC_fun,dfs)
            CSV.write(resulting_directory*"$(f).csv", df)
        end
    end

    return dfs

end

df_f5, df_f20 = AC_HC_gsa(; save = true)

########################################################
####################  BPD AC FL ########################

function BPD_AC_FL_gsa(; save = false)
    samples = samplesN
    sampler = SobolSample()

    # Initializes an empty dataframe
    columns = Dict(:BPD => Float64[], :AC => Float64[], :FL => Float64[],
                 :BPD_AC => Float64[], :BPD_FL => Float64[], :AC_FL => Float64[],
                 :BPD_T => Float64[], :AC_T => Float64[], :FL_T => Float64[],
            )
    dfs = Array{DataFrame}(undef, length(BPD_AC_FL_fun))
    for i in 1:length(BPD_AC_FL_fun)
        dfs[i] = DataFrame(columns)
    end

    # Computes the sobol indices and updates the dataframe for each week
    for t in 1:26
        lb = [df.BPD_min[t], df.AC_min[t], df.FL_min[t]]
        up = [df.BPD_max[t], df.AC_max[t], df.FL_max[t]]
        A, B = QuasiMonteCarlo.generate_design_matrices(samples, lb, up, sampler)

        for (f,df) in zip(BPD_AC_FL_fun,dfs)
            res = gsa(f, Sobol(order = [0,1,2], nboot = bootStrapN), A, B)
            push!(df, Dict(:BPD => res.S1[1], :AC => res.S1[2], :FL => res.S1[3],
                :BPD_AC => res.S2[1,2], :BPD_FL => res.S2[1,3], :AC_FL => res.S2[2,3],
                :BPD_T => res.ST[1], :AC_T => res.ST[2], :FL_T => res.ST[3]
                )
            )
        end
    end
    
    if save == true
        for (f,df) in zip(BPD_AC_FL_fun,dfs)
            CSV.write(resulting_directory*"$(f).csv", df)
        end
    end

    return dfs
end

df_f7, df_f10, df_f14, df_f15, df_f21 = BPD_AC_FL_gsa(save = true)

########################################################
###################  BPD AC FL HC ######################

function BPD_AC_FL_HC_gsa(; save = false)
    samples = samplesN
    sampler = SobolSample()

    # Initializes an empty dataframe
    columns = Dict(:BPD => Float64[], :AC => Float64[], :FL => Float64[], :HC => Float64[], 
                   :BPD_AC => Float64[], :BPD_FL => Float64[], :BPD_HC => Float64[], :AC_FL => Float64[], :AC_HC => Float64[], :FL_HC => Float64[],
                   :BPD_T => Float64[], :AC_T => Float64[], :FL_T => Float64[], :HC_T => Float64[]
                   )
    dfs = Array{DataFrame}(undef, length(BPD_AC_FL_HC_fun))
    for i in 1:length(BPD_AC_FL_HC_fun)
        dfs[i] = DataFrame(columns)
    end

    # Computes the sobol indices and updates the dataframe for each week
    for t in 1:26
        lb = [df.BPD_min[t], df.AC_min[t], df.FL_min[t], df.HC_min[t]]
        up = [df.BPD_max[t], df.AC_max[t], df.FL_max[t], df.HC_max[t]]
        A, B = QuasiMonteCarlo.generate_design_matrices(samples, lb, up, sampler)

        for (f, df) in zip(BPD_AC_FL_HC_fun, dfs)
            res = gsa(f, Sobol(order = [0,1,2], nboot = bootStrapN), A, B)
            push!(df, Dict(:BPD => res.S1[1], :AC => res.S1[2], :FL => res.S1[3], :HC => res.S1[4],
                :BPD_AC => res.S2[1,2], :BPD_FL => res.S2[1,3], :BPD_HC => res.S2[1,4], :AC_FL => res.S2[2,3], :AC_HC => res.S2[2,4], :FL_HC => res.S2[3,4],
                :BPD_T => res.ST[1], :AC_T => res.ST[2], :FL_T => res.ST[3], :HC_T => res.ST[4]
                )
            ) 
        end
    end

    if save == true
        for (f,df) in zip(BPD_AC_FL_HC_fun,dfs)
            CSV.write(resulting_directory*"$(f).csv", df)
        end
    end
    
    return dfs

end

df_f8, df_f13 = BPD_AC_FL_HC_gsa(; save = true)

########################################################
####################  BPD FL HC ########################

function BPD_FL_HC_gsa(; save = false)
    samples = samplesN
    sampler = SobolSample()

    # Initializes an empty dataframe
    columns = Dict(:BPD => Float64[], :FL => Float64[], :HC => Float64[],
                 :BPD_FL => Float64[], :BPD_HC => Float64[], :FL_HC => Float64[],
                 :BPD_T => Float64[], :FL_T => Float64[], :HC_T => Float64[]
            )

    dfs = Array{DataFrame}(undef, length(BPD_FL_HC_fun))
    for i in 1:length(BPD_FL_HC_fun)
        dfs[i] = DataFrame(columns)
    end

    # Computes the sobol indices and updates the dataframe for each week
    for t in 1:26
        lb = [df.BPD_min[t], df.FL_min[t], df.HC_min[t]]
        up = [df.BPD_max[t], df.FL_max[t], df.HC_max[t]]
        A, B = QuasiMonteCarlo.generate_design_matrices(samples, lb, up, sampler)

        for (f,df) in zip(BPD_FL_HC_fun,dfs)
            res = gsa(f, Sobol(order = [0,1,2], nboot = bootStrapN), A, B)
            push!(df, Dict(:BPD => res.S1[1], :FL => res.S1[2], :HC => res.S1[3],
                :BPD_FL => res.S2[1,2], :BPD_HC => res.S2[1,3], :FL_HC => res.S2[2,3],
                :BPD_T => res.ST[1], :FL_T => res.ST[2], :HC_T => res.ST[3])
            )
        end
    end
    
    if save == true
        for (f,df) in zip(BPD_FL_HC_fun,dfs)
            CSV.write(resulting_directory*"$(f).csv", df)
        end
    end

    return dfs
end

df_f9 = BPD_FL_HC_gsa(; save = true)

########################################################
###################### AC FL ########################

function AC_FL_gsa(; save = false)
    samples = samplesN
    sampler = SobolSample()

    # Initializes an empty dataframe
    columns = Dict(:AC => Float64[], :FL => Float64[],
                   :AC_FL => Float64[],
                   :AC_T => Float64[], :FL_T => Float64[],
                   )
    dfs = Array{DataFrame}(undef, length(AC_FL_fun))
    for i in 1:length(AC_FL_fun)
        dfs[i] = DataFrame(columns)
    end

    # Computes the sobol indices and updates the dataframe for each week
    for t in 1:26
        lb = [df.AC_min[t], df.FL_min[t]]
        up = [df.AC_max[t], df.FL_max[t]]
        A, B = QuasiMonteCarlo.generate_design_matrices(samples, lb, up, sampler)

        for (f, df) in zip(AC_FL_fun, dfs)
            res = gsa(f, Sobol(order = [0,1,2], nboot = bootStrapN), A, B)
            push!(df, Dict(:AC => res.S1[1], :FL => res.S1[2],
                :AC_FL => res.S2[1,2],
                :AC_T => res.ST[1], :FL_T => res.ST[2])
            ) 
        end
    end

    if save == true
        for (f,df) in zip(AC_FL_fun,dfs)
            CSV.write(resulting_directory*"$(f).csv", df)
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

    # Initializes an empty dataframe
    columns = Dict(:AC => Float64[], :FL => Float64[], :HC => Float64[], 
                   :AC_FL => Float64[], :AC_HC => Float64[], :FL_HC => Float64[],
                   :AC_T => Float64[], :FL_T => Float64[], :HC_T => Float64[]
                   )
    dfs = Array{DataFrame}(undef, length(AC_FL_HC_fun))
    for i in 1:length(AC_FL_HC_fun)
        dfs[i] = DataFrame(columns)
    end

    # Computes the sobol indices and updates the dataframe for each week
    for t in 1:26
        lb = [df.AC_min[t], df.FL_min[t], df.HC_min[t]]
        up = [df.AC_max[t], df.FL_max[t], df.HC_max[t]]
        A, B = QuasiMonteCarlo.generate_design_matrices(samples, lb, up, sampler)

        for (f, df) in zip(AC_FL_HC_fun, dfs)
            res = gsa(f, Sobol(order = [0,1,2], nboot = bootStrapN), A, B)
            push!(df, Dict(:AC => res.S1[1], :FL => res.S1[2], :HC => res.S1[3],
                :AC_FL => res.S2[1,2], :AC_HC => res.S2[1,3], :FL_HC => res.S2[2,3],
                :AC_T => res.ST[1], :FL_T => res.ST[2], :HC_T => res.ST[3])
            ) 
        end
    end

    if save == true
        for (f,df) in zip(AC_FL_HC_fun,dfs)
            CSV.write(resulting_directory*"$(f).csv", df)
        end
    end
    
    return dfs

end

df_f12, df_f19, df_f27 = AC_FL_HC_gsa(; save = true)

