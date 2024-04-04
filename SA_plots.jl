# Initialized with plotting.jl
#
include("base_model.jl");

## -- Set up model structures

Model = TickModel

paras_og = Model.model_pars(
    lifespan = 52, #!
    σₜᵢ = 45, #!
    σₜₐ = 50, #!
    σₚᵢ = 70, #!
    σₐᵢ = 5, #!
    σₐₐ = 8, #!
    μₜᵢ = 25, #!
    μₜₐ = 8, #!
    μₚᵢ = 8, #!
    μₐᵢ = 25, #!
    μₐₐ = 8, #!
    # init conds
    fec = 860, #!
    CDWₘₑ = 6, #!
    CDWₘₗ = 6, #!
    CDWₘₙ = 6, #!
    CDWₘₐ = 6, #!
    CDWₑ = 110, #!
    CDWₗ = 58, #!
    CDWₙ = 81, #!
    CDWₐ = 28, #!
    Sₕₗ = 0.9647684, #!
    Sₕₙ = 0.9994695, #!
    Sₕₐ = 0.9999692, #!
    Sₓᵢ₁ = 0.6, #!
    Sₓᵢ₂ = 0.6, #!
    Sₓᵢ₃ = 0.6, #!
    Sₓₐ₁ = 0, #!
    Sₓₐ₂ = 0.6, #!
    Sₓₐ₃ = 0.7746, #!
    Sₘᵢ₁ = 0.2, #!
    Sₘᵢ₂ = 0.2, #!
    Sₘᵢ₃ = 0.2, #!
    Sₘₐ₁ = 0, #!
    Sₘₐ₂ = 0.2, #!
    Sₘₐ₃ = 0.4474, #!
    EIₓ₁ = 0.75, #!
    EIₓ₂ = 4, #!
    EIₓ₃ = 300, #!
    EIₘ₁ = 0.15, #!
    EIₘ₂ = 0.8, #!
    EIₘ₃ = 60, #!
    EIₛₗ = 0.0021, #!
    EIₛₙ = 0.014, #!
    EIₛₐ = 1, #!
    EIₗ = 0.44, #!
    Bₕₗ₁ = 100, #!
    Bₕₗ₂ = 200, #!
    Bₕₗ₃ = 1000, #!
    Bₕₙ₁ = 20, #!
    Bₕₙ₂ = 100, #!
    Bₕₙ₃ = 500, #!
    Bₕₐ₁ = 0, #!
    Bₕₐ₂ = 20, #!
    Bₕₐ₃ = 100, #!
    aₕ₁ = 0.01, #!
    aₕ₂ = 0.025, #!
    aₕ₃ = 0.05, #!
    b = 0.515, #!
    S₁ = 0.9808, #!
    S₂ = 0.9904, #!
    S₃ = 0.9936, #!
    C₁ = 0.75, #!
    C₂ = 0.5, #!
    C₃ = 0, #* nowhere to do this
    TIF = 0.9 #!
    )


