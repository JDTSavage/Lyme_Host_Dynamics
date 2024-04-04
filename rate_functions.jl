using Distributions

# advance tick population by a week
function advance_tick_pop(popT, popH, Env, week, pars::Main.TickModel.model_pars)

    # advance questing cohorts
    for cohort = 1:week
        cohort_wk = week - cohort + 1

        if cohort_wk < length(popT.QL[1,:])
    
        ##################################################################
        ### Advancement of cohorts, not infection dynamics.
        
            # egg dynamics are very simple
            # matrix is [#wks x max_lifespan] as Eggs
            # eggs will mature by Cumulative Degree Week (CDW)
            # Eggs cannot be infected, so no need to worry about that.
            # new eggs
            # CDW calculations
            ECDW = tally_ECDW(popT, Env, cohort, week, pars) # for input into maturation function

            Eggs = popT.Egg[cohort, cohort_wk]
            S_E = calc_egg_survival(popT, Env, week, pars)
            popT.Egg[cohort, cohort_wk + 1] = Eggs * S_E - egg_maturation(popT.Egg[cohort, cohort_wk], ECDW, pars) * S_E

            # larval dynamics
            #
            # new hardening larvae 
            # these are freshly hatched larvae, which will harden for a week before moving into the questing category
            # matrix is [#wks x 1]
            # the number will add depending on maturation of eggs by CDW, so must add to current total through loop.
            popT.HL[week + 1, 1] = popT.HL[week + 1, 1] + egg_maturation(popT.Egg[cohort, cohort_wk], ECDW, pars) * S_E

            # questing larvae advancement 
            # questing larvae are larvae that are able to quest for hosts.
            # their advancement is by weekly survival of cohorts.
            # matrix is [#wks x max lifespan]
            Q_l = popT.QL[cohort, cohort_wk] # current cohort and week of existence

            S_lq = calc_larval_survival_questing(popT.QL[cohort, cohort_wk], popT, week, Env, pars) # calculate survival of larval questing ticks this week
            # the host finding rate represents the number of ticks which both actively quest and find a host. 
            # not all ticks will quest in a given week, but will remain in their cohort. 
            # additionally, ticks may not find a host if the carrying capacity does not support them.
            HF_l = calc_larval_host_finding_rate(Q_l, popT, popH, week, Env, pars) # calc host finding rate
            # population in the next week is equal to survival for the week times (questing ticks - ticks that found hosts)
            popT.QL[cohort, cohort_wk + 1] = S_lq * Q_l - sum(S_lq .* HF_l .* Q_l)

            # On-host larvae
            # the number of larvae on host in the next week will add by the new larvae which found hosts from each cohort with survival.
            # advance by host
            #! should work but make sure.
            popT.OL[week + 1, :] = popT.OL[week + 1, :] .+ S_lq .* HF_l * Q_l # WFM
            # popT.OL[week + 1, 2] = popT.OL[week + 1, 2] + S_lq * HF_l[2] * Q_l # MM
            # popT.OL[week + 1, 3] = popT.OL[week + 1, 3] + S_lq * HF_l[3] * Q_l # D
            

            # Engorged Larvae 
            # engorged larvae will advance weekly by cohorts.
            # matrix is [#wks x lifespan]
            # # of EL decreases by survival.
            # The CDW of EL must also be tracked. 
            E_l = popT.EL[cohort, cohort_wk] # current engorged Larvae
            S_le = calc_larval_survival_engorged(popT, Env, week, pars) # survival for the week
            # CDW calculations
            LCDW = tally_LCDW(popT, Env, cohort, week, pars) # for input into maturation function
            popT.EL[cohort, cohort_wk + 1] = E_l * S_le - larval_maturation(popT.EL[cohort, cohort_wk], LCDW, pars) * S_le

            
            # Nymphal dynamics 
            # 
            # new hardening nymphs
            # These are freshly molted larvae, and will harden for a week before moving into the questing category.
            popT.HN[week + 1, 1] = popT.HN[week + 1, 1] + larval_maturation(popT.EL[cohort, cohort_wk], LCDW, pars) * S_le
            
            # questing nymphs advancement
            # QN advance weekly by cohort.
            # matrix is [#wks, max lifespan]
            Q_N = popT.QN[cohort, cohort_wk] # ticks in current week
            IQ_N = popT.IQN[cohort, cohort_wk] # current cohort of nymphs

            S_nq = calc_nymphal_survival_questing(popT.QN[cohort, cohort_wk], popT, week, Env, pars) # calculate survival in current week.
            # the host finding rate represents the number of ticks which both actively quest and find a host. 
            # not all ticks will quest in a given week, but will remain in their cohort. 
            # additionally, ticks may not find a host if the carrying capacity does not support them.
            HF_n = calc_nymphal_host_finding_rate(Q_N + IQ_N, popT, popH, week, Env, pars)
            # population in the next week is equal to survival for the week times (questing ticks - ticks that found hosts)
            popT.QN[cohort, cohort_wk + 1] = S_nq * Q_N - sum(S_nq .* HF_n * Q_N)

            if (isnan(popT.QN[cohort, cohort_wk + 1]))
                print(S_nq, " ", Q_N, " ", HF_n, " 5\n")
                stop()
            end

            # On-host nymphs
            # the number of nymphs on host in the next week will add by the new nymphs which found hosts from each cohort with survival.
            # update by host
            popT.ON[week + 1, :] = popT.ON[week + 1, :] .+ S_nq .* HF_n * Q_N
            # popT.ON[week + 1, 2] = popT.ON[week + 1, 2] + S_nq * HF_n * Q_N
            # popT.ON[week + 1, 3] = popT.ON[week + 1, 3] + S_nq * HF_n * Q_N
            
            # Engorged nymphs 
            # engorged nymphs will advance weekly by cohorts.
            # matrix is [#wks x lifespan]
            # # of EN decreases by survival.
            # The CDW of EN must also be tracked. 
            E_N = popT.EN[cohort, cohort_wk] # current cohort of EN 
            S_ne = calc_nymphal_survival_engorged(popT, Env, week, pars) # survival for week and cohort.
            # CDW calculations
            NCDW = tally_NCDW(popT, Env, cohort, week, pars) # for input into maturation function
            popT.EN[cohort, cohort_wk + 1] = S_ne * E_N - S_ne * nymphal_maturation(popT.EN[cohort, cohort_wk], NCDW, pars)

            # Adult dynamics
            #
            # new hardening adults 
            # These are freshly molted nymphs, and will harden for a week before moving into the questing category.
            popT.HA[week + 1, 1] = popT.HA[week + 1, 1] + S_ne * nymphal_maturation(popT.EN[cohort, cohort_wk], NCDW, pars)
            # questing adults advancement
            # QA advance by weekly cohort.
            # matrix is [#wks, max_lifespan]
            Q_A = popT.QA[cohort, cohort_wk] # current cohort of adults
            IQ_A = popT.IQA[cohort, cohort_wk] # current cohort of adults

            S_qa = calc_adult_survival_questing(Q_A, popT, week, Env, pars) # questing for the week
            # the host finding rate represents the number of ticks which both actively quest and find a host. 
            # not all ticks will quest in a given week, but will remain in their cohort. 
            # additionally, ticks may not find a host if the carrying capacity does not support them.
            HF_a = calc_adult_host_finding_rate(Q_A + IQ_A, popT, popH, week, Env, pars) 
            # population advances by survival (questing adults - adult that found a host)
            popT.QA[cohort, cohort_wk + 1] = S_qa * Q_A - sum(S_qa .* HF_a * Q_A)

            # On-host adults
            # the number of adults on host increments by the number which survived and found hosts of the current cohort.
            popT.OA[week + 1, :] = popT.OA[week + 1, :] .+ S_qa .* HF_a * Q_A
            # popT.OA[week + 1, 2] = popT.OA[week + 1, 2] + S_qa * HF_a * Q_A
            # popT.OA[week + 1, 3] = popT.OA[week + 1, 3] + S_qa * HF_a * Q_A
            
            # Engorged adults
            # engorged aults will advance weekly by cohorts.
            # matrix is [#wks x lifespan]
            # # of EA decreases by survival.
            # The CDW of EA must also be tracked. 
            E_A = popT.EA[cohort, cohort_wk] # current cohort 
            S_ae = calc_adult_survival_engorged(popT, Env, week, pars) # weekly survival
            # CDW calculations
            ACDW = tally_ACDW(popT, Env, cohort, week, pars) # for input into maturation function
            # adults simply die, no maturation
            popT.EA[cohort, cohort_wk + 1] = S_ae * E_A

            # Lay eggs!
            popT.Egg[week + 1, 1] = popT.Egg[week + 1, 1] + fecundity(popT.EA[cohort, cohort_wk] + popT.IEA[cohort, cohort_wk], ACDW, pars)


            # Engorged Larvae 
            # engorged larvae will advance weekly by cohorts.
            # matrix is [#wks x lifespan]
            # # of EL decreases by survival.
            # The CDW of EL must also be tracked. 
            IE_l = popT.IEL[cohort, cohort_wk] # current engorged Larvae
            # S_le = calc_larval_survival_engorged(Env, week) # survival for the week
            # CDW calculations
            # LCDW = tally_LCDW(popT, Env, cohort, week) # for input into maturation function
            popT.IEL[cohort, cohort_wk + 1] = IE_l * S_le - larval_maturation(popT.IEL[cohort, cohort_wk], LCDW, pars) * S_le


            # Infection dynamics
            # Infected hardening nymphs must be handled based on CDW of maturing engorged larval cohorts,
            # since multiple cohorts may mature in the same week.
            # just mature with infected tick matrix rather than all tick.
            popT.IHN[week + 1, 1] = popT.IHN[week + 1, 1] + larval_maturation(popT.IEL[cohort, cohort_wk], LCDW, pars) * S_le

            # questing infected nymphs must be tracked also by cohort, since
            # QN find hosts not all at once.
            IQ_N = popT.IQN[cohort, cohort_wk] # current cohort of nymphs
            popT.IQN[cohort, cohort_wk + 1] = S_nq * IQ_N - sum(S_nq .* HF_n * IQ_N)

            # new infected on host nymphs:
            # become infected based on # host, # susceptible nymphs, host proportions, host infection rates.
            # cannot do just once a week because cohorts find hosts, not weekly and
            # calc infection needs to consider susceptible nymphs
            # Current infected nymphs + incoming that have just found hosts + newly infected nymphs
            found_n = S_nq * HF_n * Q_N

            if (isnan(found_n[1]) || isnan(found_n[2]) || isnan(found_n[3]))
                print(S_nq, " ", HF_n, " ", Q_N, " 4\n")
            end

            popT.ION[week + 1, :] = popT.ION[week + 1, :] .+ S_nq .* HF_n * IQ_N .+ calc_infection_nymph_cohort(found_n, popH, week, pars)
            popT.ON[week + 1, :] = popT.ON[week + 1, :] .- calc_infection_nymph_cohort(found_n, popH, week, pars)
            
            if (isnan(popT.ION[week + 1, 2]))
                print("NANANANANANANANANANANANNANANANA \n")
                stop()
            end

            

            # infected Engorged nymphs 
            # infected engorged nymphs will advance weekly by cohorts.
            # matrix is [#wks x lifespan]
            # # of IEN decreases by survival.
            # The CDW of IEN must also be tracked. 
            IE_N = popT.IEN[cohort, cohort_wk] # current cohort of EN 
            # S = calc_nymphal_survival_engorged(popT.IEN[cohort, cohort_wk], week) # survival for week and cohort.
            popT.IEN[cohort, cohort_wk + 1] = S_ne * IE_N - S_ne * nymphal_maturation(popT.IEN[cohort, cohort_wk], NCDW, pars)

            # infected hardening adults must be handled based on CDW of maturing engorged nymphs as are hardening nymphs above.
            popT.IHA[week + 1, 1] = popT.IHA[week + 1, 1] + S_ne * nymphal_maturation(popT.IEN[cohort, cohort_wk], NCDW, pars)

            # questing infected adults must be tracked also by cohort, since
            # QA find hosts not all at once.
            IQ_A = popT.IQA[cohort, cohort_wk] # current cohort of adults
            popT.IQA[cohort, cohort_wk + 1] = S_qa * IQ_A - sum(S_qa .* HF_a * IQ_A)

            # new infected on host adults:
            # become infected base don the # host, # susceptible adults, host proportions, host infection rates.
            # can't do once a week, cohorts find hosts not weekly.
            # calc infection must consider susceptible.
            # these # don't really matter, since transmission to eggs doesn't happen.
            found_a = S_qa * HF_a * Q_A
            popT.IOA[week + 1, :] = popT.IOA[week + 1, :] .+ S_qa .* HF_a * IQ_A .+ calc_infection_adult_cohort(found_a, popH, week, pars)
            popT.OA[week + 1, :] = popT.OA[week + 1, :] .- calc_infection_adult_cohort(found_a, popH, week, pars)

            # Infected Engorged adults
            # infected engorged aults will advance weekly by cohorts.
            # matrix is [#wks x lifespan]
            # # of IEA decreases by survival.
            IE_A = popT.IEA[cohort, cohort_wk] # current cohort 
            # Adults die, no maturation.
            popT.IEA[cohort, cohort_wk + 1] = S_ae * IE_A

        else 
            continue
        end
    
    end

    # advancements not made on a cohort basis.

    # New questing ticks will come from the population of hardening ticks
    # which are processed weekly rather than by cohort, as they only harden for a single week.
    # new questing larvae 
    popT.QL[week + 1, 1] = hardening_l_survival(popT.HL[week, 1], week, pars) * popT.HL[week, 1]
    # new questing nymphs
    popT.QN[week + 1, 1] = hardening_N_survival(popT.HN[week, 1], week, pars) * popT.HN[week, 1]
    # new questing adults
    popT.QA[week + 1, 1] = hardening_A_survival(popT.HA[week, 1], week, pars) * popT.HA[week, 1]

    # Engorged ticks also are processed on a weekly basis, as they come off hosts after one week.
    # New Engorged larvae 
    popT.EL[week + 1, 1] = sum(larval_on_host_survival(popT, popH, week, pars) .* popT.OL[week, :])
    # New Engorged nymphs
    popT.EN[week + 1, 1] = sum(nymphal_on_host_survival(popT, popH, week, pars) .* popT.ON[week, :])
    # New Engorged adults
    popT.EA[week + 1, 1] = sum(adult_on_host_survival(popT, popH, week, pars) .* popT.OA[week, :])

    # Infection dynamics non-cohort

    # new infected On-Host Larvae:
    # Become infected based on # on host, host proportions, host infection rates.
    # Can just do once a week, since host proportions, infection rates do not change cohort wise,
    # nor does chance of infection.
    # this tracks # of larvae infected in the week 
    popT.IOL[week + 1, :] = popT.OL[week + 1, :] .* calc_infection_rate_larvae(popT, popH, Env, week, pars)
    popT.OL[week + 1, :] = popT.OL[week + 1, :] .- popT.OL[week + 1, :] .* calc_infection_rate_larvae(popT, popH, Env, week, pars)

    # new infected engorged larvae:
    # engorged larvae are simply infected at the same rate as their cohort of infected on host larvae.
    # their numbers will be smaller by survival from on host to engorged classes.
    popT.IEL[week + 1, 1] = sum(larval_on_host_survival(popT, popH, week, pars) .* popT.IOL[week, :])

    # new infected questing nymphs 
    # questing nymphs mature from hardening nymphs, so they will simply retain the rate of infection,
    # but must survive. 
    popT.IQN[week + 1, 1] = hardening_N_survival(popT.IHN[week, 1], week, pars) * popT.IHN[week, 1]

    # new infected engorged nymphs:
    # engorged nymphs are simply infected at the rate as their cohort of infected on host nymphs are
    # numbers will be reduced by survival from host to engorged classes.
    popT.IEN[week + 1, 1] = sum(nymphal_on_host_survival(popT, popH, week, pars) .* popT.ION[week, :])
    
    # new infected questing adults
    # questing adults mature from hardened nymphs, so they will retain the same rate of infection
    # with survival.
    popT.IQA[week + 1, 1] = hardening_A_survival(popT.IHA[week, 1], week, pars) * popT.IHA[week, 1]

    # new infected engorged adults:
    # infected at the rate as their cohort of infected on host adults,
    # with survival.
    popT.IEA[week + 1, 1] = sum(adult_on_host_survival(popT, popH, week, pars) .* popT.IOA[week, :])

    return nothing

