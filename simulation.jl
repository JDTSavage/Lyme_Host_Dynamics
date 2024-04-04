#########
# Author: Joseph D.T. Savage
# Date: February 24, 2022
# Top-level code to run Lyme disease population model
#########

## -- Import modules
using Random, Distributions
# using ThreadingU-- tilities
include("base_model.jl"); 

## -- Set up model structures

Model = TickModel # Model module contains important functions and libraries

# slow to run, only needs to run once if not defined.
if !@isdefined perc_trans
    perc_trans = Model.effective_transmission() # monte carlo simulation of effective transmission
end 

# ## - Initialize model inputs

# num_wks = 52*50
# lifespan = 40
# location = "Waterville" # File for env. data location.
# CDW_stat = "standard" # Standard CDW or realistic ones?

# # Tick population structure stores all matrices for the tick population,
# # for each life stage they pass through as well as matrices tracking 
# # CDW and effective_transmission.
# tick_pop = Model.gen_tick_pop(Model, num_wks, lifespan, perc_trans);

# # Hosts exist as susceptible and infected categories, but are not
# # stage-structured.
# host_pop = Model.gen_host_pop(Model, num_wks);

# # Environemntal data includes humidity, temperature, and seed availability
# # this data is weekly
# # Weather from file
# # Acorns from distribution
# filename = "Input_Data/$(location).csv"
# env_data = Model.gen_environment(Model, filename, num_wks);

# μ = 40
# σ = 10
# # ac_rang = 0
# # min = μ - ac_rang/2
# # max = μ + ac_rang/2 + 1e-10

# Mice = Model.gen_mouse_yearly(μ, σ, num_wks); 
# Mice[Mice .< 0, 1] .= 0 

# env_data.H[:, :] = Mice # Example set up of new acorns

# # Tick + host pop init. 
# Model.initialize_pop(tick_pop, host_pop, "Input_Data")

# ## Run model single time

# sim_name = "test" #"acorn_$(μ)_$(ac_rang)_$(location)_$(CDW_stat)"
# output_dir = "Output_Data"
# Model.run_model(Model, tick_pop, host_pop, env_data, num_wks, lifespan, sim_name, output_dir);

## Run model for many par values:

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

# static parameters:
num_wks = 52*50
lifespan = paras_og.lifespan
CDW_stat = "standard" # Standard CDW or realistic ones?


locations = [
     "PortlandME_1971-2021", "BostonMA_1971-2021", "ConcordNH_1971-2021", "AugustaGA_1971-2021", 
     "BurlingtonVT_1971-2021", "AlbanyNY_1971-2021", "WashingtonDC_1971-2021", "NorfolkVA_1971-2021",
     "RaleighNC_1971-2021", "AshevilleTN_1971-2021", "RochesterNY_1971-2021", "PittsburghPA_1971-2021",
     "ClevelandOH_1971-2021", "ColumbusOH_1971-2021", "DetroitMI_1971-2021", 
     "TopekaKS_1971-2021", "DallasFortWorthTX_1971-2021", "MinneapolisMN_1971-2021", 
     "BismarkND_1971-2021", "DenverCO_1971-2021", "JacksonMS_1971-2021", "StLouisMO_1971-2021"]

# #! For skipping runs that were successful
# d = 1
# already_run = []
# for location in locations
    
#     if isfile("R:/honors_thesis/Output_Data/Mice/mice_0_0_$(location)_standard.csv")
#         print(location, " skipping\n")
#         push!(already_run, d)
#     end
#     global d += 1
# end
# # already_run
# # locations
# locations = deleteat!(locations, already_run)

# for location in locations
#     print(location, " will run\n")
#** end

#! Thread this loop to run multiple weather locations.
Threads.@threads for location in locations
    # location = "PortlandME_1971-2021"
    #? testDF = DataFrame(CSV.read("Input_Data/$(RAW_location)_1971-2021.csv", DataFrame))
    #? print(testDF[1:5, :], " $location\n")
    # ? location = "PortlandME_1971-2021" # File for env. data location.

    #* if isfile("R:/honors_thesis/Output_Data/Mice/mice_0_0_$(location)_standard.csv")
    #     print(location, " skipping\n")
    #     continue
    # end
    print(location, " \n")

    #! Set input filenames and output dirs.
    input_filename = "Input_Data/$(location).csv"
    output_dir = "/media/jdtsavage22/Research/honors_thesis/Output_Data"
    # output_dir = "Output_Data" # For sim testing or init conds generation

    #! Start tick pops + load environment
    tick_pop = Model.gen_tick_pop(Model, num_wks, lifespan, perc_trans, paras_og); 
    host_pop = Model.gen_host_pop(Model, num_wks); 
    o_env_data = Model.gen_environment(Model, input_filename, num_wks, 0, 0) #, rep=1); # rep allows 100 year dataset by doubling input data. #! Must be thread safe if not full regen
    
    # Tag determines init conds file.
    cohort_inits, on_host_inits, hardening_inits, host_inits = Model.initialize_pop(tick_pop, host_pop; input_dir="Input_Data") #, tag="2");

    μ_vec = [0:1:99;]
    σ_vec = [0:1:99;]

#! Thread this loop if running single sim. Threads.@threads 
    for μ in μ_vec
        for σ in σ_vec    
            print(μ, " ", σ, " ", Threads.threadid(), " \n")
            sim_name = "lifespan_52_mice_$(μ)_$(σ)_$(location)_$(CDW_stat)" # set simname for file
            # sim_name = "test_run3" # For sim testing

            env_data = deepcopy(o_env_data) # deepcopy so thread safe.
            Mice = Model.gen_mouse_yearly(μ, σ, num_wks) # generate just new acorns (faster)
            env_data.H[:, :] = Mice # set acorns
            
            tick_pop = Model.gen_tick_pop(Model, num_wks, lifespan, perc_trans, paras_og) # get new tickpop
            host_pop = Model.gen_host_pop(Model, num_wks) # get new host pop. 
            Model.initialize_pop(
                tick_pop, host_pop; cohort_inits=cohort_inits, on_host_inits=on_host_inits,
                hardening_inits=hardening_inits, host_inits=host_inits) # init pops.
            # running
            Model.run_model(Model, tick_pop, host_pop, env_data, num_wks, paras_og, sim_name, output_dir)
        end #! End σ values 
    end #! End μ values 

end #! Location end 