function calc_SA_measure(par, par_val)

    input_dir = "/media/jdtsavage22/Research/honors_thesis/SA/Analysis_Data/$par"
    output_dir = "/media/jdtsavage22/Research/honors_thesis/Analysis_Plots"

    #! DIN
    if par == "lifespan" || par == "fec"
        #! questing nymph average
        QN_10_avg = (Matrix(unique(CSV.read("$input_dir/mean_QN.csv", DataFrame, header=false))))
        IQN_10_avg = (Matrix(unique(CSV.read("$input_dir/mean_IQN.csv", DataFrame, header=false))))

        #! questing nymph total max/min
        TOT_QN_10_max = (Matrix(unique(CSV.read("$input_dir/tot_QN_max.csv", DataFrame, header=false))))
        TOT_QN_10_min = (Matrix(unique(CSV.read("$input_dir/tot_QN_min.csv", DataFrame, header=false))))

        #! Questing nymph min
        QN_10_min = (Matrix(unique(CSV.read("$input_dir/min_QN.csv", DataFrame, header=false))))
        IQN_10_min = (Matrix(unique(CSV.read("$input_dir/min_IQN.csv", DataFrame, header=false))))

        #! Questing nymph max
        QN_10_max = (Matrix(unique(CSV.read("$input_dir/max_QN.csv", DataFrame, header=false))))
        IQN_10_max = (Matrix(unique(CSV.read("$input_dir/max_IQN.csv", DataFrame, header=false))))

        #! Questing amplitudes (yearly)
        QN_10_amp = QN_10_max - QN_10_min
        IQN_10_amp = IQN_10_max - IQN_10_min
        TOT_10_amp = TOT_QN_10_max - TOT_QN_10_min

        #! Total NIP min/max for amps and min/max
        TOT_NIP_10_max = (Matrix(unique(CSV.read("$input_dir/tot_NIP_max.csv", DataFrame, header=false))))
        TOT_NIP_10_min = (Matrix(unique(CSV.read("$input_dir/tot_NIP_min.csv", DataFrame, header=false))))
        TOT_NIP_10_amp = TOT_NIP_10_max - TOT_NIP_10_min
    else
        #! questing nymph average
        QN_10_avg = (Matrix((CSV.read("$input_dir/mean_QN.csv", DataFrame, header=false))))
        IQN_10_avg = (Matrix((CSV.read("$input_dir/mean_IQN.csv", DataFrame, header=false))))

        #! questing nymph total max/min
        TOT_QN_10_max = (Matrix((CSV.read("$input_dir/tot_QN_max.csv", DataFrame, header=false))))
        TOT_QN_10_min = (Matrix((CSV.read("$input_dir/tot_QN_min.csv", DataFrame, header=false))))

        #! Questing nymph min
        QN_10_min = (Matrix((CSV.read("$input_dir/min_QN.csv", DataFrame, header=false))))
        IQN_10_min = (Matrix((CSV.read("$input_dir/min_IQN.csv", DataFrame, header=false))))

        #! Questing nymph max
        QN_10_max = (Matrix((CSV.read("$input_dir/max_QN.csv", DataFrame, header=false))))
        IQN_10_max = (Matrix((CSV.read("$input_dir/max_IQN.csv", DataFrame, header=false))))

        #! Questing amplitudes (yearly)
        QN_10_amp = QN_10_max - QN_10_min
        IQN_10_amp = IQN_10_max - IQN_10_min
        TOT_10_amp = TOT_QN_10_max - TOT_QN_10_min

        #! Total NIP min/max for amps and min/max
        TOT_NIP_10_max = (Matrix((CSV.read("$input_dir/tot_NIP_max.csv", DataFrame, header=false))))
        TOT_NIP_10_min = (Matrix((CSV.read("$input_dir/tot_NIP_min.csv", DataFrame, header=false))))
        TOT_NIP_10_amp = TOT_NIP_10_max - TOT_NIP_10_min
    end # end of check for specific annoying paras yes I know it's not pretty.

    IQN_10_amean = mean(IQN_10_avg./(QN_10_avg .+ IQN_10_avg), dims=3)[:, :] #? NIP?
    DIN_10_amean = mean(IQN_10_avg, dims=3)[:, :]

    # mean, min, max, amp for DIN 
    DIN_amean = mean(IQN_10_avg, dims=2)
    DIN_amin = mean(IQN_10_min, dims=2)
    DIN_amax = mean(IQN_10_max, dims=2)
    DIN_aamp = mean(IQN_10_amp, dims=2)

    # mean, min, max, amp for DON
    DON_amean = mean(IQN_10_avg + QN_10_avg, dims=2)
    DON_amin = mean(TOT_QN_10_min, dims=2)
    DON_amax = mean(TOT_QN_10_max, dims=2)
    DON_aamp = mean(TOT_10_amp, dims=2)

    # mean, min, max, amp for NIP
    NIP_amean = mean(IQN_10_avg./(QN_10_avg .+ IQN_10_avg), dims=2)
    NIP_amin = mean(TOT_NIP_10_min, dims=2)
    NIP_amax = mean(TOT_NIP_10_max, dims=2)
    NIP_aamp = mean(TOT_NIP_10_amp, dims=2)

    #! Create table with data.

    pert_vec = [0.9:0.01:1.1;]
    global SA_vec = pert_vec .* par_val
    # print(" \n", SA_vec, " \n")
    if (length(DIN_amean) != length(SA_vec))

	print(length(DIN_amean), " ", length(SA_vec), " \n")
	print(SA_vec, " \n")
        global SA_vec = trunc.(Int64, unique(round.(SA_vec, digits=0)))
	print(SA_vec, " \n")
	print("NEW SA VEC LENGTH", " ", length(SA_vec), " \n")

    end
    # print(" \n", SA_vec, " \n")

    baseline_idx = findall(SA_vec .== par_val)[1]
    perc_pert = round.(SA_vec./SA_vec[baseline_idx] .- 1, digits = 2)
    # print("BASELINE: ", baseline_idx, "\n")
    perc_pert[baseline_idx] = 1
    #print(perc_pert, "\n")

    DIN_mean_perc = DIN_amean./DIN_amean[baseline_idx] .- 1

    #print(DIN_mean_perc)

    DIN_min_perc = DIN_amin./DIN_amin[baseline_idx] .- 1
    DIN_max_perc = DIN_amax./DIN_amax[baseline_idx] .- 1
    DIN_amp_perc = DIN_aamp./DIN_aamp[baseline_idx] .- 1

    DON_mean_perc = DON_amean./DON_amean[baseline_idx] .- 1
    DON_min_perc = DON_amin./DON_amin[baseline_idx] .- 1
    DON_max_perc = DON_amax./DON_amax[baseline_idx] .- 1
    DON_amp_perc = DON_aamp./DON_aamp[baseline_idx] .- 1

    NIP_mean_perc = NIP_amean./NIP_amean[baseline_idx] .- 1
    NIP_min_perc = NIP_amin./NIP_amin[baseline_idx] .- 1
    NIP_max_perc = NIP_amax./NIP_amax[baseline_idx] .- 1
    NIP_amp_perc = NIP_aamp./NIP_aamp[baseline_idx] .- 1

    # calculate SA measures
    print("TEST LENGTHS")
    print(length(DIN_mean_perc), " ", length(perc_pert), " \n")
    DIN_mean_measure = (DIN_mean_perc./perc_pert) # [:], 2:(length(perc_pert)-1))
    DIN_min_measure = (DIN_min_perc./perc_pert) # [:], 2:(length(perc_pert)-1))
    DIN_max_measure = (DIN_max_perc./perc_pert) # [:], 2:(length(perc_pert)-1))
    DIN_amp_measure = (DIN_amp_perc./perc_pert) # [:], 2:(length(perc_pert)-1))

    DON_mean_measure = (DON_mean_perc./perc_pert) # [:], 2:(length(perc_pert)-1))
    DON_min_measure = (DON_min_perc./perc_pert) # [:], 2:(length(perc_pert)-1))
    DON_max_measure = (DON_max_perc./perc_pert) # [:], 2:(length(perc_pert)-1))
    DON_amp_measure = (DON_amp_perc./perc_pert) # [:], 2:(length(perc_pert)-1))

    NIP_mean_measure = (NIP_mean_perc./perc_pert) # [:], 2:(length(perc_pert)-1))
    NIP_min_measure = (NIP_min_perc./perc_pert) # [:], 2:(length(perc_pert)-1))
    NIP_max_measure = (NIP_max_perc./perc_pert) # [:], 2:(length(perc_pert)-1))
    NIP_amp_measure = (NIP_amp_perc./perc_pert) # [:], 2:(length(perc_pert)-1))

    return (imean = DIN_mean_measure, imin = DIN_min_measure, imax = DIN_max_measure, iamp = DIN_amp_measure, dmean = DON_mean_measure, 
    dmin = DON_min_measure, dmax = DON_max_measure, damp = DON_amp_measure, nmean = NIP_mean_measure, nmin = NIP_min_measure, 
    nmax = NIP_max_measure, namp = NIP_amp_measure)
