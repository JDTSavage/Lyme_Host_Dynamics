## Plotting of simulation output
using Statistics, CSV, DataFrames, GLM, Tables, PyPlot; pygui(true)
# include("base_model.jl")
# Model = TickModel # Used to load up tick and host pops

## -- Loading in a model:
# num_wks = 52*50
# μ = 45000 # mean acorns
# σ = 0
# lifespan = 52

# location = "Waterville" # File for env. data location.
# CDW_stat = "standard" # Standard CDW or realistic ones?
# load_dir = "R:/honors_thesis/Output_Data/" #"F:/Research_Data/honors_thesis/Output_Data/"
# # load_dir = "Output_Data/" # Test files and init conds.
# sim_name = "mice_$(μ)_$(σ)_$(location)_$(CDW_stat)" # set simname for file
# # sim_name = "test_run3.csv" #

# #! need this to initialize model easily
# if !@isdefined perc_trans
#     perc_trans = Model.effective_transmission() # monte carlo simulation of effective transmission
# end 

# pops
# tick_pop = Model.gen_tick_pop(Model, num_wks, lifespan, perc_trans);
# host_pop = Model.gen_host_pop(Model, num_wks);
# Model.load_pop(tick_pop, host_pop, μ, range, load_dir, sim_name);

# ## - basic plotting example.

# Z = 1

# plot(Z:num_wks, tick_pop.QL[:, 1])
# plot(Z:num_wks, tick_pop.QN[:, 1])
# plot(Z:num_wks, tick_pop.QA[:, 1])

## - Analysis begins:

# Measurements I am seeking out:
#! DON, DIN, NIP

# Also measures of infected mice

# ! Density of Questing Nymphs

# * Ten-year Average Density, Max Density, Min Density

#! standard variables for setting up model things

num_wks = 52*50
lifespan = 52

CDW_stat = "standard" # Standard CDW or realistic ones?
load_dir = "/media/jdtsavage22/Research/honors_thesis/Output_Data/"


locations = [
    "PortlandME_1971-2021", "BostonMA_1971-2021", "ConcordNH_1971-2021", "AugustaGA_1971-2021", 
    "BurlingtonVT_1971-2021", "AlbanyNY_1971-2021", "WashingtonDC_1971-2021", "NorfolkVA_1971-2021",
    "RaleighNC_1971-2021", "AshevilleTN_1971-2021", "RochesterNY_1971-2021", "PittsburghPA_1971-2021",
    "ClevelandOH_1971-2021", "ColumbusOH_1971-2021", "DetroitMI_1971-2021", 
    "TopekaKS_1971-2021", "DallasFortWorthTX_1971-2021", "MinneapolisMN_1971-2021", 
    "BismarkND_1971-2021", "DenverCO_1971-2021", "JacksonMS_1971-2021", "StLouisMO_1971-2021"]

# for location in locations

#     mkdir("Analysis_Data/$location/")

# end
#location = "PortlandME_1971-2021"

