#= 
Model structures
Stage structured tick population
Multiple Host population
Environmental data? 
=#

# import Base.@kwdef

@kwdef struct tick_states

    # Eggs
    # will be [# weeks , lifespan]
    Egg::Matrix{Float64}
    ECDW::Matrix{Float64}

    # Larvae

    # [# weeks, 1]
    HL::Matrix{Float64} # hardening?
    # [# weeks , lifespan]
    QL::Matrix{Float64} # able-to-quest 
    # [# weeks, 1]
    OL::Matrix{Float64} # on-host 
    IOL::Matrix{Float64} # infected on host 
    # [# weeks , lifespan]
    EL::Matrix{Float64} # engorged 
    IEL::Matrix{Float64}
    LCDW::Matrix{Float64}

    # Nymphs
    # [# weeks, 1]
    HN::Matrix{Float64} # hardening
    IHN::Matrix{Float64}
    QN::Matrix{Float64} # able-to-quest 
    IQN::Matrix{Float64} # infected able to quest 
    # [# weeks, 1]
    ON::Matrix{Float64} # on host 
    ION::Matrix{Float64} # infected on host 
    # [# weeks , lifespan]
    EN::Matrix{Float64} # engorged 
    IEN::Matrix{Float64} # infected engorged
    NCDW::Matrix{Float64}

    # Adults 
    # [# weeks, 1]
    HA::Matrix{Float64} # hardening
    IHA::Matrix{Float64}
    QA::Matrix{Float64} # able-to-quest 
    IQA::Matrix{Float64} # infected able to quest 
    # [# weeks, 1]
    OA::Matrix{Float64} # on host 
    IOA::Matrix{Float64} # infected on host 
    # [# weeks , lifespan]
    EA::Matrix{Float64} # engorged 
    IEA::Matrix{Float64} # infected engorged
    ACDW::Matrix{Float64}

    perc_trans:: Matrix{Float64}

    # normal dists for survival and host finding
    immat_survival_t::Normal{Float64}
    mat_survival_t::Normal{Float64}
    all_survival_p::Normal{Float64}
    
    immat_hf::Normal{Float64}
    mat_hf::Normal{Float64}

end

@kwdef  struct host_states 
    
    # [# weeks, 1]
    SM::Matrix{Float64} # small mammals
    # [# weeks, 1]
    MM::Matrix{Float64} # medium/misc. mammals
    # [# weeks, 1]
    D::Matrix{Float64} # deer
    
    # [# weeks, 1]
    ISM::Matrix{Float64} # small mammals
    # [# weeks, 1]
    IMM::Matrix{Float64} # medium/misc. mammals
    # [# weeks, 1]
    ID::Matrix{Float64} # deer

end

@kwdef  struct environment 

    # RH::Matrix{Float64}
    PI::Matrix{Float64} # Precip index
    T::Matrix{Float64}
    H::Matrix{Float64}

end

@kwdef struct model_pars

    lifespan::Int64
    σₜᵢ::Float64
    σₜₐ::Float64
    σₚᵢ::Float64
    σₐᵢ::Float64
    σₐₐ::Float64
    μₜᵢ::Float64
    μₜₐ::Float64
    μₚᵢ::Float64
    μₐᵢ::Float64
    μₐₐ::Float64
    # init conds 
    fec::Int64
    CDWₘₑ::Float64
    CDWₘₗ::Float64
    CDWₘₙ::Float64
    CDWₘₐ::Float64
    CDWₑ::Float64
    CDWₗ::Float64
    CDWₙ::Float64
    CDWₐ::Float64
    Sₕₗ::Float64
    Sₕₙ::Float64
    Sₕₐ::Float64
    Sₓᵢ₁::Float64
    Sₓᵢ₂::Float64
    Sₓᵢ₃::Float64 
    Sₓₐ₁::Float64
    Sₓₐ₂::Float64
    Sₓₐ₃::Float64
    Sₘᵢ₁::Float64
    Sₘᵢ₂::Float64
    Sₘᵢ₃::Float64
    Sₘₐ₁::Float64
    Sₘₐ₂::Float64
    Sₘₐ₃::Float64
    EIₓ₁::Float64
    EIₓ₂::Float64
    EIₓ₃::Float64
    EIₘ₁::Float64
    EIₘ₂::Float64
    EIₘ₃::Float64
    EIₛₗ::Float64
    EIₛₙ::Float64
    EIₛₐ::Float64
    EIₗ::Float64
    Bₕₗ₁::Float64
    Bₕₗ₂::Float64
    Bₕₗ₃::Float64
    Bₕₙ₁::Float64
    Bₕₙ₂::Float64
    Bₕₙ₃::Float64
    Bₕₐ₁::Float64
    Bₕₐ₂::Float64
    Bₕₐ₃::Float64
    aₕ₁::Float64
    aₕ₂::Float64
    aₕ₃::Float64
    b::Float64
    S₁::Float64
    S₂::Float64
    S₃::Float64
    C₁::Float64
    C₂::Float64
    C₃::Float64
    TIF::Float64

end

