## Plotting of simulation output
using Statistics, CSV, DataFrames, GLM, Tables, PyPlot; pygui(true)
include("base_model.jl")
Model = TickModel # Used to load up tick and host pops

paras = Model.model_pars(
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


QN_10_avg = zeros(21, 10)
IQN_10_avg = zeros(21, 10)
QN_10_min = zeros(21, 10)
IQN_10_min = zeros(21, 10)
QN_10_max = zeros(21, 10)
IQN_10_max = zeros(21, 10)
TOT_QN_10_max = zeros(21, 10)
TOT_QN_10_min = zeros(21, 10)
TOT_NIP_10_max = zeros(21, 10)
TOT_NIP_10_min = zeros(21, 10)

load_dir = "/media/jdtsavage22/Research/honors_thesis/SA/"

μ = 50
σ = 0

################! Start SA
pert_vec = [0.9:0.01:1.0;] # 1.1 but edited for S1 here.

## - This is a block of code

pert_name = "S₁" # Standard CDW or realistic ones?
global count = 0

for perturbation in pert_vec

    perturbated = perturbation * paras.S₁
    #perturbated = Int(round(perturbation * paras.S₁, digits = 0)) # round for integer parameters. 

    global count += 1
    
    #! Change parameter:
    # paras = @set paras.TIF = perturbation * paras.TIF # round to digits = 0 for ints.

    #! Set sim name 
    # pert_name = "TIF" # Standard CDW or realistic ones?
    sim_name = "$(pert_name)_$(perturbated).csv" # set simname for file  trunc(Int64, round(
    print("New $pert_name ", perturbated, "\n")

    # QL = Matrix(DataFrame(CSV.File(load_dir * "QL/" * sim_name, header=false)))[end-(10*52)+1:end, 1]
    # QL_10_avg[row, :] = mean.(collect(Iterators.partition(QL, 52)))
    # QL_10_max[row, :] = maximum.(collect(Iterators.partition(QL, 52)))


    QN = Matrix(DataFrame(CSV.File(load_dir * "QN/" * sim_name, header=false)))[end-(10*52)+1:end, 1]
    IQN = Matrix(DataFrame(CSV.File(load_dir * "IQN/" * sim_name, header=false)))[end-(10*52)+1:end, 1]

    # SM = Matrix(DataFrame(CSV.File(load_dir * "SM/" * sim_name, header=false)))[end-(10*52)+1:end, 1]
    # ISM = Matrix(DataFrame(CSV.File(load_dir * "ISM/" * sim_name, header=false)))[end-(10*52)+1:end, 1]

    QN_10_avg[count, :] = mean.(collect(Iterators.partition(QN, 52)))
    IQN_10_avg[count, :] = mean.(collect(Iterators.partition(IQN, 52)))

    QN_10_min[count, :] = minimum.(collect(Iterators.partition(QN, 52)))
    IQN_10_min[count, :] = minimum.(collect(Iterators.partition(IQN, 52)))

    QN_10_max[count, :] = maximum.(collect(Iterators.partition(QN, 52)))
    IQN_10_max[count, :] = maximum.(collect(Iterators.partition(IQN, 52)))

    QN_sum = collect(Iterators.partition(QN .+ IQN, 52))
    NIP_sum = collect(Iterators.partition(IQN./(QN .+ IQN), 52))
    TOT_QN_10_max[count, :] = maximum.(QN_sum)
    TOT_QN_10_min[count, :] = minimum.(QN_sum)
    
    TOT_NIP_10_max[count, :] = maximum.(NIP_sum)
    TOT_NIP_10_min[count, :] = minimum.(NIP_sum)

end

output_dir = load_dir * "Analysis_Data/$pert_name"

mkdir(output_dir)

CSV.write("$output_dir/tot_QN_max.csv", Tables.table(TOT_QN_10_max), header=false)
CSV.write("$output_dir/tot_QN_min.csv", Tables.table(TOT_QN_10_min), header=false)

CSV.write("$output_dir/tot_NIP_max.csv", Tables.table(TOT_NIP_10_max), header=false)
CSV.write("$output_dir/tot_NIP_min.csv", Tables.table(TOT_NIP_10_min), header=false)

CSV.write("$output_dir/mean_QN.csv", Tables.table(QN_10_avg), header=false)
CSV.write("$output_dir/mean_IQN.csv", Tables.table(IQN_10_avg), header=false)

CSV.write("$output_dir/min_QN.csv", Tables.table(QN_10_min), header=false)
CSV.write("$output_dir/min_IQN.csv", Tables.table(IQN_10_min), header=false)

CSV.write("$output_dir/max_QN.csv", Tables.table(QN_10_max), header=false)
CSV.write("$output_dir/max_IQN.csv", Tables.table(IQN_10_max), header=false)

