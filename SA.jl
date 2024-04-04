#########
# Author: Joseph D.T. Savage
# Date: February 24, 2022
# Top-level code to run Lyme disease population model
#########

## -- Import modules
using Random, Distributions, Setfield
# using ThreadingU-- tilities
include("base_model.jl"); 

## -- Set up model structures

Model = TickModel # Model module contains important functions and libraries

# slow to run, only needs to run once if not defined.
if !@isdefined perc_trans
   perc_trans = Model.effective_transmission() # monte carlo simulation of effective transmission
end 

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
    
#! Set input filenames and output dirs.
loc = "PortlandME_1971-2021"
input_filename = "Input_Data/$(loc).csv"
output_dir = "/media/jdtsavage22/Research/honors_thesis/SA"
# output_dir = "Output_Data" # For sim testing or init conds generation


#! Start tick pops + load environment
tick_pop = Model.gen_tick_pop(Model, num_wks, lifespan, perc_trans, paras_og); 
host_pop = Model.gen_host_pop(Model, num_wks); 
o_env_data = Model.gen_environment(Model, input_filename, num_wks, 0, 0) #, rep=1); # rep allows 100 year dataset by doubling input data. #! Must be thread safe if not full regen

# Tag determines init conds file.
cohort_inits, on_host_inits, hardening_inits, host_inits = Model.initialize_pop(tick_pop, host_pop; input_dir="Input_Data") #, tag="2");

    
μ = 50
σ = 0

################! Start SA
pert_vec = [0.9:0.01:1.1;]

for perturbation in pert_vec

    paras = deepcopy(paras_og)
 
    ###! Change parameter:
    paras = @set paras.TIF = perturbation * paras.TIF # round to digits = 0 for ints.
    #paras = @set paras.TIF = round(perturbation * paras.TIF, digits = 0)


    #! Set sim name 
    pert_name = "TIF" # Standard CDW or realistic ones?
    sim_name = "$(pert_name)_$(paras.TIF)" # set simname for file
    print("New $pert_name ", paras.TIF, "\n")

    env_data = deepcopy(o_env_data) # deepcopy so thread safe.
    Mice = Model.gen_mouse_yearly(μ, σ, num_wks) # generate just new acorns (faster)
    env_data.H[:, :] = Mice # set acorns

    tick_pop = Model.gen_tick_pop(Model, num_wks, paras.lifespan, perc_trans, paras) # get new tickpop
    host_pop = Model.gen_host_pop(Model, num_wks) # get new host pop. 

    Model.initialize_pop(
        tick_pop, host_pop; cohort_inits=cohort_inits, on_host_inits=on_host_inits,
        hardening_inits=hardening_inits, host_inits=host_inits) # init pops.
    # running
    Model.run_model(Model, tick_pop, host_pop, env_data, num_wks, paras, sim_name, output_dir)

end
