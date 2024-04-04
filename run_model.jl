using CSV, DataFrames, Tables

function run_model(Model, tick_pop, host_pop, env_data, num_wks, pars, sim_name, output_dir)

    # num_wks = num_wks + 1 # Array sizes + 1 week to prevent out of bounds at end.

    for wk = 1:num_wks - 1
        # print(wk, " ", Threads.threadid(), " XX\n")
        Model.advance_tick_pop(tick_pop, host_pop, env_data, wk, pars)
        Model.advance_host_pop(tick_pop, host_pop, env_data, wk, pars)
        
    end

    # headers = Iterators.Stateful([Symbol("wk_$i") for i = 1:lifespan])

    ## Write data from tick and host population matrices. 
    write_model_data(tick_pop, host_pop, env_data, num_wks, sim_name, output_dir)
    
    return nothing
end

# Generates a clear tick population for running a simulation on.
function gen_tick_pop(Model, num_wks, lifespan, perc_trans, pars::Main.TickModel.model_pars)

    immat_t_sd = pars.σₜᵢ
    immat_t_mean = pars.μₜᵢ

    all_p_sd = pars.σₚᵢ
    all_p_mean = pars.μₚᵢ

    mat_t_sd = pars.σₜₐ
    mat_t_mean = pars.μₜₐ

    immat_hf_sd = pars.σₐᵢ
    immat_hf_mean = pars.μₐᵢ

    mat_hf_sd = pars.σₐₐ
    mat_hf_mean = pars.μₐₐ
    

    tick_pop = Model.tick_states( # Tick population matrices
        # Eggs
        # will be [# weeks , lifespan]
        # Eggs are in this stage in weekly cohorts 
        Egg = zeros(num_wks, lifespan),
        # CDW per cohort will increment weekly
        ECDW = zeros(num_wks, 1),

        # Larvae
        # [# weeks, 1]
        #! hardening larvae harden for one(?) week by cohort
        HL = zeros(num_wks, 1),
        # [# weeks , lifespan]
        # questing larvae quest till death in cohorts
        QL = zeros(num_wks, lifespan),
        # [# weeks, 1]
        # on host larvae are on host for a week by cohort
        OL = zeros(num_wks, 3),
        IOL = zeros(num_wks, 3), 
        # [# weeks , lifespan]
        # Engorged larvae are engorged until death by cohort
        EL = zeros(num_wks, lifespan), 
        IEL = zeros(num_wks, lifespan),
        # CDW per cohort increments weekly
        LCDW = zeros(num_wks, 1),

        # Nymphs
        # [# weeks, 1]
        #! hardening nymphs harden for one(?) week by cohort
        HN = zeros(num_wks, 1),
        IHN = zeros(num_wks, 1),
        # [# weeks , lifespan]
        # Questing nymphs quest by cohort till death
        QN = zeros(num_wks, lifespan), 
        IQN = zeros(num_wks, lifespan), 
        # [# weeks, 1]
        # On host nymphs are on host for a week by cohort
        ON = zeros(num_wks, 3),
        ION = zeros(num_wks, 3), 
        # [# weeks , lifespan]
        # engorged nymphs survive by cohort till death.
        EN = zeros(num_wks, lifespan), 
        IEN = zeros(num_wks, lifespan),
        # CDW per cohort increments weekly
        NCDW = zeros(num_wks, 1),

        # [# weeks, 1]
        #! Adults harden for one(?) week by cohort
        HA = zeros(num_wks, 1),
        IHA = zeros(num_wks, 1),
        # [# weeks , lifespan]
        # Questing adults quest by cohort until death
        QA = zeros(num_wks, lifespan), 
        IQA = zeros(num_wks, lifespan), 
        # [# weeks, 1]
        # On host adults are on host for a week
        OA = zeros(num_wks, 3), 
        IOA = zeros(num_wks, 3), 
        # [# weeks , lifespan]
        # Engorged adults are engorged by cohort until death
        EA = zeros(num_wks, lifespan),
        IEA = zeros(num_wks, lifespan),
        # CDW per cohort increments weekly
        ACDW = zeros(num_wks, 1),

        perc_trans = perc_trans,

        immat_survival_t = Normal(immat_t_mean, immat_t_sd),
        mat_survival_t = Normal(mat_t_mean, mat_t_sd),
        all_survival_p = Normal(all_p_mean, all_p_sd),
        
        immat_hf = Normal(immat_hf_mean, immat_hf_sd),
        mat_hf = Normal(mat_hf_mean, mat_hf_sd)

        )

    return tick_pop

