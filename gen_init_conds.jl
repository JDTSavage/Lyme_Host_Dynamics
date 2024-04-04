## Find init conditions. Only run if simulation.jl run for single run

cohort_stages = ["Egg", "EL", "EN", "EA", "IEL", "IEN", "IEA", "QL", "QN", "QA", "IQN", "IQA"]
on_host_stages = ["OL", "ON", "OA", "IOL", "ION", "IOA"]
vec_stages = ["HL", "HN", "HA", "IHN", "IHA"]

cohort_inits = zeros(length(cohort_stages))
on_host_inits = zeros(length(on_host_stages), 3)
vec_inits = zeros(length(vec_stages))
count = 1

init_conds = "init_conds2"
for stage in cohort_stages

    df = DataFrame(CSV.File("Output_Data/$stage/$init_conds.csv", header=false));
    # stage_ts = zeros(num_wks);
    # for wk = 1:num_wks
            
    #     for cohort = 1:wk
    #         cohort_wk = wk - cohort + 1

    #         if cohort_wk < length(df[1,:])    
    #             # egg_ts[wk] = egg_ts[wk] + tick_pop.Egg[cohort, cohort_wk]
    #             stage_ts[wk] = stage_ts[wk] + df[cohort, cohort_wk]
    #             # ilarvae_ts[wk] = ilarvae_ts[wk] + tick_pop.IEL[cohort, cohort_wk]
    #             # nymphs_ts[wk] = nymphs_ts[wk] + tick_pop.IQN[cohort, cohort_wk] + tick_pop.QN[cohort, cohort_wk]
    #             # adults_ts[wk] = adults_ts[wk] + tick_pop.IQA[cohort, cohort_wk] + tick_pop.QA[cohort, cohort_wk]
    #         else
    #             continue
    #         end

    #     end     
    # end
    cohort_inits[count] = df[2549, 1]
    count = count + 1
end

count = 1
for stage in on_host_stages

    df = DataFrame(CSV.File("Output_Data/$stage/$init_conds.csv", header=false));
    on_host_inits[count, :] = [df[2549, 1], df[2549, 2], df[2549, 3]]
    count = count + 1
end

count = 1
for stage in vec_stages

    df = DataFrame(CSV.File("Output_Data/$stage/$init_conds.csv", header=false));
    vec_inits[count] = df[2549, 1]
    count = count + 1
end

host_stages = ["SM", "MM", "D", "ISM", "IMM", "ID"]
host_inits = zeros(length(host_stages))

count = 1
for host in host_stages

    df = DataFrame(CSV.File("Output_Data/$host/$init_conds.csv", header=false));
    host_inits[count] = df[2549, 1]
    count = count + 1
end

init_tag = "2"
CSV.write("Input_Data/cohort_inits$init_tag.txt", Tables.table(vcat(reshape(cohort_stages, 1, length(cohort_stages)), transpose(cohort_inits))), writeheader=false)
CSV.write("Input_Data/on_host_inits$init_tag.txt", Tables.table(vcat(reshape(on_host_stages, 1, length(on_host_stages)), transpose(on_host_inits))), writeheader=false)
CSV.write("Input_Data/hardening_inits$init_tag.txt", Tables.table(vcat(reshape(vec_stages, 1, length(vec_stages)), transpose(vec_inits))), writeheader=false)
CSV.write("Input_Data/host_inits$init_tag.txt", Tables.table(vcat(reshape(host_stages, 1, length(host_stages)), transpose(host_inits))), writeheader=false)

# # plot(1:num_wks, larvae_ts);