end

# advance host population by time??
function advance_host_pop(popT, popH, Env, week, pars::Main.TickModel.model_pars)

    # yr_week = week % 52
    month = (week - 1) ÷ 4 + 1
    time = week

    # small mammal dynamics 
    SM = popH.SM[time, 1] # current mice sucept.
    ISM = popH.ISM[time, 1] # current mice infected.
    H = Env.H[time + 1, 1] # next week mice amount.

    SM_b = SM_birth_rate(popH, Env, pars) # birth rates
    SM_surv = SM_survival(popH, Env, week, pars) # survival rates
    infected_SM = SM_infection_rate(popT, popH, week, pars) # infection rates

    # I break up the equations here, as there is background clearance through a constant clearing rate ~ births = deaths and survival for ISM
    sm_background = SM * SM_surv + (SM + ISM) * SM_b
    ism_background  = ISM * SM_surv
    ism_infected = infected_SM * SM_surv

    # Model the flow of infected individuals from susceptible to infected
    SM_next = sm_background - ism_infected
    ISM_next = ism_background + ism_infected


    # Change in density at beginning of year:
    δ_SM = 0 # change in SM
    SM_prop = 0 # proprtion susceptible
    if week%52 == 1
        new_SM_tot = Env.H[week+1]
        if (SM_next + ISM_next != 0)
            SM_prop = SM_next/(SM_next + ISM_next) # Proportion susceptible (using background for week + 1 not current week)
        else
            SM_prop = 1
        end

        if abs(new_SM_tot - (SM_next + ISM_next)) > 0.01 # Some variation indtroduced by rounding erorr, account for this.
            δ_SM = new_SM_tot - (SM_next + ISM_next) # change will be positive if new pop bigger, else negative if new pop smaller
        end
    end

    if δ_SM < 0 # Negative change = lose from both pops
        δ_susc = (δ_SM * SM_prop) # change in susceptible
        δ_inf = (δ_SM * (1 - SM_prop)) # change in infected
    else # positive change = gain only in susceptible
        δ_susc = δ_SM # change in susceptible
        δ_inf = 0 # change in infected
    end
    #! Dumbass, make sure susceptibles gain on births, infecteds and susc lose ond deaths

    popH.SM[time + 1, 1]  = SM_next + δ_susc # Small mammals next week
    popH.ISM[time + 1, 1] = ISM_next + δ_inf  # Infected small mammals next week 

    if (popH.ISM[time + 1, 1] < 0 )
        print(SM_next + ISM_next, " ", ism_background, ' ', ism_infected, " ",δ_susc, " ", δ_inf, " ", new_SM_tot, " ", δ_SM, " ", popH.ISM[time + 1, 1], " ZEROING\n")
        popH.ISM[time + 1, 1] = 0 # round off error
    end

    if (popH.SM[time + 1, 1] < 0 )
        print(SM_next + ISM_next , " ", sm_background, " ", δ_susc, " ", new_SM_tot, " ", δ_SM, " ", popH.SM[time + 1, 1], " ZEROING\n")
        popH.SM[time + 1, 1] = 0 # round off error
    end
    # β = 0.5
    # γᵢ = 1000

    # popH.SM[time + 1] = SM + SM * (β * Env.S[time] * SM)/(γᵢ + Env.S[time]) 


    # B = 2
    # XX = 1

    # popH.SM[time + 1, 1] = SM + XX * (B * H * (SM + ISM))/(45000 + H) - XX * (1.03475 - (70 * H)/(45000 + H * 50 * (SM + ISM))) * SM

    # # print(ISM, "\n")
    # # print(SM_infection_rate(popT, popH, time), "\n")
    # # print((1.03475 - (70 * A)/(500000 + A * 50 * (SM + ISM))), "\n")

    # popH.ISM[time + 1, 1] = ISM + SM_infection_rate(popT, popH, time) - XX * (1.03475 - (70 * H)/(45000 + H * 50 * (SM + ISM))) * ISM
    # popH.SM[time + 1, 1] = popH.SM[time + 1, 1] - SM_infection_rate(popT, popH, time)

    # popH.SM[time + 1] = SM * SM_surv + SM * SM_b  
    # M[i-1] + M[i-1] * (β * Aᵢ[i] * M[i])/(γᵢ + Aᵢ[i])
    
    # # infection
    # # small mammals are infected according to the infected tick burden for the week.
    # # also clear out with deaths. 
    # ISM = popH.ISM[time]
    # # ISM_surv = SM_survival(popH, Env, week)

    # prop_inf = (popT.IOL[time, 1]/popH.SM[time])
    # if prop_inf > 1 
    #     prop_inf = 1
    # end

    # popH.ISM[time + 1, 1] = ISM * SM_surv + SM_infection_rate(popT, popH, time) * prop_inf * popH.SM[time]
    # popH.SM[time + 1, 1] = popH.SM[time + 1, 1] - SM_infection_rate(popT, popH, time) * prop_inf * popH.SM[time]

    # print("death", 1.03475 - (70 * A)/(500000 + A * 50 * ISM), "\n")


    # medium mammal jackets
    MM = popH.MM[time]
    IMM = popH.IMM[time, 1]
    MM_b = MM_birth_rate(popH, Env, pars)
    MM_surv = MM_survival(popH, Env, week, pars)
    popH.MM[time + 1, 1] = MM * MM_surv + (MM + IMM) * MM_b  

    # infection
    # medium mammals are infected according to the infected tick burden for the week.
    # also clear out with deaths. 

    IMM_surv = MM_survival(popH, Env, week, pars)
    infected_MM = MM_infection_rate(popT, popH, week, pars)
    # print(infected_MM, "\n")

    # print(popH.IMM[time+1,1], " IMM1 \n")
    popH.IMM[time + 1, 1] = IMM * IMM_surv + infected_MM * MM_surv
    # print(popH.IMM[time+1,1], " IMM2 \n")
    popH.MM[time + 1, 1] = popH.MM[time + 1, 1] - infected_MM * MM_surv
    
    # Deer
    D = popH.D[time, 1]
    ID = popH.ID[time]
    D_b = D_birth_rate(popH, Env, pars)
    D_surv = D_survival(popH, Env, week, pars)
    popH.D[time + 1] = D * D_surv + (D + ID) * D_b  

    # infection
    # deer are infected according to the infected tick burden for the week.
    # also clear out with deaths. 
    ID_surv = D_survival(popH, Env, week, pars)
    infected_D = D_infection_rate(popT, popH, week, pars)

    popH.ID[week + 1, 1] = ID * ID_surv + infected_D * ID_surv
    popH.D[week + 1, 1] = popH.D[week + 1, 1] - infected_D * ID_surv

    return nothing
