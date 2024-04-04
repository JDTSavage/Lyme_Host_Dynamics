# Plot time series of the data
include("base_model.jl")

Model = TickModel

# Stupid stuff to add bc of a change I made

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

num_wks = 52*50
lifespan = 52
tick_pop = Model.gen_tick_pop(Model, num_wks, lifespan, ones(1,1), paras_og)
host_pop = Model.gen_host_pop(Model, num_wks)

tick_pop2 = deepcopy(tick_pop)
host_pop2 = deepcopy(host_pop)

output_dir = "Exploratory_Plots/PortlandME_1971-2021"
location = "PortlandME_1971-2021"
CDW_stat = "standard" # Standard CDW or realistic ones?
load_dir = "/media/jdtsavage22/Research/honors_thesis/Output_Data/" # "R:/honors_thesis/Output_Data/"

μ = 35
σ = 0

# lifespan_52 data is latest output. JDTS Nov 24, 2023
sim_name = "lifespan_52_mice_$(μ)_$(σ)_$(location)_$(CDW_stat).csv" # set simname for file access

Model.load_pop(tick_pop, host_pop, μ, σ, load_dir, sim_name)

μ2 = 35
σ2 = 25

sim_name2 = "lifespan_52_mice_$(μ2)_$(σ2)_$(location)_$(CDW_stat).csv" # set simname for file access


Model.load_pop(tick_pop2, host_pop2, μ2, σ2, load_dir, sim_name2)


# plot number of mice
plot(host_pop.SM + host_pop.ISM)

# plot time series of questing larvae, nymphs, adults and eggs, these on host, and mice
k = 5 # years to plot

# plot((tick_pop.QL[:, 1])[end-52*k:end])
# # shade background every 52 weeks

# xlabel("week")
# ylabel("number of larvae")
# xlim(0, 52*k)
# tight_layout()

fig, ax = plt.subplots(3, 2, figsize=(12,6))
ax[1].ticklabel_format(useOffset=false, style="scientific", scilimits=(-2,2))
ax[1].plot(tick_pop.Egg[:, 1][end-52*k:end], "#44AA99")
ax[1].plot((tick_pop.QL[:, 1])[end-52*k:end], "#88CCEE")
ax_s1 = ax[1].twinx()
ax_s1.plot((tick_pop.QN[:, 1] + tick_pop.IQN[:, 1])[end-52*k:end], "#DDCC77", )
ax_s1.plot((tick_pop.QA[:, 1] + tick_pop.IQA[:, 1])[end-52*k:end], "#CC6677")
ax_s1.set_yticklabels([])
ax_s1.set_yticks([])
ax[1].set_xticks([])
ax[1].set_ylim([0, 1.1*max(
    maximum(tick_pop.Egg[:, 1][end-52*k:end]), maximum(tick_pop2.Egg[:, 1][end-52*k:end]), 
    maximum(tick_pop.QL[:, 1][end-52*k:end]), maximum(tick_pop2.QL[:, 1][end-52*k:end]),
    maximum(tick_pop.QN[:, 1][end-52*k:end]), maximum(tick_pop2.QN[:, 1][end-52*k:end]),
    maximum(tick_pop.QA[:, 1][end-52*k:end]), maximum(tick_pop2.QA[:, 1][end-52*k:end]))])
ax[1].set_ylabel("# eggs & larvae")


ax[2].ticklabel_format(useOffset=false, style="scientific", scilimits=(-2,2))
ax[2].plot((tick_pop.OL[:, 1] + tick_pop.OL[:, 2] + tick_pop.OL[:, 3] + tick_pop.IOL[:, 3])[end-52*k:end], "#88CCEE")
ax[2].plot(2*((tick_pop.ON[:, 1] + tick_pop.ION[:, 1]) + (tick_pop.ON[:, 2] + tick_pop.ION[:, 2]) + (tick_pop.ON[:, 3] + tick_pop.ION[:, 3]))[end-52*k:end], "#DDCC77")
ax[2].plot(20*(tick_pop.OA[:, 1] + tick_pop.IOA[:, 1] + tick_pop.OA[:, 2] + tick_pop.IOA[:, 2] + tick_pop.OA[:, 3] + tick_pop.IOA[:, 3])[end-52*k:end], "#CC6677")
ax[2].set_xticks([])
ax[2].set_ylim([0, 4.5*1e3])