end

# Generates a clear host population to perform a simulation on.
function gen_host_pop(Model, num_wks)

    host_pop = Model.host_states( # Host population matrices
        # [# weeks, 1]
        SM = zeros(num_wks, 1), # small mammals
        # [# weeks, 1]
        MM = zeros(num_wks, 1), # medium/misc. mammals
        # [# weeks, 1]
        D = zeros(num_wks, 1), # deer
        
        # [# weeks, 1]
        ISM = zeros(num_wks, 1), # small mammals
        # [# weeks, 1]
        IMM = zeros(num_wks, 1), # medium/misc. mammals
        # [# weeks, 1]
        ID = zeros(num_wks, 1) # deer 
        )

    return host_pop

end

# Generates environment struct with different weather and acorn inputs from file and 
# Random distribution
function gen_environment(Model, filename, num_wks, μ, σ; rep = nothing)

    Inputs = DataFrame(CSV.File(filename)) # Env_data

    # Environemntal data includes humidity, temperature, and seed availability
    # this data is weekly
    weather = Inputs.Temp
    if (length(weather) == 52)
        weather = repeat(weather, outer = num_wks÷52)
    end
    weather = reshape(weather, length(weather), 1)

    precip_ind = Inputs.PrecI
    if (length(precip_ind) == 52)
        precip_ind = repeat(precip_ind, outer = num_wks÷52)
    end
    precip_ind = reshape(precip_ind, length(precip_ind), 1)

    if rep !== nothing
        weather = repeat(weather, outer = 2)
        precip_ind = repeat(precip_ind, outer = 2)
        weather = reshape(weather, length(weather), 1)
        precip_ind = reshape(precip_ind, length(precip_ind), 1)
    end

    Mice = gen_mouse_yearly(μ, σ, num_wks)

    Environment = Model.environment(
        PI = precip_ind,
        T = weather,
        H = Mice
    )

    return Environment

end

# Generate Mice in a random distribution
function gen_mouse_yearly(μ, σ, num_wks)

    Aᵢ = ones(52)
    Mice = ones(0)
    for i in 1:(num_wks÷52)
        Aᵢ = ones(52) * rand(Normal(μ, σ))
    
        Mice = vcat(Mice, Aᵢ)
    end
    Mice = reshape(Mice, length(Mice), 1)

    return Mice

end