end

# Proper rate functions

##### Ticks

# CDW Helper functions
# Tally CDW for each age class if current week temp is above threshold.
function tally_ECDW(popT, Env, cohort, week, pars::Main.TickModel.model_pars) 

    if (Env.T[week, 1] > pars.CDWₘₑ)
        popT.ECDW[cohort, 1] = popT.ECDW[cohort, 1] + Env.T[week, 1] # increment CDW
    end

    return popT.ECDW[cohort, 1]

end


function tally_LCDW(popT, Env, cohort, week, pars::Main.TickModel.model_pars) 

    if (Env.T[week, 1] > pars.CDWₘₗ)
        popT.LCDW[cohort, 1] = popT.LCDW[cohort, 1] + Env.T[week, 1] # increment CDW
    end
    
    return popT.LCDW[cohort, 1]

end


function tally_NCDW(popT, Env, cohort, week, pars::Main.TickModel.model_pars) 

    if (Env.T[week, 1] > pars.CDWₘₙ)
        popT.NCDW[cohort, 1] = popT.NCDW[cohort, 1] + Env.T[week, 1] # increment CDW
    end
    
    return popT.NCDW[cohort, 1]

end


function tally_ACDW(popT, Env, cohort, week, pars::Main.TickModel.model_pars) 

    if (Env.T[week, 1] > pars.CDWₘₐ)
        popT.ACDW[cohort, 1] = popT.ACDW[cohort, 1] + Env.T[week, 1] # increment CDW
    end
    
    return popT.ACDW[cohort, 1]