#		1.1*max(
#    maximum(tick_pop.OL[:, 1][end-52*k:end] + tick_pop.IOL[:, 1][end-52*k:end]), maximum(tick_pop2.OL[:, 1][end-52*k:end] + tick_pop2.IOL[:, 1][end-52*k:end]),
#    maximum(tick_pop.ON[:, 1][end-52*k:end] + tick_pop.ION[:, 1][end-52*k:end]), maximum(tick_pop2.ON[:, 1][end-52*k:end] + tick_pop2.ION[:, 1][end-52*k:end]),
#    maximum(tick_pop.OA[:, 1][end-52*k:end] + tick_pop.IOA[:, 1][end-52*k:end]), maximum(tick_pop2.OA[:, 1][end-52*k:end] + tick_pop2.IOA[:, 1][end-52*k:end]))])
ax[2].set_ylabel("ticks on hosts")

ax[3].ticklabel_format(useOffset=false, style="scientific", scilimits=(-3,3))
ax[3].plot(round.(host_pop.SM[end-52*k:end] + host_pop.ISM[end-52*k:end]), "#000000")
ax[3].set_ylim([0, 80])    
ax[3].set_ylabel(L"mouse density (ind ha$^{-1}$)")
ax[3].set_xticks([52, 104, 156, 208, 260])

ax[4].ticklabel_format(useOffset=false, style="scientific", scilimits=(-3,3))
ax[4].plot(tick_pop2.Egg[:, 1][end-52*k:end], "#44AA99")
ax[4].plot((tick_pop2.QL[:, 1])[end-52*k:end], "#88CCEE")
ax_s2 = ax[4].twinx()
ax_s2.plot((tick_pop2.QN[:, 1] + tick_pop2.IQN[:, 1])[end-52*k:end], "#DDCC77")
ax_s2.plot((tick_pop2.QA[:, 1] + tick_pop2.IQA[:, 1])[end-52*k:end], "#CC6677")
ax_s2.ticklabel_format(useOffset=false, style="scientific", scilimits=(-3,3))
ax_s2.set_ylabel("# nymphs and adults")
ax[4].set_xticks([])
ax[4].set_ylim([0, 1.1*max(
    maximum(tick_pop2.Egg[:, 1][end-52*k:end]), maximum(tick_pop.Egg[:, 1][end-52*k:end]), 
    maximum(tick_pop2.QL[:, 1][end-52*k:end]), maximum(tick_pop.QL[:, 1][end-52*k:end]),
    maximum(tick_pop2.QN[:, 1][end-52*k:end]), maximum(tick_pop.QN[:, 1][end-52*k:end]),
    maximum(tick_pop2.QA[:, 1][end-52*k:end]), maximum(tick_pop.QA[:, 1][end-52*k:end]))])