# Write simulation data to output files
function write_model_data(tick_pop, host_pop, env_data, num_wks, sim_name, output_dir)
    ## Write data from tick and host population matrices. 

    matrix_stages = [
        tick_pop.Egg, tick_pop.QL, tick_pop.QN, tick_pop.QA, tick_pop.IQN,
        tick_pop.IQA, tick_pop.EL, tick_pop.EN, tick_pop.EA, tick_pop.IEL, 
        tick_pop.IEN, tick_pop.IEA]

    lifespan = length(tick_pop.Egg[1, :])

    stage_ts = calc_time_series(matrix_stages, num_wks, lifespan)

    # Eggs
    CSV.write("$output_dir/Egg/$sim_name.csv", Tables.table(stage_ts[1, :]), writeheader=false)
    
    # HL
    CSV.write("$output_dir/HL/$sim_name.csv", Tables.table(tick_pop.HL), writeheader=false)

    # QL
    CSV.write("$output_dir/QL/$sim_name.csv", Tables.table(stage_ts[2, :]), writeheader=false)

    # OL
    CSV.write("$output_dir/OL/$sim_name.csv", Tables.table(tick_pop.OL), writeheader=false)

    # IOL
    CSV.write("$output_dir/IOL/$sim_name.csv", Tables.table(tick_pop.IOL), writeheader=false)    
    
    # EL
    CSV.write("$output_dir/EL/$sim_name.csv", Tables.table(stage_ts[7, :]), writeheader=false)

    # IEL
    CSV.write("$output_dir/IEL/$sim_name.csv", Tables.table(stage_ts[10, :]), writeheader=false)

    # HN
    CSV.write("$output_dir/HN/$sim_name.csv", Tables.table(tick_pop.HN), writeheader=false)

    # IHN
    CSV.write("$output_dir/IHN/$sim_name.csv", Tables.table(tick_pop.IHN), writeheader=false)

    # QN
    CSV.write("$output_dir/QN/$sim_name.csv", Tables.table(stage_ts[3, :]), writeheader=false)

    # IQN
    CSV.write("$output_dir/IQN/$sim_name.csv", Tables.table(stage_ts[5, :]), writeheader=false)

    # ON
    CSV.write("$output_dir/ON/$sim_name.csv", Tables.table(tick_pop.ON), writeheader=false)

    # ION
    CSV.write("$output_dir/ION/$sim_name.csv", Tables.table(tick_pop.ION), writeheader=false)

    # EN
    CSV.write("$output_dir/EN/$sim_name.csv", Tables.table(stage_ts[8, :]), writeheader=false)

    # IEN
    CSV.write("$output_dir/IEN/$sim_name.csv", Tables.table(stage_ts[11, :]), writeheader=false)

    # HA
    CSV.write("$output_dir/HA/$sim_name.csv", Tables.table(tick_pop.HA), writeheader=false)

    # IHA
    CSV.write("$output_dir/IHA/$sim_name.csv", Tables.table(tick_pop.IHA), writeheader=false)

    # QA
    CSV.write("$output_dir/QA/$sim_name.csv", Tables.table(stage_ts[4, :]), writeheader=false)

    # IQA
    CSV.write("$output_dir/IQA/$sim_name.csv", Tables.table(stage_ts[6, :]), writeheader=false)

    # OA
    CSV.write("$output_dir/OA/$sim_name.csv", Tables.table(tick_pop.OA), writeheader=false)

    # IOA
    CSV.write("$output_dir/IOA/$sim_name.csv", Tables.table(tick_pop.IOA), writeheader=false)

    # EA
    CSV.write("$output_dir/EA/$sim_name.csv", Tables.table(stage_ts[9, :]), writeheader=false)

    # IEA
    CSV.write("$output_dir/IEA/$sim_name.csv", Tables.table(stage_ts[12, :]), writeheader=false)

    # SM
    CSV.write("$output_dir/SM/$sim_name.csv", Tables.table(host_pop.SM), writeheader=false)

    # ISM
    CSV.write("$output_dir/ISM/$sim_name.csv", Tables.table(host_pop.ISM), writeheader=false)

    # MM
    CSV.write("$output_dir/MM/$sim_name.csv", Tables.table(host_pop.MM), writeheader=false)

    # IMM
    CSV.write("$output_dir/IMM/$sim_name.csv", Tables.table(host_pop.IMM), writeheader=false)

    # D
    CSV.write("$output_dir/D/$sim_name.csv", Tables.table(host_pop.D), writeheader=false)

    # ID
    CSV.write("$output_dir/ID/$sim_name.csv", Tables.table(host_pop.ID), writeheader=false)

    # Mice
    CSV.write("$output_dir/Mice/$sim_name.csv", Tables.table(env_data.H), writeheader=false)

    return nothing

end

function calc_time_series(stages, num_wks, lifespan)
    stage_times = zeros(length(stages), num_wks)
    lifespan = lifespan - 1
    
    count = 1
    for stage in stages

        stage_ts = zeros(num_wks + lifespan);
        for wk = 1:num_wks
                
            stage_ts[wk:(wk + lifespan)] = stage_ts[wk:(wk + lifespan)] + stage[wk, :]
    
        end
        stage_times[count, :] = stage_ts[1:num_wks]
        count = count + 1
    end
    return stage_times
end