end


# reproduction
function fecundity(EA, CDW, pars::Main.TickModel.model_pars) 

    if (CDW > pars.CDWₐ) 
        return EA * pars.fec # avg. according to oliver1993conspecificity
    end

    return 0
    
end


# maturation 
function egg_maturation(Eggs, CDW, pars::Main.TickModel.model_pars)

    if (CDW > pars.CDWₑ) 
        return Eggs
    end

    return 0

end

function larval_maturation(EL, CDW, pars::Main.TickModel.model_pars)

    if (CDW > pars.CDWₗ)
        return EL
    end

    return 0

end

function nymphal_maturation(EN, CDW, pars::Main.TickModel.model_pars)

    if (CDW > pars.CDWₙ)
        return EN
    end

    return 0 

end

# survival
function calc_egg_survival(popT, Env, week, pars::Main.TickModel.model_pars)

    d = popT.immat_survival_t
    activity = pdf(d, Env.T[week])/( 1/sqrt(2 * π * d.σ^2))

    d2 = popT.all_survival_p
    activity2 = pdf(d2, Env.PI[week])/( 1/sqrt(2 * π * d2.σ^2))

    # print(0.9505593 * activity * activity2 - activity * activity2, " SE\n")


    return activity * activity2
    # * 0.9505593 # Mount 1997
    # return 0.985^7
    # 0.985^7 # calculated from daniels1996timing
    # T = Env.T[week]

    # return 0.9505593 * (at + ct*dfTemp + et * Env.T[week]^2))/(1 + bt*Env.T[week] + Env.T[week]^2)