end

paras_list = [
    "lifespan",  "σₜᵢ",  "σₜₐ",  "σₚᵢ",  "σₐᵢ",  "σₐₐ",
     "μₜᵢ",  "μₜₐ",  "μₚᵢ",  "μₐᵢ",  "μₐₐ",  "fec",  "CDWₘₑ",
     "CDWₘₗ",  "CDWₘₙ",  "CDWₘₐ",  "CDWₑ",  "CDWₗ",  "CDWₙ",
     "CDWₐ",  "Sₕₗ",  "Sₕₙ",  "Sₕₐ",  "Sₓᵢ₁",  "Sₓᵢ₂",  "Sₓᵢ₃",
     "Sₓₐ₂",  "Sₓₐ₃",  "Sₘᵢ₁",  "Sₘᵢ₂",  "Sₘᵢ₃",
     "Sₘₐ₂",  "Sₘₐ₃",  "EIₓ₁",  "EIₓ₂",  "EIₓ₃",
     "EIₘ₁",  "EIₘ₂",  "EIₘ₃",  "EIₛₗ",  "EIₛₙ",  "EIₛₐ",  "EIₗ",
     "Bₕₗ₁",  "Bₕₗ₂",  "Bₕₗ₃",  "Bₕₙ₁",  "Bₕₙ₂",  "Bₕₙ₃", 
     "Bₕₐ₂",  "Bₕₐ₃",  "aₕ₁",  "aₕ₂",  "aₕ₃",  "b",  "S₁",  "S₂",
     "S₃",  "C₁",  "C₂",  "TIF"
]
paras_values = [
    paras_og.lifespan, paras_og.σₜᵢ, paras_og.σₜₐ, paras_og.σₚᵢ, paras_og.σₐᵢ, paras_og.σₐₐ,
    paras_og.μₜᵢ, paras_og.μₜₐ, paras_og.μₚᵢ, paras_og.μₐᵢ, paras_og.μₐₐ, paras_og.fec, paras_og.CDWₘₑ,
    paras_og.CDWₘₗ, paras_og.CDWₘₙ, paras_og.CDWₘₐ, paras_og.CDWₑ, paras_og.CDWₗ, paras_og.CDWₙ,
    paras_og.CDWₐ, paras_og.Sₕₗ, paras_og.Sₕₙ, paras_og.Sₕₐ, paras_og.Sₓᵢ₁, paras_og.Sₓᵢ₂, paras_og.Sₓᵢ₃,
    paras_og.Sₓₐ₂, paras_og.Sₓₐ₃, paras_og.Sₘᵢ₁, paras_og.Sₘᵢ₂, paras_og.Sₘᵢ₃,
    paras_og.Sₘₐ₂, paras_og.Sₘₐ₃, paras_og.EIₓ₁, paras_og.EIₓ₂, paras_og.EIₓ₃,
    paras_og.EIₘ₁, paras_og.EIₘ₂, paras_og.EIₘ₃, paras_og.EIₛₗ, paras_og.EIₛₙ, paras_og.EIₛₐ, paras_og.EIₗ,
    paras_og.Bₕₗ₁, paras_og.Bₕₗ₂, paras_og.Bₕₗ₃, paras_og.Bₕₙ₁, paras_og.Bₕₙ₂, paras_og.Bₕₙ₃, 
    paras_og.Bₕₐ₂, paras_og.Bₕₐ₃, paras_og.aₕ₁, paras_og.aₕ₂, paras_og.aₕ₃, paras_og.b, paras_og.S₁, paras_og.S₂,
    paras_og.S₃, paras_og.C₁, paras_og.C₂, paras_og.TIF
]
SA_results_by_para = []