ax[4].set_yticks([])
ax[4].legend(["eggs", "larvae"], bbox_to_anchor=(1.12, 1), frameon=false)
ax_s2.legend(["nymphs", "adults"], bbox_to_anchor=(1.12, 0.7), frameon=false)
ax[5].ticklabel_format(useOffset=false, style="scientific", scilimits=(-3,3))
# ax[5].plot(tick_pop2.IOL[:,1][end-52*k:end]./(tick_pop2.OL[:,1][end-52*k:end] .+ tick_pop2.IOL[:,1][end-52*k:end]))
ax[5].plot((tick_pop2.OL[:, 1] + tick_pop2.OL[:, 2] + tick_pop2.OL[:, 3] + tick_pop2.IOL[:, 3])[end-52*k:end], "#88CCEE")
ax[5].plot(2*((tick_pop2.ON[:, 1] + tick_pop2.ION[:, 1]) + (tick_pop2.ON[:, 2] + tick_pop2.ION[:, 2]) + (tick_pop2.ON[:, 3] + tick_pop2.ION[:, 3]))[end-52*k:end], "#DDCC77")
ax[5].plot(20*(tick_pop2.OA[:, 1] + tick_pop2.IOA[:, 1] + tick_pop2.OA[:, 2] + tick_pop2.IOA[:, 2] + tick_pop2.OA[:, 3] + tick_pop2.IOA[:, 3])[end-52*k:end], "#CC6677")
ax[5].set_xticks([])
ax[5].set_ylim([0, 4.5*1e3])

#		1.1*max(
#    maximum(tick_pop2.OL[:, 1][end-52*k:end] + tick_pop2.IOL[:, 1][end-52*k:end]), maximum(tick_pop.OL[:, 1][end-52*k:end] + tick_pop.IOL[:, 1][end-52*k:end]),
#    maximum(tick_pop2.ON[:, 1][end-52*k:end] + tick_pop2.ION[:, 1][end-52*k:end]), maximum(tick_pop.ON[:, 1][end-52*k:end] + tick_pop.ION[:, 1][end-52*k:end]),
#    maximum(tick_pop2.OA[:, 1][end-52*k:end] + tick_pop2.IOA[:, 1][end-52*k:end]), maximum(tick_pop.OA[:, 1][end-52*k:end] + tick_pop.IOA[:, 1][end-52*k:end]))])
ax[5].set_yticks([])
ax[5].legend(["larvae", "2x nymphs", "20x adults"], bbox_to_anchor=(0.99, 1), frameon=false)

ax[6].ticklabel_format(useOffset=false, style="scientific", scilimits=(-3,3))
ax[6].plot(host_pop2.SM[end-52*k:end] + host_pop2.ISM[end-52*k:end], "#000000")
ax[6].set_ylim([0, 80])
ax[6].set_yticks([])
ax[6].set_xticks([52, 104, 156, 208, 260])

# add (a), (b), (c), (d), (e), (f) labels to each subplot
ax[1].text(0.01, 0.95, "(a)", transform=ax[1].transAxes, fontsize=10, verticalalignment="top")
ax[2].text(0.01, 0.95, "(b)", transform=ax[2].transAxes, fontsize=10, verticalalignment="top")
ax[3].text(0.01, 0.95, "(c)", transform=ax[3].transAxes, fontsize=10, verticalalignment="top")
ax[4].text(0.01, 0.95, "(d)", transform=ax[4].transAxes, fontsize=10, verticalalignment="top")
ax[5].text(0.01, 0.95, "(e)", transform=ax[5].transAxes, fontsize=10, verticalalignment="top")
ax[6].text(0.01, 0.95, "(f)", transform=ax[6].transAxes, fontsize=10, verticalalignment="top")

# set xlims for all subplots
ax[1].set_xlim([0, 52*k])
ax[2].set_xlim([0, 52*k])
ax[3].set_xlim([0, 52*k])
ax[4].set_xlim([0, 52*k])
ax[5].set_xlim([0, 52*k])
ax[6].set_xlim([0, 52*k])


for axis in ax
    for i in 0:k
        if i % 2 == 0
            axis.axvspan(52*i, 52*(i+1), alpha=0.2, color="grey")
        end
    end
end

fig.text(0.5, 0.04, "Time (weeks)", ha="center")
fig.subplots_adjust(hspace=0.15, wspace=0.05)

# save figure
fig.savefig("Analysis_Data/Exploratory_Plots/PortlandME_1971-2021/publication_ts.png", bbox_inches="tight")