end

function calc_larval_survival_questing(QL, popT, week, Env, pars::Main.TickModel.model_pars)

    # if (Env.T[week] <= 10.8 || Env.T[week] >= 30.2) 
    #     return 0
    # end
    d = popT.immat_survival_t
    activity = pdf(d, Env.T[week])/( 1/sqrt(2 * π * d.σ^2))

    d2 = popT.all_survival_p
    activity2 = pdf(d2, Env.PI[week])/( 1/sqrt(2 * π * d2.σ^2))

    return activity * activity2
    # * 0.9647684 # Mount 1997

    # return 0.01(40)^0.515(-0.0105 * Env.T[week]^2 + 0.4316*Env.T[week] - 3.424) * (0.03116 - 0.007615 * Env.D[week])/(1 - 0.1374 * Env.D[week] + 0.004788 * Env.D[week] ^ 2)

    # return 0.906^7
    #0.999^7 # estimated from daniels1996timing

end

function calc_larval_survival_engorged(popT, Env, week, pars::Main.TickModel.model_pars)

    d = popT.immat_survival_t
    activity = pdf(d, Env.T[week])/( 1/sqrt(2 * π * d.σ^2))

    d2 = popT.all_survival_p
    activity2 = pdf(d2, Env.PI[week])/( 1/sqrt(2 * π * d2.σ^2))

    return activity * activity2
    # * 0.9781032 # Mount 1997 
    
    # 0.999^7 # estimated from daniels1996timing
    
end

function hardening_l_survival(HL, week, pars::Main.TickModel.model_pars)

    return pars.Sₕₗ # Mount 1997
    
    # 0.99^7 # from wallace2019effect

end

function larval_on_host_survival(popT, popH, week, pars::Main.TickModel.model_pars)

    max_surv = [pars.Sₓᵢ₁, pars.Sₓᵢ₂, pars.Sₓᵢ₃ ]
    min_surv = [pars.Sₘᵢ₁, pars.Sₘᵢ₂, pars.Sₘᵢ₃ ]
    max_EI = [pars.EIₓ₁, pars.EIₓ₂, pars.EIₓ₃ ]
    min_EI = [pars.EIₘ₁, pars.EIₘ₂, pars.EIₘ₃ ]
    EI = engorgement_index(popT, popH, week, pars)
    survs = ones(3)

    for i in 1:3
        if EI[i] < min_EI[i]
            survs[i] = max_surv[i]
        elseif EI[i] > max_EI[i]
            survs[i] = min_surv[i]
        else 
            survs[i] = (min_surv[i] - max_surv[i])/(max_EI[i] - min_EI[i]) * (EI[i] - min_EI[i]) + max_surv[i]
        end
    end
    # return 0.49 # levi2016quantifying
    # print(EI, " \n")
    return survs

