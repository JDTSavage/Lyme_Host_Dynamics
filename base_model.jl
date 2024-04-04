#= Module for the model =#

module TickModel

    import Base.@kwdef
    using Random, Distributions, StatsFuns
    Random.seed!(42069) # Setting the seed
    include("model_structures.jl")
    include("rate_functions.jl")
    include("run_model.jl")

end 