Threads.@threads for location in locations

    print(location, " $(Threads.threadid())\n")

    μ_vec = [0:1:99;]
    σ_vec = [0:1:99;]

    QL_10_avg = zeros(length(μ_vec) * length(σ_vec), 10)
    QL_10_max = zeros(length(μ_vec) * length(σ_vec), 10)
    QN_10_avg = zeros(length(μ_vec) * length(σ_vec), 10)
    IQN_10_avg = zeros(length(μ_vec) * length(σ_vec), 10)
    QN_10_min = zeros(length(μ_vec) * length(σ_vec), 10)
    IQN_10_min = zeros(length(μ_vec) * length(σ_vec), 10)
    QN_10_max = zeros(length(μ_vec) * length(σ_vec), 10)
    IQN_10_max = zeros(length(μ_vec) * length(σ_vec), 10)
    TOT_QN_10_max = zeros(length(μ_vec) * length(σ_vec), 10)
    TOT_QN_10_min = zeros(length(μ_vec) * length(σ_vec), 10)
    TOT_NIP_10_max = zeros(length(μ_vec) * length(σ_vec), 10)
    TOT_NIP_10_min = zeros(length(μ_vec) * length(σ_vec), 10)

    # SM_10_avg = zeros(length(μ_vec) * length(σ_vec), 10)
    # ISM_10_avg = zeros(length(μ_vec) * length(σ_vec), 10)
    # SM_10_min = zeros(length(μ_vec) * length(σ_vec), 10)
    # ISM_10_min = zeros(length(μ_vec) * length(σ_vec), 10)
    # SM_10_max = zeros(length(μ_vec) * length(σ_vec), 10)
    # ISM_10_max = zeros(length(μ_vec) * length(σ_vec), 10)

    for i in 1:length(μ_vec)
        for j in 1:length(σ_vec)
            print("in Loop $i, $j\n")

            μ = μ_vec[i]
            σ = σ_vec[j]
            
            row = (i - 1) * 100 + j

            sim_name = "lifespan_52_mice_$(μ)_$(σ)_$(location)_$(CDW_stat).csv" # set simname for file access

            # QL = Matrix(DataFrame(CSV.File(load_dir * "QL/" * sim_name, header=false)))[end-(10*52)+1:end, 1]
            # QL_10_avg[row, :] = mean.(collect(Iterators.partition(QL, 52)))
            # QL_10_max[row, :] = maximum.(collect(Iterators.partition(QL, 52)))


            QN = Matrix(DataFrame(CSV.File(load_dir * "QN/" * sim_name, header=false)))[end-(10*52)+1:end, 1]
            IQN = Matrix(DataFrame(CSV.File(load_dir * "IQN/" * sim_name, header=false)))[end-(10*52)+1:end, 1]

            # SM = Matrix(DataFrame(CSV.File(load_dir * "SM/" * sim_name, header=false)))[end-(10*52)+1:end, 1]
            # ISM = Matrix(DataFrame(CSV.File(load_dir * "ISM/" * sim_name, header=false)))[end-(10*52)+1:end, 1]

            QN_10_avg[row, :] = mean.(collect(Iterators.partition(QN, 52)))
            IQN_10_avg[row, :] = mean.(collect(Iterators.partition(IQN, 52)))

            QN_10_min[row, :] = minimum.(collect(Iterators.partition(QN, 52)))
            IQN_10_min[row, :] = minimum.(collect(Iterators.partition(IQN, 52)))

            QN_10_max[row, :] = maximum.(collect(Iterators.partition(QN, 52)))
            IQN_10_max[row, :] = maximum.(collect(Iterators.partition(IQN, 52)))

            QN_sum = collect(Iterators.partition(QN .+ IQN, 52))
            NIP_sum = collect(Iterators.partition(IQN./(QN .+ IQN), 52))
            TOT_QN_10_max[row, :] = maximum.(QN_sum)
            TOT_QN_10_min[row, :] = minimum.(QN_sum)
            
            TOT_NIP_10_max[row, :] = maximum.(NIP_sum)
            TOT_NIP_10_min[row, :] = minimum.(NIP_sum)

            # SM_10_avg[row, :] = mean.(collect(Iterators.partition(SM, 52)))
            # ISM_10_avg[row, :] = mean.(collect(Iterators.partition(ISM, 52)))

            # SM_10_min[row, :] = minimum.(collect(Iterators.partition(SM, 52)))
            # ISM_10_min[row, :] = minimum.(collect(Iterators.partition(ISM, 52)))

            # SM_10_max[row, :] = maximum.(collect(Iterators.partition(SM, 52)))
            # ISM_10_max[row, :] = maximum.(collect(Iterators.partition(ISM, 52)))

            #! Now that we have the time series, take last ten years and extract average tick densities per year
                #! μ × σ × 10 years
                    #! μ × σ in 10 files/subfolders
        end
    end

    output_dir = "Analysis_Data"

	####################### remove n to overwrite standard files.

    CSV.write("$output_dir/$location/nlifespan_52_tot_QN_max.csv", Tables.table(TOT_QN_10_max), writeheader=false)
    CSV.write("$output_dir/$location/nlifespan_52_tot_QN_min.csv", Tables.table(TOT_QN_10_min), writeheader=false)

    CSV.write("$output_dir/$location/nlifespan_52_tot_NIP_max.csv", Tables.table(TOT_NIP_10_max), writeheader=false)
    CSV.write("$output_dir/$location/nlifespan_52_tot_NIP_min.csv", Tables.table(TOT_NIP_10_min), writeheader=false)

    CSV.write("$output_dir/$location/nlifespan_52_mean_QL.csv", Tables.table(QL_10_avg), writeheader=false)
    CSV.write("$output_dir/$location/nlifespan_52_max_QL.csv", Tables.table(QL_10_max), writeheader=false)

    CSV.write("$output_dir/$location/nlifespan_52_mean_QN.csv", Tables.table(QN_10_avg), writeheader=false)
    CSV.write("$output_dir/$location/nlifespan_52_mean_IQN.csv", Tables.table(IQN_10_avg), writeheader=false)

    CSV.write("$output_dir/$location/nlifespan_52_min_QN.csv", Tables.table(QN_10_min), writeheader=false)
    CSV.write("$output_dir/$location/nlifespan_52_min_IQN.csv", Tables.table(IQN_10_min), writeheader=false)

    CSV.write("$output_dir/$location/nlifespan_52_max_QN.csv", Tables.table(QN_10_max), writeheader=false)
    CSV.write("$output_dir/$location/nlifespan_52_max_IQN.csv", Tables.table(IQN_10_max), writeheader=false)


    # CSV.write("$output_dir/$location/lifespan_52_mean_SM.csv", Tables.table(SM_10_avg), writeheader=false)
    # CSV.write("$output_dir/$location/lifespan_52_mean_ISM.csv", Tables.table(ISM_10_avg), writeheader=false)

    # CSV.write("$output_dir/$location/lifespan_52_min_SM.csv", Tables.table(SM_10_min), writeheader=false)
    # CSV.write("$output_dir/$location/lifespan_52_min_ISM.csv", Tables.table(ISM_10_min), writeheader=false)

    # CSV.write("$output_dir/$location/lifespan_52_max_SM.csv", Tables.table(SM_10_max), writeheader=false)
    # CSV.write("$output_dir/$location/lifespan_52_max_ISM.csv", Tables.table(ISM_10_max), writeheader=false)

end