end

function calc_nymphal_survival_questing(QN, popT, week, Env, pars::Main.TickModel.model_pars)

    # if (Env.T[week] <= 10.8 || Env.T[week] >= 30.2) 
    #     return 0
    # end

    d = popT.immat_survival_t
    activity = pdf(d, Env.T[week])/( 1/sqrt(2 * π * d.σ^2))

    d2 = popT.all_survival_p
    activity2 = pdf(d2, Env.PI[week])/( 1/sqrt(2 * π * d2.σ^2))

    return activity * activity2
    # * 0.9994695 # Mount 1997
    # return 0.906^7

    # return 0.01(40)^0.515(-0.0105 * Env.T[week]^2 + 0.4316*Env.T[week] - 3.424) * (0.03116 - 0.007615 * Env.D[week])/(1 - 0.1374 * Env.D[week] + 0.004788 * Env.D[week] ^ 2)

end

function calc_nymphal_survival_engorged(popT, Env, week, pars::Main.TickModel.model_pars)

    d = popT.immat_survival_t
    activity = pdf(d, Env.T[week])/( 1/sqrt(2 * π * d.σ^2))

    d2 = popT.all_survival_p
    activity2 = pdf(d2, Env.PI[week])/( 1/sqrt(2 * π * d2.σ^2))

    return activity * activity2
    # * 0.9840243 # Mount 1997

    # 0.001 # from wallace2019effect

end

function hardening_N_survival(HN, week, pars::Main.TickModel.model_pars)

    return pars.Sₕₙ # Mount 1997

end

function nymphal_on_host_survival(popT, popH, week, pars::Main.TickModel.model_pars)

    max_surv = [pars.Sₓᵢ₁, pars.Sₓᵢ₂, pars.Sₓᵢ₃ ]
    min_surv = [pars.Sₘᵢ₁, pars.Sₘᵢ₂, pars.Sₘᵢ₃ ]
    max_EI = [pars.EIₓ₁, pars.EIₓ₂, pars.EIₓ₃ ]
    min_EI = [pars.EIₘ₁, pars.EIₘ₂, pars.EIₘ₃ ]
    EI = engorgement_index(popT, popH, week, pars)
    survs = ones(3)

    for i in 1:3
        if EI[i] < min_EI[i]
            survs[i] = max_surv[i]
        elseif EI[i] > max_EI[i]
            survs[i] = min_surv[i]
        else 
            survs[i] = (min_surv[i] - max_surv[i])/(max_EI[i] - min_EI[i]) * (EI[i] - min_EI[i]) + max_surv[i]
        end
    end
    # return 0.49 # levi2016quantifying
    return survs
end

function calc_adult_survival_questing(EA, popT, week, Env, pars::Main.TickModel.model_pars)

    # if (Env.T[week] <= 0 || Env.T[week] >= 20.2) 
    #     return 0
    # end

    d = popT.mat_survival_t
    activity = pdf(d, Env.T[week])/( 1/sqrt(2 * π * d.σ^2))

    d2 = popT.all_survival_p
    activity2 = pdf(d2, Env.PI[week])/( 1/sqrt(2 * π * d2.σ^2))

    return activity * activity2
    # * 0.9999692 # Mount 1997
    # return 0.906^7

    # return 0.1(0.4)^0.515(-0.0095 * Env.T[week]^2 + 0.19*Env.T[week] - 0.05)

end 

function calc_adult_survival_engorged(popT, Env, week, pars::Main.TickModel.model_pars)

    d = popT.mat_survival_t
    activity = pdf(d, Env.T[week])/( 1/sqrt(2 * π * d.σ^2))

    d2 = popT.all_survival_p
    activity2 = pdf(d2, Env.PI[week])/( 1/sqrt(2 * π * d2.σ^2))

    return activity * activity2
    # * 0.9847878 # Mount 1997 

    # 0.001 # from wallace2019effect

end

function hardening_A_survival(HA, week, pars::Main.TickModel.model_pars)

    return pars.Sₕₐ # Mount 1997

end

function adult_on_host_survival(popT, popH, week, pars::Main.TickModel.model_pars)


    max_surv = [pars.Sₓₐ₁, pars.Sₓₐ₂, pars.Sₓₐ₃ ]
    min_surv = [pars.Sₘᵢ₁, pars.Sₘᵢ₂, pars.Sₘᵢ₃ ]
    max_EI = [pars.EIₓ₁, pars.EIₓ₂, pars.EIₓ₃ ]
    min_EI = [pars.EIₘ₁, pars.EIₘ₂, pars.EIₘ₃ ]
    EI = engorgement_index(popT, popH, week, pars)
    survs = ones(3)

    for i in 1:3
        if EI[i] < min_EI[i]
            survs[i] = max_surv[i]
        elseif EI[i] > max_EI[i]
            survs[i] = min_surv[i]
        else 
            survs[i] = (min_surv[i] - max_surv[i])/(max_EI[i] - min_EI[i]) * (EI[i] - min_EI[i]) + max_surv[i]
        end
    end
    # return 0.49 # levi2016quantifying
    return survs

end