# initializes populations when given pops and input directory
function initialize_pop(
    tick_pop, host_pop; input_dir=nothing, tag=nothing, cohort_inits=nothing, 
    on_host_inits=nothing, hardening_inits=nothing, 
    host_inits=nothing)

    if (input_dir !== nothing)
        if tag === nothing
            cohort_inits = DataFrame(CSV.File("$(input_dir)/cohort_inits.txt")) # Inits for cohort stages 
            on_host_inits = DataFrame(CSV.File("$(input_dir)/on_host_inits.txt")) # on host stages (3 hosts, not vectors)
            hardening_inits = DataFrame(CSV.File("$(input_dir)/hardening_inits.txt")) # inits for hardening stages
            host_inits = DataFrame(CSV.File("$(input_dir)/host_inits.txt")) # inits for hosts
        else
            cohort_inits = DataFrame(CSV.File("$(input_dir)/cohort_inits$tag.txt")) # Inits for cohort stages 
            on_host_inits = DataFrame(CSV.File("$(input_dir)/on_host_inits$tag.txt")) # on host stages (3 hosts, not vectors)
            hardening_inits = DataFrame(CSV.File("$(input_dir)/hardening_inits$tag.txt")) # inits for hardening stages
            host_inits = DataFrame(CSV.File("$(input_dir)/host_inits$tag.txt")) # inits for hosts    
        end
    end

    tick_pop.Egg[1,1] = cohort_inits.Egg[]
    tick_pop.HL[1,1] = hardening_inits.HL[]
    tick_pop.QL[1,1] = cohort_inits.QL[] 
    tick_pop.OL[1,:] = on_host_inits.OL[:]
    tick_pop.IOL[1,:] = on_host_inits.IOL[:] 
    tick_pop.EL[1,1] = cohort_inits.EL[]
    tick_pop.IEL[1,1] = cohort_inits.IEL[] 
    tick_pop.HN[1,1] = hardening_inits.HN[]
    tick_pop.IHN[1,1] = hardening_inits.IHN[] 
    tick_pop.QN[1,1] = cohort_inits.QN[]
    tick_pop.IQN[1,1] = cohort_inits.IQN[] 
    tick_pop.ON[1,:] = on_host_inits.ON[:]
    tick_pop.ION[1,:] = on_host_inits.ION[:] 
    tick_pop.EN[1,1] = cohort_inits.EN[]
    tick_pop.IEN[1,1] = cohort_inits.IEN[] 
    tick_pop.HA[1,1] = hardening_inits.HA[]
    tick_pop.IHA[1,1] = hardening_inits.IHA[] 
    tick_pop.QA[1,1] = cohort_inits.QA[]
    tick_pop.IQA[1,1] = cohort_inits.IQA[] 
    tick_pop.OA[1,:] = on_host_inits.OA[:]
    tick_pop.IOA[1,:] = on_host_inits.IOA[:] 
    tick_pop.EA[1,1] = cohort_inits.EA[]
    tick_pop.IEA[1,1] = cohort_inits.IEA[] 
    host_pop.ISM[1,1] = host_inits.ISM[]
    host_pop.SM[1,1] = host_inits.SM[]
    host_pop.IMM[1,1] = host_inits.IMM[] 
    host_pop.MM[1,1] = host_inits.MM[]
    host_pop.D[1,1] = host_inits.D[]
    host_pop.ID[1,1] = host_inits.ID[]

    if (input_dir !== nothing)
        return cohort_inits, on_host_inits, hardening_inits, host_inits
    end
    return nothing
end

