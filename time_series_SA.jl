# Plot time series of the data
include("base_model.jl")

Model = TickModel
num_wks = 52*50
lifespan = 52
tick_pop = Model.gen_tick_pop(Model, num_wks, lifespan, ones(1,1))
host_pop = Model.gen_host_pop(Model, num_wks)

tick_pop2 = deepcopy(tick_pop)
host_pop2 = deepcopy(host_pop)

output_dir = "Exploratory_Plots/PortlandME_1971-2021"
loc = "PortlandME_1971-2021"
CDW_stat = "standard" # Standard CDW or realistic ones?
load_dir = "R:/honors_thesis/SA/"

μ = 40
σ = 0

sim_name = "mice_$(μ)_$(σ)_$(loc)_$(CDW_stat).csv" # set simname for file access

Model.load_pop(tick_pop, host_pop, μ, σ, load_dir, sim_name)

μ2 = 40
σ2 = 0

sim_name2 = "mice_$(μ2)_$(σ2)_$(loc)_2_$(CDW_stat).csv" # set simname for file access


Model.load_pop(tick_pop2, host_pop2, μ2, σ2, load_dir, sim_name2)


plot(tick_pop.EA[:, 1] + tick_pop.IEA[:, 1])
plot(tick_pop2.EA[:, 1] + tick_pop2.IEA[:, 1])












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
ax[1].plot(tick_pop.Egg[:, 1][end-52*k:end])
ax[1].plot((tick_pop.QL[:, 1])[end-52*k:end])
ax[1].plot((tick_pop.QN[:, 1] + tick_pop.IQN[:, 1])[end-52*k:end])
ax[1].plot((tick_pop.QA[:, 1] + tick_pop.IQA[:, 1])[end-52*k:end])
ax[1].set_xticks([])
ax[1].set_ylim([0, 1.1*max(
    maximum(tick_pop.Egg[:, 1][end-52*k:end]), maximum(tick_pop2.Egg[:, 1][end-52*k:end]), 
    maximum(tick_pop.QL[:, 1][end-52*k:end]), maximum(tick_pop2.QL[:, 1][end-52*k:end]),
    maximum(tick_pop.QN[:, 1][end-52*k:end]), maximum(tick_pop2.QN[:, 1][end-52*k:end]),
    maximum(tick_pop.QA[:, 1][end-52*k:end]), maximum(tick_pop2.QA[:, 1][end-52*k:end]))])
ax[1].set_ylabel("number of ticks")

ax[2].ticklabel_format(useOffset=false, style="scientific", scilimits=(-2,2))
ax[2].plot((tick_pop.OL[:, 1] + tick_pop.OL[:, 2] + tick_pop.OL[:, 3] + tick_pop.IOL[:, 3])[end-52*k:end])
ax[2].plot(2*((tick_pop.ON[:, 1] + tick_pop.ION[:, 1]) + (tick_pop.ON[:, 2] + tick_pop.ION[:, 2]) + (tick_pop.ON[:, 3] + tick_pop.ION[:, 3]))[end-52*k:end])
ax[2].plot(20*(tick_pop.OA[:, 1] + tick_pop.IOA[:, 1] + tick_pop.OA[:, 2] + tick_pop.IOA[:, 2] + tick_pop.OA[:, 3] + tick_pop.IOA[:, 3])[end-52*k:end])
ax[2].set_xticks([])
ax[2].set_ylim([0, 1.1*max(
    maximum(tick_pop.OL[:, 1][end-52*k:end] + tick_pop.IOL[:, 1][end-52*k:end]), maximum(tick_pop2.OL[:, 1][end-52*k:end] + tick_pop2.IOL[:, 1][end-52*k:end]),
    maximum(tick_pop.ON[:, 1][end-52*k:end] + tick_pop.ION[:, 1][end-52*k:end]), maximum(tick_pop2.ON[:, 1][end-52*k:end] + tick_pop2.ION[:, 1][end-52*k:end]),
    maximum(tick_pop.OA[:, 1][end-52*k:end] + tick_pop.IOA[:, 1][end-52*k:end]), maximum(tick_pop2.OA[:, 1][end-52*k:end] + tick_pop2.IOA[:, 1][end-52*k:end]))])
ax[2].set_ylabel("ticks on hosts")