function engorgement_index(popT, popH, week, pars::Main.TickModel.model_pars)

    EI = zeros(3)
    EI_scl = [pars.EIₛₗ, pars.EIₛₙ, pars.EIₛₐ]
    hosts = [
        popH.SM[week, 1] + popH.ISM[week, 1],
        popH.MM[week, 1] + popH.IMM[week, 1],
        popH.D[week, 1] + popH.ID[week, 1]
    ]


    for i in 1:3
        week_i = 1 # iter for summation
        while week_i < 10 && week - week_i > 0
            ticks_on_host = [
                popT.OL[week - week_i, i] + popT.IOL[week - week_i, i], 
                popT.ON[week - week_i, i] + popT.ION[week - week_i, i],
                popT.OA[week - week_i, i] + popT.IOA[week - week_i, i]]
        
            if (hosts[i] > 0)
                EI[i] = EI[i] + pars.EIₗ ^ (week_i - 1) * sum(EI_scl .*  ticks_on_host)/ hosts[i]
            else 
                EI[i] = 0
                week_i = 10
            end
            week_i += 1
        end
    end

    # print(EI, " ", hosts, " ", week, " ", 0.44 ^ (week - 1),  " \n")

    return EI
end


function calc_larval_host_finding_rate(QL, popT, popH, week, Env, pars::Main.TickModel.model_pars)

    # d = Normal(25, 5)
    # activity = pdf(d, Env.T[week])/( 1/sqrt(2 * π * 5^2))
    d = popT.immat_hf
    activity = pdf(d, Env.T[week])/( 1/sqrt(2 * π * d.σ^2)) # (DEFUNCT) calc_activity_questing(25, 5, Env, week)
    hosts = [popH.SM[week] + popH.ISM[week], popH.MM[week] + popH.IMM[week], popH.D[week] + popH.ID[week]]
    hosts_caps_larv = [pars.Bₕₗ₁, pars.Bₕₗ₂, pars.Bₕₗ₃]
 
    #! make this one param 
    # BHFR_SM = 0.01
    # BHFR_MM = 0.025
    # BHFR_D = 0.05
    BHFR = [pars.aₕ₁, pars.aₕ₂, pars.aₕ₃]
    b = pars.b

    HFR = zeros(3)

    if (hosts[1] < 0) 
        print(popH.SM[week], " ", popH.ISM[week], " -1\n")
    end
    
    HFR = BHFR .* hosts.^b * activity
    # HFR[2] = BHFR_MM * (popH.MM[week] ^ b) * activity
    # HFR[3] = BHFR_D * (popH.D[week] ^ b) * activity

    found = HFR .* QL
    next_week = popT.OL[week + 1, :] .+ found
    capacity = hosts .* hosts_caps_larv

    for i in 1:3
        if (next_week[i] > capacity[i] && found[i] != 0)
            diff_cap = capacity[i] - next_week[i]
            HFR_scale = 1 + diff_cap/found[i]

            if (HFR_scale < 0)
                return 0
            end

            HFR[i] = HFR_scale * HFR[i]
        end
    end

    return HFR

end

function calc_nymphal_host_finding_rate(QN, popT, popH, week, Env, pars::Main.TickModel.model_pars)

    # d = Normal(25, 5)
    # activity = pdf(d, Env.T[week])/( 1/sqrt(2 * π * 5^2))
    d = popT.immat_hf
    activity = pdf(d, Env.T[week])/( 1/sqrt(2 * π * d.σ^2)) # (DEFUNCT) calc_activity_questing(25, 5, Env, week)
    hosts = [popH.SM[week] + popH.ISM[week], popH.MM[week] + popH.IMM[week], popH.D[week] + popH.ID[week]]
    hosts_caps_nymph = [pars.Bₕₙ₁, pars.Bₕₙ₂, pars.Bₕₙ₃ ]

    BHFR = [pars.aₕ₁, pars.aₕ₂, pars.aₕ₃]
    b = pars.b

    HFR = zeros(3)
    HFR = BHFR .* hosts.^b * activity

    if (isnan(HFR[1]) || isnan(HFR[2]) || isnan(HFR[3]))

        print(BHFR, " ", hosts, " ", activity, popH.SM[week], " ", popH.ISM[week], " 5\n")
    end

    found = HFR .* QN
    next_week = popT.ON[week + 1, :] .+ found
    capacity = hosts .* hosts_caps_nymph
    
    for i in 1:3
        if (next_week[i] > capacity[i] && found[i] != 0)
            diff_cap = capacity[i] - next_week[i]
            HFR_scale = 1 + diff_cap/found[i]

            if (HFR_scale < 0)
                return 0
            end

            HFR[i] = HFR_scale * HFR[i]
        end
    end

    return HFR

end

function calc_adult_host_finding_rate(QA, popT, popH, week, Env, pars::Main.TickModel.model_pars)

    # d = Normal(8, 5)
    # activity = pdf(d, Env.T[week])/( 1/sqrt(2 * π * 5^2))
    d = popT.mat_hf
    activity = pdf(d, Env.T[week])/( 1/sqrt(2 * π * d.σ^2))# (DEFUNCT) calc_activity_questing(8, 5, Env, week)
    hosts = [popH.SM[week] + popH.ISM[week], popH.MM[week] + popH.IMM[week], popH.D[week] + popH.ID[week]]
    hosts_caps_adult = [pars.Bₕₐ₁, pars.Bₕₐ₂, pars.Bₕₐ₃]

    BHFR = [pars.aₕ₁, pars.aₕ₂, pars.aₕ₃]
    b = pars.b
    
    HFR = BHFR .* hosts.^b * activity

    found = HFR .* QA
    next_week = popT.OA[week + 1, :] .+ found
    capacity = hosts .* hosts_caps_adult

    for i in 1:3
        if (next_week[i] > capacity[i] && found[i] != 0)
            diff_cap = capacity[i] - next_week[i]
            HFR_scale = 1 + diff_cap/found[i]

            if (HFR_scale < 0)
                return 0
            end

            HFR[i] = HFR_scale * HFR[i]
        end
    end

    return HFR

end

# Now defunct function.
function calc_activity_questing(μ, σ, Env, week, pars::Main.TickModel.model_pars)

    d = Normal(μ, σ)
    activity = pdf(d, Env.T[week])/( 1/sqrt(2 * π * σ^2))
    return activity

