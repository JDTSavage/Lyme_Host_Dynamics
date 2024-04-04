# to be initialized with plotting.jl

# using CairoMakie
# CairoMakie.activate!(type = "png")
output_dir = "Exploratory_Plots/1"
location = "PortlandME_1971-2021"
input_dir = "Analysis_Data/"

#! questing nymph average
QN_10_avg = reshape_matrix(Matrix(CSV.read("$input_dir/$location/mean_QN.csv", DataFrame, header=false)))
IQN_10_avg = reshape_matrix(Matrix(CSV.read("$input_dir/$location/mean_IQN.csv", DataFrame, header=false)))

#! questing nymph total max/min
TOT_QN_10_max = reshape_matrix(Matrix(CSV.read("$input_dir/$location/tot_QN_max.csv", DataFrame, header=false)))
TOT_QN_10_min = reshape_matrix(Matrix(CSV.read("$input_dir/$location/tot_QN_min.csv", DataFrame, header=false)))

#! Questing nymph min
QN_10_min = reshape_matrix(Matrix(CSV.read("$input_dir/$location/min_QN.csv", DataFrame, header=false)))
IQN_10_min = reshape_matrix(Matrix(CSV.read("$input_dir/$location/min_IQN.csv", DataFrame, header=false)))

#! Questing nymph max
QN_10_max = reshape_matrix(Matrix(CSV.read("$input_dir/$location/max_QN.csv", DataFrame, header=false)))
IQN_10_max = reshape_matrix(Matrix(CSV.read("$input_dir/$location/max_IQN.csv", DataFrame, header=false)))

#! Questing amplitudes (yearly)
QN_10_amp = QN_10_max - QN_10_min
IQN_10_amp = IQN_10_max - IQN_10_min
TOT_10_amp = TOT_QN_10_max - TOT_QN_10_min

#! Total NIP min/max for amps and min/max
NIP_10_mean = IQN_10_avg./(QN_10_avg .+ IQN_10_avg)
TOT_NIP_10_max = reshape_matrix(Matrix(CSV.read("$input_dir/$location/tot_NIP_max.csv", DataFrame, header=false)))
TOT_NIP_10_min = reshape_matrix(Matrix(CSV.read("$input_dir/$location/tot_NIP_min.csv", DataFrame, header=false)))
TOT_NIP_10_amp = TOT_NIP_10_max - TOT_NIP_10_min


# input data mean, min, max, amp NIP, DIN 

NIP_amean = mean(NIP_10_mean, dims=3)[:, :, 1]
NIP_amin = mean(TOT_NIP_10_min, dims=3)[:, :, 1]
NIP_amax = mean(TOT_NIP_10_max, dims=3)[:, :, 1]
NIP_aamp = mean(TOT_NIP_10_amp, dims=3)[:, :, 1]

DIN_amean = mean(IQN_10_avg .+ QN_10_avg, dims=3)[:, :, 1]
DIN_amin = mean(IQN_10_min .+ QN_10_min, dims=3)[:, :, 1]
DIN_amax = mean(IQN_10_max .+ QN_10_max, dims=3)[:, :, 1]
DIN_aamp = mean(IQN_10_amp .+ QN_10_amp, dims=3)[:, :, 1]


function plot_densities(NIP, DIN, bins)
    # no variance
    no_var = NIP[:, 1]
    # all variance to vector
    low_var = reshape(NIP[:, 2:34], length(NIP[:, 2:34]))
    med_var = reshape(NIP[:, 35:67], length(NIP[:, 35:67]))
    high_var = reshape(NIP[:, 68:end], length(NIP[:, 68:end]))
    all_var = reshape(NIP[:, 1:end], length(NIP[:, 1:end]))

    no_var_din = DIN[:, 1]
    # all variance to vector
    low_var_din = reshape(DIN[:, 2:34], length(DIN[:, 2:34]))
    med_var_din = reshape(DIN[:, 35:67], length(DIN[:, 35:67]))
    high_var_din = reshape(DIN[:, 68:end], length(DIN[:, 68:end]))
    all_var_din = reshape(DIN[:, 1:end], length(DIN[:, 1:end]))

    fig, axes = plt.subplots(2, 2, figsize=(10, 6))

    # plot no variance densities on top row
    distplot(no_var, bins=bins, hist=false, ax=axes[1,1])
    distplot(no_var_din, bins=bins, hist=false, ax=axes[1,2])
    distplot(med_var, bins=bins, hist=false, ax=axes[2,1])
    distplot(med_var_din, bins=bins, hist=false, ax=axes[2,2])

    # plot median 
    axes[1,1].axvline(x=Statistics.median(no_var), color="b", linestyle="-.")
    axes[1,2].axvline(x=Statistics.median(no_var_din), color="b", linestyle="-.")
    axes[2,1].axvline(x=Statistics.median(med_var), color="b", linestyle="-.")
    axes[2,2].axvline(x=Statistics.median(med_var_din), color="b", linestyle="-.")

  return fig, axes

end

using Seaborn

# plot densities for NIP, DIN, mean, min, max, amp

#! Change input data, and lims on the x-axis