# initializes populations when given pops and input directory
function load_pop(tick_pop, host_pop, μ, σ, load_dir, load_file)

    tick_pop.Egg[:, 1] = Matrix(DataFrame(CSV.File(load_dir * "Egg/" * load_file, header=false)))
    tick_pop.HL[:, :] = Matrix(DataFrame(CSV.File(load_dir * "HL/" * load_file, header=false)))
    tick_pop.QL[:, 1] = Matrix(DataFrame(CSV.File(load_dir * "QL/" * load_file, header=false)))
    tick_pop.OL[:, :] = Matrix(DataFrame(CSV.File(load_dir * "OL/" * load_file, header=false)))
    tick_pop.IOL[:, :] = Matrix(DataFrame(CSV.File(load_dir * "IOL/" * load_file, header=false)))
    tick_pop.EL[:, 1] = Matrix(DataFrame(CSV.File(load_dir * "EL/" * load_file, header=false)))
    tick_pop.IEL[:, 1] = Matrix(DataFrame(CSV.File(load_dir * "IEL/" * load_file, header=false)))
    tick_pop.HN[:, :] = Matrix(DataFrame(CSV.File(load_dir * "HN/" * load_file, header=false)))
    tick_pop.IHN[:, :] = Matrix(DataFrame(CSV.File(load_dir * "IHN/" * load_file, header=false)))
    tick_pop.QN[:, 1] = Matrix(DataFrame(CSV.File(load_dir * "QN/" * load_file, header=false)))
    tick_pop.IQN[:, 1] = Matrix(DataFrame(CSV.File(load_dir * "IQN/" * load_file, header=false)))
    tick_pop.ON[:, :] = Matrix(DataFrame(CSV.File(load_dir * "ON/" * load_file, header=false)))
    tick_pop.ION[:, :] = Matrix(DataFrame(CSV.File(load_dir * "ION/" * load_file, header=false)))
    tick_pop.EN[:, 1] = Matrix(DataFrame(CSV.File(load_dir * "EN/" * load_file, header=false)))
    tick_pop.IEN[:, 1] = Matrix(DataFrame(CSV.File(load_dir * "IEN/" * load_file, header=false)))
    tick_pop.HA[:, :] = Matrix(DataFrame(CSV.File(load_dir * "HA/" * load_file, header=false)))
    tick_pop.IHA[:, :] = Matrix(DataFrame(CSV.File(load_dir * "IHA/" * load_file, header=false)))
    tick_pop.QA[:, 1] = Matrix(DataFrame(CSV.File(load_dir * "QA/" * load_file, header=false)))
    tick_pop.IQA[:, 1] = Matrix(DataFrame(CSV.File(load_dir * "IQA/" * load_file, header=false)))
    tick_pop.OA[:, :] = Matrix(DataFrame(CSV.File(load_dir * "OA/" * load_file, header=false)))
    tick_pop.IOA[:, :] = Matrix(DataFrame(CSV.File(load_dir * "IOA/" * load_file, header=false)))
    tick_pop.EA[:, 1] = Matrix(DataFrame(CSV.File(load_dir * "EA/" * load_file, header=false)))
    tick_pop.IEA[:, 1] = Matrix(DataFrame(CSV.File(load_dir * "IEA/" * load_file, header=false)))
    host_pop.ISM[:, :] = Matrix(DataFrame(CSV.File(load_dir * "ISM/" * load_file, header=false)))
    host_pop.SM[:, :] = Matrix(DataFrame(CSV.File(load_dir * "SM/" * load_file, header=false)))
    host_pop.IMM[:, :] = Matrix(DataFrame(CSV.File(load_dir * "IMM/" * load_file, header=false)))
    host_pop.MM[:, :] = Matrix(DataFrame(CSV.File(load_dir * "MM/" * load_file, header=false)))
    host_pop.D[:, :] = Matrix(DataFrame(CSV.File(load_dir * "D/" * load_file, header=false)))
    host_pop.ID[:, :] = Matrix(DataFrame(CSV.File(load_dir * "ID/" * load_file, header=false)))

    return nothing

end

function clear_pop(tick_pop, host_pop)

    tick_pop.Egg[:] .= zero(1) 
    tick_pop.ECDW[:] .= zero(1) 
    tick_pop.HL[:] .= zero(1) 
    tick_pop.QL[:] .= zero(1) 
    tick_pop.OL[:] .= zero(1) 
    tick_pop.IOL[:] .= zero(1) 
    tick_pop.EL[:] .= zero(1)  
    tick_pop.IEL[:] .= zero(1)
    tick_pop.LCDW[:] .= zero(1) 
    tick_pop.HN[:] .= zero(1) 
    tick_pop.IHN[:] .= zero(1)
    tick_pop.QN[:] .= zero(1) 
    tick_pop.IQN[:] .= zero(1) 
    tick_pop.ON[:] .= zero(1) 
    tick_pop.ION[:] .= zero(1) 
    tick_pop.EN[:] .= zero(1)  
    tick_pop.IEN[:] .= zero(1)
    tick_pop.NCDW[:] .= zero(1) 
    tick_pop.HA[:] .= zero(1) 
    tick_pop.IHA[:] .= zero(1) 
    tick_pop.QA[:] .= zero(1)  
    tick_pop.IQA[:] .= zero(1)  
    tick_pop.OA[:] .= zero(1)  
    tick_pop.IOA[:] .= zero(1)  
    tick_pop.EA[:] .= zero(1)
    tick_pop.IEA[:] .= zero(1)
    tick_pop.ACDW[:] .= zero(1) 

    host_pop.SM[:] .= zero(1)
    host_pop.MM[:] .= zero(1)
    host_pop.D[:] .= zero(1)
    host_pop.ISM[:] .= zero(1)
    host_pop.IMM[:] .= zero(1)
    host_pop.ID[:] .= zero(1) 

    return nothing

end