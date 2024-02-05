@variables x_1 x_2 x_3 x_4

function r(f, x_variables)
    fd = [build_function(Symbolics.derivative(f(x_variables), x), x_variables,
        expression=Val{false}) for x in x_variables]
    ftd(x) = sum([fd[i](x) for (i, xv) in enumerate(x_variables)])
    rr(x) = [fd[i](x) ./ ftd(x) for (i, xv) in enumerate(x_variables)]

    return x -> rr(x)
end

f8r = r(f8, [x_1, x_2, x_3, x_4])

trol([1, 1, 1, 1])

typeof(f8)

typeof(trol)

using GlobalSensitivity, QuasiMonteCarlo

A, B = QuasiMonteCarlo.generate_design_matrices(100000, ones(4), 2ones(4), SobolSample())
res = gsa(x -> trol(x)[1], Sobol(order=[0, 1, 2]), A, B)
res2 = gsa(trol, Sobol(order=[0, 1, 2]), A, B)
res.S1
res2.S1

function gsa_BPD_AC_FL_HC_r(f; save=false)
    samples = 1000000
    sampler = SobolSample()
    variable_dim = 4

    # Initializes an empty dataframe
    columns = Dict(
        :BPD => Float64[], :AC => Float64[], :FL => Float64[], :HC => Float64[],
        :BPD_AC => Float64[], :BPD_FL => Float64[], :BPD_HC => Float64[], :AC_FL => Float64[], :AC_HC => Float64[], :FL_HC => Float64[],
        :BPD_T => Float64[], :AC_T => Float64[], :FL_T => Float64[], :HC_T => Float64[]
    )
    dfs = Array{DataFrame}(undef, variable_dim)
    for i in 1:variable_dim
        dfs[i] = DataFrame(columns)
    end

    fr = r(f, [x_1, x_2, x_3, x_4])

    # Computes the sobol indices and updates the dataframe for each week
    for t in 1:26
        lb = [df.BPD_min[t], df.AC_min[t], df.FL_min[t], df.HC_min[t]]
        up = [df.BPD_max[t], df.AC_max[t], df.FL_max[t], df.HC_max[t]]
        A, B = QuasiMonteCarlo.generate_design_matrices(samples, lb, up, sampler)

        for (i, dfi) in enumerate(dfs)
            res = gsa(x -> fr(x)[i], Sobol(order=[0, 1, 2]), A, B)
            push!(dfi, Dict(
                :BPD => res.S1[1], :AC => res.S1[2], :FL => res.S1[3], :HC => res.S1[4],
                :BPD_AC => res.S2[1, 2], :BPD_FL => res.S2[1, 3], :BPD_HC => res.S2[1, 4], :AC_FL => res.S2[2, 3], :AC_HC => res.S2[2, 4], :FL_HC => res.S2[3, 4],
                :BPD_T => res.ST[1], :AC_T => res.ST[2], :FL_T => res.ST[3], :HC_T => res.ST[4]
            )
            )
        end
    end

    return dfs

end

@time res = gsa_BPD_AC_FL_HC_r(f8)

res[1]
res[2]
res[3]
res[4]