for (par, value) in zip(paras_list, paras_values)
    par_results = calc_SA_measure(par, value)
    push!(SA_results_by_para, par_results)
end

DIN_mean_results = []
DIN_min_results = []
DIN_max_results = []
DIN_amp_results = []

DON_mean_results = []
DON_min_results = []
DON_max_results = []
DON_amp_results = []

NIP_mean_results = []
NIP_min_results = []
NIP_max_results = []
NIP_amp_results = []

for (par, results) in zip(paras_list, SA_results_by_para)
    push!(DIN_mean_results, results[:imean])
    push!(DIN_min_results, results[:imin])
    push!(DIN_max_results, results[:imax])
    push!(DIN_amp_results, results[:iamp])

    push!(DON_mean_results, results[:dmean])
    push!(DON_min_results, results[:dmin])
    push!(DON_max_results, results[:dmax])
    push!(DON_amp_results, results[:damp])
    
    push!(NIP_mean_results, results[:nmean])
    push!(NIP_min_results, results[:nmin])
    push!(NIP_max_results, results[:nmax])
    push!(NIP_amp_results, results[:namp])
end

# example plot

# SA_res_df = DataFrame(S0 = Float64[], S1 = Float64[])

# for result in SA_results
#     push!(SA_res_df, result)
# end

# (Base - Iter)/Base

SA_res_df = DIN_mean_results
SA_ys = 1:length(SA_res_df)
global count = 1
for (y, data) in zip(SA_ys, SA_res_df)
    # data[abs.(data) .< 0.05] .= 0
    scatter(
        data,
        repeat([y], length(data)),
        c = "black", # 1:length(data),
        #cmap = "cividis"
    )
    scatter(
	mean(data),
	y,
	c = "red"
	    )
    xlabel("Sensitivity (percent Δ output/percent Δ parameter)")
    ylabel("Parameter changed")
    # print borderline and significantly sensitive parameters
    if abs(mean(data)) >= 0.1
	    print(mean(data), " ", paras_list[count], " \n")

    end
    global count+=1
end
#colorbar(label = "sensitivity (percent response/percent perturbed) ")
axvline(base, color="black")
# axvline(base-0.05, color="red")
# axvline(base+0.05, color="blue")
yticks(SA_ys, paras_list)
xscale("symlog")