ax[3].ticklabel_format(useOffset=false, style="scientific", scilimits=(-3,3))
ax[3].plot(round.(host_pop.SM[end-52*k:end] + host_pop.ISM[end-52*k:end]))
ax[3].set_ylim([0, 80])    
ax[3].set_ylabel(L"mouse density (ind ha$^{-1}$)")

ax[4].ticklabel_format(useOffset=false, style="scientific", scilimits=(-3,3))
ax[4].plot(tick_pop2.Egg[:, 1][end-52*k:end])
ax[4].plot((tick_pop2.QL[:, 1])[end-52*k:end])
ax[4].plot((tick_pop2.QN[:, 1] + tick_pop2.IQN[:, 1])[end-52*k:end])
ax[4].plot((tick_pop2.QA[:, 1] + tick_pop2.IQA[:, 1])[end-52*k:end])
ax[4].set_xticks([])
ax[4].set_ylim([0, 1.1*max(
    maximum(tick_pop2.Egg[:, 1][end-52*k:end]), maximum(tick_pop.Egg[:, 1][end-52*k:end]), 
    maximum(tick_pop2.QL[:, 1][end-52*k:end]), maximum(tick_pop.QL[:, 1][end-52*k:end]),
    maximum(tick_pop2.QN[:, 1][end-52*k:end]), maximum(tick_pop.QN[:, 1][end-52*k:end]),
    maximum(tick_pop2.QA[:, 1][end-52*k:end]), maximum(tick_pop.QA[:, 1][end-52*k:end]))])
ax[4].set_yticks([])
ax[4].legend(["eggs", "larvae", "nymphs", "adults"], bbox_to_anchor=(0.99, 1), frameon=false)

ax[5].ticklabel_format(useOffset=false, style="scientific", scilimits=(-3,3))
# ax[5].plot(tick_pop2.IOL[:,1][end-52*k:end]./(tick_pop2.OL[:,1][end-52*k:end] .+ tick_pop2.IOL[:,1][end-52*k:end]))
ax[5].plot((tick_pop2.OL[:, 1] + tick_pop2.OL[:, 2] + tick_pop2.OL[:, 3] + tick_pop2.IOL[:, 3])[end-52*k:end])
ax[5].plot(2*((tick_pop2.ON[:, 1] + tick_pop2.ION[:, 1]) + (tick_pop2.ON[:, 2] + tick_pop2.ION[:, 2]) + (tick_pop2.ON[:, 3] + tick_pop2.ION[:, 3]))[end-52*k:end])
ax[5].plot(20*(tick_pop2.OA[:, 1] + tick_pop2.IOA[:, 1] + tick_pop2.OA[:, 2] + tick_pop2.IOA[:, 2] + tick_pop2.OA[:, 3] + tick_pop2.IOA[:, 3])[end-52*k:end])
ax[5].set_xticks([])
ax[5].set_ylim([0, 1.1*max(
    maximum(tick_pop2.OL[:, 1][end-52*k:end] + tick_pop2.IOL[:, 1][end-52*k:end]), maximum(tick_pop.OL[:, 1][end-52*k:end] + tick_pop.IOL[:, 1][end-52*k:end]),
    maximum(tick_pop2.ON[:, 1][end-52*k:end] + tick_pop2.ION[:, 1][end-52*k:end]), maximum(tick_pop.ON[:, 1][end-52*k:end] + tick_pop.ION[:, 1][end-52*k:end]),
    maximum(tick_pop2.OA[:, 1][end-52*k:end] + tick_pop2.IOA[:, 1][end-52*k:end]), maximum(tick_pop.OA[:, 1][end-52*k:end] + tick_pop.IOA[:, 1][end-52*k:end]))])
ax[5].set_yticks([])
ax[5].legend(["larvae", "2x nymphs", "20x adults"], bbox_to_anchor=(0.99, 1), frameon=false)

ax[6].ticklabel_format(useOffset=false, style="scientific", scilimits=(-3,3))
ax[6].plot(host_pop2.SM[end-52*k:end] + host_pop2.ISM[end-52*k:end])
ax[6].set_ylim([0, 80])
ax[6].set_yticks([])

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
fig.savefig("Analysis_Data/Exploratory_Plots/PortlandME_1971-2021/presentation_ts_full.png", bbox_inches="tight")