end


# infection dynamics

function infection_to_ticks(popH, week, pars::Main.TickModel.model_pars)

    if popH.SM[week, 1] + popH.ISM[week, 1] > 0
        infection_sm = pars.C₁ * popH.ISM[week]/(popH.SM[week] + popH.ISM[week])
    else
        infection_sm = 0
    end
        infection_mm = pars.C₂ * popH.IMM[week]/(popH.MM[week] + popH.IMM[week])
        infection_d = 0

    if (infection_sm == -Inf) 
        print(popH.ISM[week], " ", popH.SM[week], " 2\n")
    end

    if (isnan(infection_mm))
        print(popH.MM[week,1], " ", popH.IMM[week,1], " ", week, " -2, $(Threads.threadid())\n")
        print(popH.MM[week:week], "\n", popH.IMM[week:week], " ", week, " -3, $(Threads.threadid())\n")
        stop()
    end

    return [infection_sm, infection_mm, infection_d]

end

function calc_infection_rate_larvae(popT, popH, Env, week, pars::Main.TickModel.model_pars)

    return infection_to_ticks(popH, week, pars)

end

function calc_infection_nymph_cohort(found, popH, week, pars::Main.TickModel.model_pars)

    infection_to_tick = infection_to_ticks(popH, week, pars)

    infect = (infection_to_tick .* found)

    if (isnan(infect[2]))
        print(infection_to_tick, " ", found, " 3\n")
    end

    return infect

end

function calc_infection_adult_cohort(found, popH, week, pars::Main.TickModel.model_pars)

    infection_to_tick = infection_to_ticks(popH, week, pars)

    infect = ( infection_to_tick .* found)

    return infect

end


##### Hosts
# birth rates

function SM_birth_rate(pop, ENV, pars::Main.TickModel.model_pars)

    return 1 - pars.S₁

end

function MM_birth_rate(pop, Env, pars::Main.TickModel.model_pars)

    return 1 - pars.S₂

end

function D_birth_rate(pop, Env, pars::Main.TickModel.model_pars)

    return 1 - pars.S₃

end


# survival 

function SM_survival(pop, Env, week, pars::Main.TickModel.model_pars)

    return pars.S₁

end

function MM_survival(pop, Env, week, pars::Main.TickModel.model_pars)

    return pars.S₂

end

function D_survival(pop, Env, week, pars::Main.TickModel.model_pars)

    return pars.S₃

end


# infection rates 

function SM_infection_rate(popT, popH, week, pars::Main.TickModel.model_pars)

    if popH.SM[week] + popH.ISM[week] > 0
        perc_trans = popT.perc_trans

        # infectivity factor
        TIF = pars.TIF

        # get infected tick density
        ITD = popT.ION[week, 1]
        ITH = ITD/(popH.SM[week,1] + popH.ISM[week,1]) * TIF

        infect_idx = convert(Int64,round(ITH * 100) + 1)

        if infect_idx > 750 
            effect_trans = 1
        else 
            effect_trans = perc_trans[infect_idx]/100
        end

        # print(effect_trans, " effect trans\n")

        return effect_trans * popH.SM[week,1]
    end

    return 0

end

function MM_infection_rate(popT, popH, week, pars::Main.TickModel.model_pars)

    if popH.MM[week] + popH.IMM[week] > 0
        perc_trans = popT.perc_trans

        # infectivity factor
        TIF = pars.TIF

        # get infected tick density
        ITD = popT.ION[week, 2] + popT.IOA[week, 2]
        ITH = ITD/(popH.MM[week,1] + popH.IMM[week,1]) * TIF
        
        # print(popH.MM[week] + popH.IMM[week], " 1\n")
        # print(popH.SM[week], " 2\n")
        # print(ITH, " 3\n")
        # print(ITD, " 4,\n")
        # print(popT.ION[week, 2], " 1\n")
        infect_idx = convert(Int64,round(ITH * 100) + 1)

        if infect_idx > 750 
            effect_trans = 1
        else 
            # print( "\n", popT.ION[week, 2], " ", popT.IOA[week, 2])
            effect_trans = perc_trans[infect_idx]/100
        end

        # print(effect_trans, " effect trans\n")

        return effect_trans * popH.MM[week,1]
    end

    return 0

end

function D_infection_rate(popT, popH, week, pars::Main.TickModel.model_pars)

    if popH.D[week] + popH.ID[week] > 0
        perc_trans = popT.perc_trans

        # infectivity factor
        TIF = pars.TIF

        # get infected tick density
        ITD = popT.ION[week, 3] + popT.IOA[week, 3]
        ITH = ITD/(popH.D[week,1] + popH.ID[week,1]) * TIF

        infect_idx = convert(Int64,round(ITH * 100) + 1)

        if infect_idx > 750 
            effect_trans = 1
        else 
            effect_trans = perc_trans[infect_idx]/100
        end

        # print(effect_trans, " effect trans\n")

        return effect_trans * popH.D[week,1]
    end

    return 0

end

function effective_transmission()

    num_tick_steps = 750 # for monte carlo simulation
    num_sims = 1000 # for monte carlo simulation
    host_infected = ones(num_tick_steps,num_sims)
    perc_trans = ones(1,num_tick_steps)
    
    for i in 1:num_tick_steps 
      for sim in 1:num_sims
        num_infected_ticks = i#*10 #Number of ticks that will infect
        ## Take num_infected_tick samples and assign each tick to host # from 1:100
        infected_hosts = sample(1:100, num_infected_ticks, replace = true)
        ## Only keep unique hosts and count this number as number infected
        host_infected[i,sim] = length(unique(infected_hosts))
      end
      #Get mean num hosts with infected ticks per row (infected tick density)
      perc_trans[i] = mean(host_infected[i,:])
    end

    return perc_trans

end