# mean
fig, axes = plot_densities(NIP_amean, DIN_amean, 30)
axes[1,1].set_xlim(0.2, 0.7)
axes[1,2].set_xlim(0, 15000)
axes[2,1].set_xlabel("Mean NIP")
axes[1,2].set_xticks([0:4000:15000;])
axes[2,1].set_xlim(0.2, 0.7)
axes[2,2].set_xlim(0, 15000)
axes[2,2].set_xlabel("Mean DIN")
axes[2,2].set_xticks([0:4000:15000;])
# turn off all the y labels
for i in 1:2
    for j in 1:2
        axes[i,j].set_yticks([])
        axes[i,j].set_ylabel("")
    end
end

# set xaxis off for top row
axes[1,1].xaxis.set_visible(false)
axes[1,2].xaxis.set_visible(false)
axes[1, 1].set_ylabel("No Dynamics") #("No Variance")
axes[2, 1].set_ylabel("Host Dynamics") #("Medium Variance")

fig.subplots_adjust(wspace=0.05, hspace=0.05)
fig.savefig("Analysis_Data/Exploratory_Plots/PortlandME_1971-2021/mean_NIP_DIN_densities.png")


# min
fig, axes = plot_densities(NIP_amin, DIN_amin, 30)
axes[1,1].set_xlim(0.2, 0.5)
axes[1,2].set_xlim(0, 800)
axes[1,2].set_xticks([0:200:800;])
axes[2,1].set_xlim(0.2, 0.5)
axes[2,2].set_xlim(0, 800)
axes[2,2].set_xticks([0:200:800;])
axes[2,1].set_xlabel("Min NIP")
axes[2,2].set_xlabel("Min DIN")

# turn off all the y labels
for i in 1:2
    for j in 1:2
        axes[i,j].set_yticks([])
        axes[i,j].set_ylabel("")
    end
end

# set xaxis off for top row
axes[1,1].xaxis.set_visible(false)
axes[1,2].xaxis.set_visible(false)
axes[1, 1].set_ylabel("No Variance")
axes[2, 1].set_ylabel("Medium Variance")

fig.subplots_adjust(wspace=0.05, hspace=0.05)
fig.savefig("Analysis_Data/Exploratory_Plots/PortlandME_1971-2021/min_NIP_DIN_densities.png")

# max
fig, axes = plot_densities(NIP_amax, DIN_amax, 30)
axes[1,1].set_xlim(0.2, 0.8)
axes[1,2].set_xlim(0, 55000)
axes[1,2].set_xticks([0:10000:55000;])
axes[2,1].set_xlim(0.2, 0.8)
axes[2,2].set_xlim(0, 55000)
axes[2,2].set_xticks([0:10000:55000;])
axes[2,1].set_xlabel("Max NIP")
axes[2,2].set_xlabel("Max DIN")
# turn off all the y labels
for i in 1:2
    for j in 1:2
        axes[i,j].set_yticks([])
        axes[i,j].set_ylabel("")
    end
end

# set xaxis off for top row
axes[1,1].xaxis.set_visible(false)
axes[1,2].xaxis.set_visible(false)
axes[1, 1].set_ylabel("No Variance")
axes[2, 1].set_ylabel("Medium Variance")

fig.subplots_adjust(wspace=0.05, hspace=0.05)
fig.savefig("Analysis_Data/Exploratory_Plots/PortlandME_1971-2021/max_NIP_DIN_densities.png")

# amp
fig, axes = plot_densities(NIP_aamp, DIN_aamp, 30)
axes[1,1].set_xlim(0, 0.4)
axes[1,2].set_xlim(0, 55000)
axes[1,2].set_xticks([0:10000:55000;])
axes[2,1].set_xlim(0, 0.4)
axes[2,2].set_xlim(0, 55000)
axes[2,1].set_xlabel("Amp NIP")
axes[2,2].set_xlabel("Amp DIN")
axes[2,2].set_xticks([0:10000:55000;])
# turn off all the y labels
for i in 1:2
    for j in 1:2
        axes[i,j].set_yticks([])
        axes[i,j].set_ylabel("")
    end
end

# set xaxis off for top row
axes[1,1].xaxis.set_visible(false)
axes[1,2].xaxis.set_visible(false)
axes[1, 1].set_ylabel("No Dynamics")
axes[2, 1].set_ylabel("Host Dynamics")

fig.subplots_adjust(wspace=0.05, hspace=0.05)
fig.savefig("Analysis_Data/Exploratory_Plots/PortlandME_1971-2021/amp_NIP_DIN_densities.png")



# f, axes = plot_densities(NIP_amin, DIN_amin)
# f
# xlims!(axes[2], [-750, 525])
# f
# save("Analysis_Data/Exploratory_Plots/amin_density_$location.png", f, px_per_unit = 3)

# # max
# f, axes = plot_densities(NIP_amax, DIN_amax)
# f
# xlims!(axes[2], [-70000, 40000])
# f
# save("Analysis_Data/Exploratory_Plots/amax_density_$location.png", f, px_per_unit = 3)

# # amp 
# f, axes = plot_densities(NIP_aamp, DIN_aamp)
# f
# xlims!(axes[2], [-70000, 40000])
# f
# save("Analysis_Data/Exploratory_Plots/aamp_density_$location.png", f, px_per_unit = 3)
