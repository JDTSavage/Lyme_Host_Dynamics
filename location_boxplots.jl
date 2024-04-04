# To be initialized with plotting.jl

#! location by location box plots

location_QN_mean = []
location_IQN_mean = []

location_QN_max = []
location_IQN_max = []

location_QN_min = []
location_IQN_min = []

location_QN_amp = []
location_IQN_amp = []

location_TOT_max = []
location_TOT_min = []
location_TOT_amp = []

location_TOT_NIP_max = []
location_TOT_NIP_min = []
location_TOT_NIP_amp = []


for location in locations_grouped

    # location = locations[1]
    
        # #! Questing larvae average
        # QL_10_avg = reshape_matrix(Matrix(CSV.read("$input_dir/$location/mean_QL.csv", DataFrame, header=false)))
        # QL_10_max = reshape_matrix(Matrix(CSV.read("$input_dir/$location/max_QL.csv", DataFrame, header=false)))
        
        #! questing nymph average
        QN_10_avg = reshape_matrix(Matrix(CSV.read("$input_dir/$location/nlifespan_52_mean_QN.csv", DataFrame, header=false)))
        IQN_10_avg = reshape_matrix(Matrix(CSV.read("$input_dir/$location/nlifespan_52_mean_IQN.csv", DataFrame, header=false)))

        #! questing nymph total max/min
        TOT_QN_10_max = reshape_matrix(Matrix(CSV.read("$input_dir/$location/nlifespan_52_tot_QN_max.csv", DataFrame, header=false)))
        TOT_QN_10_min = reshape_matrix(Matrix(CSV.read("$input_dir/$location/nlifespan_52_tot_QN_min.csv", DataFrame, header=false)))

        #! Questing nymph min
        QN_10_min = reshape_matrix(Matrix(CSV.read("$input_dir/$location/nlifespan_52_min_QN.csv", DataFrame, header=false)))
        IQN_10_min = reshape_matrix(Matrix(CSV.read("$input_dir/$location/nlifespan_52_min_IQN.csv", DataFrame, header=false)))

        #! Questing nymph max
        QN_10_max = reshape_matrix(Matrix(CSV.read("$input_dir/$location/nlifespan_52_max_QN.csv", DataFrame, header=false)))
        IQN_10_max = reshape_matrix(Matrix(CSV.read("$input_dir/$location/nlifespan_52_max_IQN.csv", DataFrame, header=false)))

        #! Questing amplitudes (yearly)
        QN_10_amp = QN_10_max - QN_10_min
        IQN_10_amp = IQN_10_max - IQN_10_min
        TOT_10_amp = TOT_QN_10_max - TOT_QN_10_min

        #! Total NIP min/max for amps and min/max
        NIP_10_mean = IQN_10_avg./(QN_10_avg .+ IQN_10_avg)
        TOT_NIP_10_max = reshape_matrix(Matrix(CSV.read("$input_dir/$location/nlifespan_52_tot_NIP_max.csv", DataFrame, header=false)))
        TOT_NIP_10_min = reshape_matrix(Matrix(CSV.read("$input_dir/$location/nlifespan_52_tot_NIP_min.csv", DataFrame, header=false)))
        TOT_NIP_10_amp = TOT_NIP_10_max - TOT_NIP_10_min

        push!(location_QN_mean, QN_10_avg)
        push!(location_IQN_mean, IQN_10_avg)
        push!(location_QN_max, QN_10_max)
        push!(location_IQN_max, IQN_10_max)
        push!(location_QN_min, QN_10_min)
        push!(location_IQN_min, IQN_10_min)
        push!(location_QN_amp, QN_10_amp)
        push!(location_IQN_amp, IQN_10_amp)
        push!(location_TOT_max, TOT_QN_10_max)
        push!(location_TOT_min, TOT_QN_10_min)
        push!(location_TOT_amp, TOT_10_amp)
        push!(location_TOT_NIP_max, TOT_NIP_10_max)
        push!(location_TOT_NIP_min, TOT_NIP_10_min)
        push!(location_TOT_NIP_amp, TOT_NIP_10_amp)
        print(location, " \n")
end

location_bxplt_labels = []
for location in locations_grouped

    push!(location_bxplt_labels, replace(location, "_1971-2021"=>""))
    # push!(location_bxplt_labels, replace(location, "_1971-2021"=>""))
    print(location, " \n")

end

location_bxplt_labels[9] = "AshevilleNC"

#! Get rid of mean points, add (a) and (b) to subplots

#! DIN
fig, ax = plot_amean_location_boxplot(location_IQN_mean, locations_fact, location_bxplt_labels)
y_ax = [1.5:2:length(location_bxplt_labels)*2;]
ax[1].set_yticks(y_ax)
ax[1].set_yticklabels(location_bxplt_labels)
ax[1].set_xlim((0, 25000))
# set xtick labels so 25000 is not at the end
ax[1].set_xticks([0:5000:24000;])
ax[1].set_ylim(0, (length(y_ax) * 2) + 0.5)
ax[2].set_ylim(0, (length(y_ax) * 2) + 0.5)
ax[1].spines["right"].set_visible(false)
# ax[2].spines["left"].set_visible(false)
ax[2].set_yticks([])
ax[2].set_xlim((0, 25000))
ax[2].set_ylim(0, (length(y_ax) * 2) + 0.5)
ax[1].axhspan(y_ax[end-4]-1, y_ax[end]+1, color = "#56B4E9", alpha=0.25) # northeast 
ax[1].axhspan(y_ax[end-9]-1, y_ax[end-4]-1, color = "#F0E442", alpha=0.25) # lakes 
ax[1].axhspan(y_ax[end-16]-1, y_ax[end-9]-1, color = "#56B4E9", alpha=0.25) # south
ax[1].axhspan(0, y_ax[end-16]-1, color = "#F0E442", alpha=0.25) # Western range
ax[2].axhspan(y_ax[end-4]-1, y_ax[end]+1, color = "#56B4E9", alpha=0.25) # northeast 
ax[2].axhspan(y_ax[end-9]-1, y_ax[end-4]-1, color = "#F0E442", alpha=0.25) # lakes 
ax[2].axhspan(y_ax[end-16]-1, y_ax[end-9]-1, color = "#56B4E9", alpha=0.25) # south
ax[2].axhspan(0, y_ax[end-16]-1, color = "#F0E442", alpha=0.25) # Western range
plt.text(25500, y_ax[3], "West", horizontalalignment="left", verticalalignment="center")
plt.text(25500, y_ax[9], "South", horizontalalignment="left", verticalalignment="center")
plt.text(25500, y_ax[15], "Lakes", horizontalalignment="left", verticalalignment="center")
plt.text(25500, y_ax[end-2], "Northeast", horizontalalignment="left", verticalalignment="center")
custom_lines = [plt.Line2D([0], [0], color="#56B4E9", lw=4),
                plt.Line2D([0], [0], color="#F0E442", lw=4),
                ]
legend(custom_lines, ["No Host Dynamics", "Host Dynamics"], frameon=false, loc = (0.53, 0.945))
fig.text(0.53, 0.01, "mean DIN", ha="center")
fig.tight_layout()
fig.subplots_adjust(wspace=0, bottom=0.05)
savefig("$output_dir/amean_boxplot_DIN.png", dpi=300)
plt.close()

# max DIN
fig, ax = plot_amean_location_boxplot(location_IQN_max, locations_fact, location_bxplt_labels)
y_ax = [1.5:2:length(location_bxplt_labels)*2;]
ax[1].set_yticks(y_ax)
ax[1].set_yticklabels(location_bxplt_labels)
ax[1].set_xlim((0, 45000))
# set xtick labels so 25000 is not at the end
ax[1].set_xticks([0:10000:44000;])
ax[2].set_xticks([0:10000:44000;])
ax[1].set_ylim(0, (length(y_ax) * 2) + 0.5)
ax[2].set_ylim(0, (length(y_ax) * 2) + 0.5)
ax[1].spines["right"].set_visible(false)
# ax[2].spines["left"].set_visible(false)
ax[2].set_yticks([])
ax[2].set_xlim((0, 45000))
ax[2].set_ylim(0, (length(y_ax) * 2) + 0.5)
ax[1].axhspan(y_ax[end-4]-1, y_ax[end]+1, color = "#56B4E9", alpha=0.25) # northeast
ax[1].axhspan(y_ax[end-9]-1, y_ax[end-4]-1, color = "#F0E442", alpha=0.25) # lakes
ax[1].axhspan(y_ax[end-16]-1, y_ax[end-9]-1, color = "#56B4E9", alpha=0.25) # south
ax[1].axhspan(0, y_ax[end-16]-1, color = "#F0E442", alpha=0.25) # Western range
ax[2].axhspan(y_ax[end-4]-1, y_ax[end]+1, color = "#56B4E9", alpha=0.25) # northeast
ax[2].axhspan(y_ax[end-9]-1, y_ax[end-4]-1, color = "#F0E442", alpha=0.25) # lakes
ax[2].axhspan(y_ax[end-16]-1, y_ax[end-9]-1, color = "#56B4E9", alpha=0.25) # south
ax[2].axhspan(0, y_ax[end-16]-1, color = "#F0E442", alpha=0.25) # Western range
plt.text(46000, y_ax[3], "West", horizontalalignment="left", verticalalignment="center")
plt.text(46000, y_ax[9], "South", horizontalalignment="left", verticalalignment="center")
plt.text(46000, y_ax[15], "Lakes", horizontalalignment="left", verticalalignment="center")
plt.text(46000, y_ax[end-2], "Northeast", horizontalalignment="left", verticalalignment="center")
custom_lines = [plt.Line2D([0], [0], color="#56B4E9", lw=4),
                plt.Line2D([0], [0], color="#F0E442", lw=4),
                ]
legend(custom_lines, ["No Host Dynamics", "Host Dynamics"], frameon=false, loc = (0.53, 0.945))
fig.text(0.53, 0.01, "maximum DIN", ha="center")
fig.tight_layout()
fig.subplots_adjust(wspace=0, bottom=0.05)
savefig("$output_dir/max_boxplot_DIN.png", dpi=300)
plt.close()

# Min DIN
fig, ax = plot_amean_location_boxplot(location_IQN_min, locations_fact, location_bxplt_labels)
y_ax = [1.5:2:length(location_bxplt_labels)*2;]
ax[1].set_yticks(y_ax)
ax[1].set_yticklabels(location_bxplt_labels)    
ax[1].set_xlim((0, 14000))
ax[1].set_xticks([0:2000:13000;])
ax[1].set_ylim(0, (length(y_ax) * 2) + 0.5)
ax[2].set_ylim(0, (length(y_ax) * 2) + 0.5)
ax[1].spines["right"].set_visible(false)
ax[2].set_yticks([])
ax[2].set_xlim((0, 14000))
ax[2].set_ylim(0, (length(y_ax) * 2) + 0.5)
ax[1].axhspan(y_ax[end-4]-1, y_ax[end]+1, color = "#56B4E9", alpha=0.25) # northeast
ax[1].axhspan(y_ax[end-9]-1, y_ax[end-4]-1, color = "#F0E442", alpha=0.25) # lakes
ax[1].axhspan(y_ax[end-16]-1, y_ax[end-9]-1, color = "#56B4E9", alpha=0.25) # south
ax[1].axhspan(0, y_ax[end-16]-1, color = "#F0E442", alpha=0.25) # Western range
ax[2].axhspan(y_ax[end-4]-1, y_ax[end]+1, color = "#56B4E9", alpha=0.25) # northeast
ax[2].axhspan(y_ax[end-9]-1, y_ax[end-4]-1, color = "#F0E442", alpha=0.25) # lakes
ax[2].axhspan(y_ax[end-16]-1, y_ax[end-9]-1, color = "#56B4E9", alpha=0.25) # south
ax[2].axhspan(0, y_ax[end-16]-1, color = "#F0E442", alpha=0.25) # Western range
plt.text(14200, y_ax[3], "West", horizontalalignment="left", verticalalignment="center")
plt.text(14200, y_ax[9], "South", horizontalalignment="left", verticalalignment="center")
plt.text(14200, y_ax[15], "Lakes", horizontalalignment="left", verticalalignment="center")
plt.text(14200, y_ax[end-2], "Northeast", horizontalalignment="left", verticalalignment="center")
custom_lines = [plt.Line2D([0], [0], color="#56B4E9", lw=4),
                plt.Line2D([0], [0], color="#F0E442", lw=4),
                ]
legend(custom_lines, ["No Host Dynamics", "Host Dynamics"], frameon=false, loc = (0.53, 0.945))
fig.text(0.53, 0.01, "minimum DIN", ha="center")
fig.tight_layout()
fig.subplots_adjust(wspace=0, bottom=0.05)
savefig("$output_dir/min_boxplot_DIN.png", dpi=300)
plt.close()

# AMP DIN
fig, ax = plot_amean_location_boxplot(location_IQN_amp, locations_fact, location_bxplt_labels)
y_ax = [1.5:2:length(location_bxplt_labels)*2;]
ax[1].set_yticks(y_ax)
ax[1].set_yticklabels(location_bxplt_labels)
ax[1].set_xlim((0, 40000))
ax[1].set_xticks([0:10000:38000;])
ax[2].set_xticks([0:10000:40000;])
ax[1].set_ylim(0, (length(y_ax) * 2) + 0.5)
ax[2].set_ylim(0, (length(y_ax) * 2) + 0.5)
ax[1].spines["right"].set_visible(false)
ax[2].set_yticks([])
ax[2].set_xlim((0, 40000))
ax[2].set_ylim(0, (length(y_ax) * 2) + 0.5)
ax[1].axhspan(y_ax[end-4]-1, y_ax[end]+1, color = "#56B4E9", alpha=0.25) # northeast
ax[1].axhspan(y_ax[end-9]-1, y_ax[end-4]-1, color = "#F0E442", alpha=0.25) # lakes
ax[1].axhspan(y_ax[end-16]-1, y_ax[end-9]-1, color = "#56B4E9", alpha=0.25) # south
ax[1].axhspan(0, y_ax[end-16]-1, color = "#F0E442", alpha=0.25) # Western range
ax[2].axhspan(y_ax[end-4]-1, y_ax[end]+1, color = "#56B4E9", alpha=0.25) # northeast
ax[2].axhspan(y_ax[end-9]-1, y_ax[end-4]-1, color = "#F0E442", alpha=0.25) # lakes
ax[2].axhspan(y_ax[end-16]-1, y_ax[end-9]-1, color = "#56B4E9", alpha=0.25) # south
ax[2].axhspan(0, y_ax[end-16]-1, color = "#F0E442", alpha=0.25) # Western range
plt.text(40850, y_ax[3], "West", horizontalalignment="left", verticalalignment="center")
plt.text(40850, y_ax[9], "South", horizontalalignment="left", verticalalignment="center")
plt.text(40850, y_ax[15], "Lakes", horizontalalignment="left", verticalalignment="center")
plt.text(40850, y_ax[end-2], "Northeast", horizontalalignment="left", verticalalignment="center")
custom_lines = [plt.Line2D([0], [0], color="#56B4E9", lw=4),
                plt.Line2D([0], [0], color="#F0E442", lw=4),
                ]
legend(custom_lines, ["No Host Dynamics", "Host Dynamics"], frameon=false, loc = (0.53, 0.945))
fig.text(0.53, 0.01, "amplitude DIN", ha="center")
fig.tight_layout()
fig.subplots_adjust(wspace=0, bottom=0.05)
savefig("$output_dir/amp_boxplot_DIN.png", dpi=300)
plt.close()


#! DON
# mean
fig, ax = plot_amean_location_boxplot(location_QN_mean .+ location_IQN_mean, locations_fact, location_bxplt_labels)
y_ax = [1.5:2:length(location_bxplt_labels)*2;]
ax[1].set_yticks(y_ax)
ax[1].set_yticklabels(location_bxplt_labels)
ax[1].set_xlim((0, 35000))
ax[1].set_xticks([0:5000:30000;])
ax[2].set_xticks([0:5000:35000;])
ax[1].set_ylim(0, (length(y_ax) * 2) + 0.5)
ax[2].set_ylim(0, (length(y_ax) * 2) + 0.5)
ax[1].spines["right"].set_visible(false)
ax[2].set_yticks([])
ax[2].set_xlim((0, 35000))
ax[2].set_ylim(0, (length(y_ax) * 2) + 0.5)
ax[1].axhspan(y_ax[end-4]-1, y_ax[end]+1, color = "#56B4E9", alpha=0.25) # northeast
ax[1].axhspan(y_ax[end-9]-1, y_ax[end-4]-1, color = "#F0E442", alpha=0.25) # lakes
ax[1].axhspan(y_ax[end-16]-1, y_ax[end-9]-1, color = "#56B4E9", alpha=0.25) # south
ax[1].axhspan(0, y_ax[end-16]-1, color = "#F0E442", alpha=0.25) # Western range
ax[2].axhspan(y_ax[end-4]-1, y_ax[end]+1, color = "#56B4E9", alpha=0.25) # northeast
ax[2].axhspan(y_ax[end-9]-1, y_ax[end-4]-1, color = "#F0E442", alpha=0.25) # lakes
ax[2].axhspan(y_ax[end-16]-1, y_ax[end-9]-1, color = "#56B4E9", alpha=0.25) # south
ax[2].axhspan(0, y_ax[end-16]-1, color = "#F0E442", alpha=0.25) # Western range
plt.text(35800, y_ax[3], "West", horizontalalignment="left", verticalalignment="center")
plt.text(35800, y_ax[9], "South", horizontalalignment="left", verticalalignment="center")
plt.text(35800, y_ax[15], "Lakes", horizontalalignment="left", verticalalignment="center")
plt.text(35800, y_ax[end-2], "Northeast", horizontalalignment="left", verticalalignment="center")
custom_lines = [plt.Line2D([0], [0], color="#56B4E9", lw=4),
                plt.Line2D([0], [0], color="#F0E442", lw=4),
                ]
legend(custom_lines, ["No Host Dynamics", "Host Dynamics"], frameon=false, loc = (0.53, 0.945))
fig.text(0.53, 0.01, "mean DON", ha="center")
fig.tight_layout()
fig.subplots_adjust(wspace=0, bottom=0.05)
savefig("$output_dir/amean_boxplot_DON.png", dpi=300)
plt.close()

# max DON
fig, ax = plot_amean_location_boxplot(location_TOT_max, locations_fact, location_bxplt_labels)
y_ax = [1.5:2:length(location_bxplt_labels)*2;]
ax[1].set_yticks(y_ax)
ax[1].set_yticklabels(location_bxplt_labels)
ax[1].set_xlim((0, 65000))
ax[1].set_xticks([0:10000:65000;])
ax[2].set_xticks([0:10000:65000;])
ax[1].set_ylim(0, (length(y_ax) * 2) + 0.5)
ax[2].set_ylim(0, (length(y_ax) * 2) + 0.5)
ax[1].spines["right"].set_visible(false)
ax[2].set_yticks([])
ax[2].set_xlim((0, 65000))
ax[2].set_ylim(0, (length(y_ax) * 2) + 0.5)
ax[1].axhspan(y_ax[end-4]-1, y_ax[end]+1, color = "#56B4E9", alpha=0.25) # northeast
ax[1].axhspan(y_ax[end-9]-1, y_ax[end-4]-1, color = "#F0E442", alpha=0.25) # lakes
ax[1].axhspan(y_ax[end-16]-1, y_ax[end-9]-1, color = "#56B4E9", alpha=0.25) # south
ax[1].axhspan(0, y_ax[end-16]-1, color = "#F0E442", alpha=0.25) # Western range
ax[2].axhspan(y_ax[end-4]-1, y_ax[end]+1, color = "#56B4E9", alpha=0.25) # northeast
ax[2].axhspan(y_ax[end-9]-1, y_ax[end-4]-1, color = "#F0E442", alpha=0.25) # lakes
ax[2].axhspan(y_ax[end-16]-1, y_ax[end-9]-1, color = "#56B4E9", alpha=0.25) # south
ax[2].axhspan(0, y_ax[end-16]-1, color = "#F0E442", alpha=0.25) # Western range
plt.text(66300, y_ax[3], "West", horizontalalignment="left", verticalalignment="center")
plt.text(66300, y_ax[9], "South", horizontalalignment="left", verticalalignment="center")
plt.text(66300, y_ax[15], "Lakes", horizontalalignment="left", verticalalignment="center")
plt.text(66300, y_ax[end-2], "Northeast", horizontalalignment="left", verticalalignment="center")
custom_lines = [plt.Line2D([0], [0], color="#56B4E9", lw=4),
                plt.Line2D([0], [0], color="#F0E442", lw=4),
                ]
legend(custom_lines, ["No Host Dynamics", "Host Dynamics"], frameon=false, loc = (0.53, 0.945))
fig.text(0.53, 0.01, "maximum DON", ha="center")
fig.tight_layout()
fig.subplots_adjust(wspace=0, bottom=0.05)
savefig("$output_dir/max_boxplot_DON.png", dpi=300)
plt.close()

# min DON
fig, ax = plot_amean_location_boxplot(location_TOT_min, locations_fact, location_bxplt_labels)
y_ax = [1.5:2:length(location_bxplt_labels)*2;]
ax[1].set_yticks(y_ax)
ax[1].set_yticklabels(location_bxplt_labels)
ax[1].set_xlim((0, 18000))
ax[1].set_xticks([0:4000:17000;])
ax[2].set_xticks([0:4000:18000;])
ax[1].set_ylim(0, (length(y_ax) * 2) + 0.5)
ax[2].set_ylim(0, (length(y_ax) * 2) + 0.5)
ax[1].spines["right"].set_visible(false)
ax[2].set_yticks([])
ax[2].set_xlim((0, 18000))
ax[2].set_ylim(0, (length(y_ax) * 2) + 0.5)
ax[1].axhspan(y_ax[end-4]-1, y_ax[end]+1, color = "#56B4E9", alpha=0.25) # northeast
ax[1].axhspan(y_ax[end-9]-1, y_ax[end-4]-1, color = "#F0E442", alpha=0.25) # lakes
ax[1].axhspan(y_ax[end-16]-1, y_ax[end-9]-1, color = "#56B4E9", alpha=0.25) # south
ax[1].axhspan(0, y_ax[end-16]-1, color = "#F0E442", alpha=0.25) # Western range
ax[2].axhspan(y_ax[end-4]-1, y_ax[end]+1, color = "#56B4E9", alpha=0.25) # northeast
ax[2].axhspan(y_ax[end-9]-1, y_ax[end-4]-1, color = "#F0E442", alpha=0.25) # lakes
ax[2].axhspan(y_ax[end-16]-1, y_ax[end-9]-1, color = "#56B4E9", alpha=0.25) # south
ax[2].axhspan(0, y_ax[end-16]-1, color = "#F0E442", alpha=0.25) # Western range
plt.text(18400, y_ax[3], "West", horizontalalignment="left", verticalalignment="center")
plt.text(18400, y_ax[9], "South", horizontalalignment="left", verticalalignment="center")
plt.text(18400, y_ax[15], "Lakes", horizontalalignment="left", verticalalignment="center")
plt.text(18400, y_ax[end-2], "Northeast", horizontalalignment="left", verticalalignment="center")
custom_lines = [plt.Line2D([0], [0], color="#56B4E9", lw=4),
                plt.Line2D([0], [0], color="#F0E442", lw=4),
                ]
legend(custom_lines, ["No Host Dynamics", "Host Dynamics"], frameon=false, loc = (0.53, 0.945))
fig.text(0.53, 0.01, "minimum DON", ha="center")
fig.tight_layout()
fig.subplots_adjust(wspace=0, bottom=0.05)
savefig("$output_dir/min_boxplot_DON.png", dpi=300)
plt.close()

# amp DON
fig, ax = plot_amean_location_boxplot(location_TOT_amp, locations_fact, location_bxplt_labels)
y_ax = [1.5:2:length(location_bxplt_labels)*2;]
ax[1].set_yticks(y_ax)
ax[1].set_yticklabels(location_bxplt_labels)
ax[1].set_xlim((0, 65000))
ax[1].set_xticks([0:10000:65000;])
ax[2].set_xticks([0:10000:65000;])
ax[1].set_ylim(0, (length(y_ax) * 2) + 0.5)
ax[2].set_ylim(0, (length(y_ax) * 2) + 0.5)
ax[1].spines["right"].set_visible(false)
ax[2].set_yticks([])
ax[2].set_xlim((0, 65000))
ax[2].set_ylim(0, (length(y_ax) * 2) + 0.5)
ax[1].axhspan(y_ax[end-4]-1, y_ax[end]+1, color = "#56B4E9", alpha=0.25) # northeast
ax[1].axhspan(y_ax[end-9]-1, y_ax[end-4]-1, color = "#F0E442", alpha=0.25) # lakes
ax[1].axhspan(y_ax[end-16]-1, y_ax[end-9]-1, color = "#56B4E9", alpha=0.25) # south
ax[1].axhspan(0, y_ax[end-16]-1, color = "#F0E442", alpha=0.25) # Western range
ax[2].axhspan(y_ax[end-4]-1, y_ax[end]+1, color = "#56B4E9", alpha=0.25) # northeast
ax[2].axhspan(y_ax[end-9]-1, y_ax[end-4]-1, color = "#F0E442", alpha=0.25) # lakes
ax[2].axhspan(y_ax[end-16]-1, y_ax[end-9]-1, color = "#56B4E9", alpha=0.25) # south
ax[2].axhspan(0, y_ax[end-16]-1, color = "#F0E442", alpha=0.25) # Western range
plt.text(66350, y_ax[3], "West", horizontalalignment="left", verticalalignment="center")
plt.text(66350, y_ax[9], "South", horizontalalignment="left", verticalalignment="center")
plt.text(66350, y_ax[15], "Lakes", horizontalalignment="left", verticalalignment="center")
plt.text(66350, y_ax[end-2], "Northeast", horizontalalignment="left", verticalalignment="center")
custom_lines = [plt.Line2D([0], [0], color="#56B4E9", lw=4),
                plt.Line2D([0], [0], color="#F0E442", lw=4),
                ]
legend(custom_lines, ["No Host Dynamics", "Host Dynamics"], frameon=false, loc = (0.53, 0.945))
fig.text(0.53, 0.01, "amplitude DON", ha="center")
fig.tight_layout()
fig.subplots_adjust(wspace=0, bottom=0.05)
savefig("$output_dir/amp_boxplot_DON.png", dpi=300)
plt.close()

#!NIP
location_NIP = []
for i in 1:length(location_IQN_mean)
    push!(location_NIP, location_IQN_mean[i]./(location_QN_mean[i] .+ location_IQN_mean[i]))
end

# mean NIP
fig, ax = plot_amean_location_boxplot(location_NIP, locations_fact, location_bxplt_labels)
y_ax = [1.5:2:length(location_bxplt_labels)*2;]
ax[1].set_yticks(y_ax)
ax[1].set_yticklabels(location_bxplt_labels)
ax[1].set_xlim((0, 1))
ax[1].set_xticks([0:0.2:0.9;])
ax[2].set_xticks([0:0.2:1;])
ax[1].set_ylim(0, (length(y_ax) * 2) + 0.5)
ax[2].set_ylim(0, (length(y_ax) * 2) + 0.5)
ax[1].spines["right"].set_visible(false)
ax[2].set_yticks([])
ax[2].set_xlim((0, 1))
ax[2].set_ylim(0, (length(y_ax) * 2) + 0.5)
ax[1].axhspan(y_ax[end-4]-1, y_ax[end]+1, color = "#56B4E9", alpha=0.25) # northeast
ax[1].axhspan(y_ax[end-9]-1, y_ax[end-4]-1, color = "#F0E442", alpha=0.25) # lakes
ax[1].axhspan(y_ax[end-16]-1, y_ax[end-9]-1, color = "#56B4E9", alpha=0.25) # south
ax[1].axhspan(0, y_ax[end-16]-1, color = "#F0E442", alpha=0.25) # Western range
ax[2].axhspan(y_ax[end-4]-1, y_ax[end]+1, color = "#56B4E9", alpha=0.25) # northeast
ax[2].axhspan(y_ax[end-9]-1, y_ax[end-4]-1, color = "#F0E442", alpha=0.25) # lakes
ax[2].axhspan(y_ax[end-16]-1, y_ax[end-9]-1, color = "#56B4E9", alpha=0.25) # south
ax[2].axhspan(0, y_ax[end-16]-1, color = "#F0E442", alpha=0.25) # Western range
plt.text(1.018, y_ax[3], "West", horizontalalignment="left", verticalalignment="center")
plt.text(1.018, y_ax[9], "South", horizontalalignment="left", verticalalignment="center")
plt.text(1.018, y_ax[15], "Lakes", horizontalalignment="left", verticalalignment="center")
plt.text(1.018, y_ax[end-2], "Northeast", horizontalalignment="left", verticalalignment="center")
custom_lines = [plt.Line2D([0], [0], color="#56B4E9", lw=4),
                plt.Line2D([0], [0], color="#F0E442", lw=4),
                ]
legend(custom_lines, ["No Host Dynamics", "Host Dynamics"], frameon=false, loc = (0.54, 0.945))
fig.text(0.53, 0.01, "mean NIP", ha="center")
fig.tight_layout()
fig.subplots_adjust(wspace=0, bottom=0.05)
savefig("$output_dir/amean_boxplot_NIP.png", dpi=300)
plt.close()

# max NIP
fig, ax = plot_amean_location_boxplot(location_TOT_NIP_max, locations_fact, location_bxplt_labels)
y_ax = [1.5:2:length(location_bxplt_labels)*2;]
ax[1].set_yticks(y_ax)
ax[1].set_yticklabels(location_bxplt_labels)
ax[1].set_xlim((0, 1))
ax[1].set_xticks([0:0.2:0.9;])
ax[2].set_xticks([0:0.2:1;])
ax[1].set_ylim(0, (length(y_ax) * 2) + 0.5)
ax[2].set_ylim(0, (length(y_ax) * 2) + 0.5)
ax[1].spines["right"].set_visible(false)
ax[2].set_yticks([])
ax[2].set_xlim((0, 1))
ax[2].set_ylim(0, (length(y_ax) * 2) + 0.5)
ax[1].axhspan(y_ax[end-4]-1, y_ax[end]+1, color = "#56B4E9", alpha=0.25) # northeast
ax[1].axhspan(y_ax[end-9]-1, y_ax[end-4]-1, color = "#F0E442", alpha=0.25) # lakes
ax[1].axhspan(y_ax[end-16]-1, y_ax[end-9]-1, color = "#56B4E9", alpha=0.25) # south
ax[1].axhspan(0, y_ax[end-16]-1, color = "#F0E442", alpha=0.25) # Western range
ax[2].axhspan(y_ax[end-4]-1, y_ax[end]+1, color = "#56B4E9", alpha=0.25) # northeast
ax[2].axhspan(y_ax[end-9]-1, y_ax[end-4]-1, color = "#F0E442", alpha=0.25) # lakes
ax[2].axhspan(y_ax[end-16]-1, y_ax[end-9]-1, color = "#56B4E9", alpha=0.25) # south
ax[2].axhspan(0, y_ax[end-16]-1, color = "#F0E442", alpha=0.25) # Western range
plt.text(1.018, y_ax[3], "West", horizontalalignment="left", verticalalignment="center")
plt.text(1.018, y_ax[9], "South", horizontalalignment="left", verticalalignment="center")
plt.text(1.018, y_ax[15], "Lakes", horizontalalignment="left", verticalalignment="center")
plt.text(1.018, y_ax[end-2], "Northeast", horizontalalignment="left", verticalalignment="center")
custom_lines = [plt.Line2D([0], [0], color="#56B4E9", lw=4),
                plt.Line2D([0], [0], color="#F0E442", lw=4),
                ]
legend(custom_lines, ["No Host Dynamics", "Host Dynamics"], frameon=false, loc = (0, 0.945))
fig.text(0.53, 0.01, "maximum NIP", ha="center")
fig.tight_layout()
fig.subplots_adjust(wspace=0, bottom=0.05)
savefig("$output_dir/amax_boxplot_NIP.png", dpi=300)
plt.close()


# min NIP
fig, ax = plot_amean_location_boxplot(location_TOT_NIP_min, locations_fact, location_bxplt_labels)
y_ax = [1.5:2:length(location_bxplt_labels)*2;]
ax[1].set_yticks(y_ax)
ax[1].set_yticklabels(location_bxplt_labels)
ax[1].set_xlim((0, 1))
ax[1].set_xticks([0:0.2:0.9;])
ax[2].set_xticks([0:0.2:1;])
ax[1].set_ylim(0, (length(y_ax) * 2) + 0.5)
ax[2].set_ylim(0, (length(y_ax) * 2) + 0.5)
ax[1].spines["right"].set_visible(false)
ax[2].set_yticks([])
ax[2].set_xlim((0, 1))
ax[2].set_ylim(0, (length(y_ax) * 2) + 0.5)
ax[1].axhspan(y_ax[end-4]-1, y_ax[end]+1, color = "#56B4E9", alpha=0.25) # northeast
ax[1].axhspan(y_ax[end-9]-1, y_ax[end-4]-1, color = "#F0E442", alpha=0.25) # lakes
ax[1].axhspan(y_ax[end-16]-1, y_ax[end-9]-1, color = "#56B4E9", alpha=0.25) # south
ax[1].axhspan(0, y_ax[end-16]-1, color = "#F0E442", alpha=0.25) # Western range
ax[2].axhspan(y_ax[end-4]-1, y_ax[end]+1, color = "#56B4E9", alpha=0.25) # northeast
ax[2].axhspan(y_ax[end-9]-1, y_ax[end-4]-1, color = "#F0E442", alpha=0.25) # lakes
ax[2].axhspan(y_ax[end-16]-1, y_ax[end-9]-1, color = "#56B4E9", alpha=0.25) # south
ax[2].axhspan(0, y_ax[end-16]-1, color = "#F0E442", alpha=0.25) # Western range
plt.text(1.018, y_ax[3], "West", horizontalalignment="left", verticalalignment="center")
plt.text(1.018, y_ax[9], "South", horizontalalignment="left", verticalalignment="center")
plt.text(1.018, y_ax[15], "Lakes", horizontalalignment="left", verticalalignment="center")
plt.text(1.018, y_ax[end-2], "Northeast", horizontalalignment="left", verticalalignment="center")
custom_lines = [plt.Line2D([0], [0], color="#56B4E9", lw=4),
                plt.Line2D([0], [0], color="#F0E442", lw=4),
                ]
legend(custom_lines, ["No Host Dynamics", "Host Dynamics"], frameon=false, loc = (0.53, 0.945))
fig.text(0.53, 0.01, "minimum NIP", ha="center")
fig.tight_layout()
fig.subplots_adjust(wspace=0, bottom=0.05)
savefig("$output_dir/amin_boxplot_NIP.png", dpi=300)
plt.close()


# amp NIP
fig, ax = plot_amean_location_boxplot(location_TOT_NIP_amp, locations_fact, location_bxplt_labels)
y_ax = [1.5:2:length(location_bxplt_labels)*2;]
ax[1].set_yticks(y_ax)
ax[1].set_yticklabels(location_bxplt_labels)
ax[1].set_xlim((0, 1))
ax[1].set_xticks([0:0.2:0.9;])
ax[2].set_xticks([0:0.2:1;])
ax[1].set_ylim(0, (length(y_ax) * 2) + 0.5)
ax[2].set_ylim(0, (length(y_ax) * 2) + 0.5)
ax[1].spines["right"].set_visible(false)
ax[2].set_yticks([])
ax[2].set_xlim((0, 1))
ax[2].set_ylim(0, (length(y_ax) * 2) + 0.5)
ax[1].axhspan(y_ax[end-4]-1, y_ax[end]+1, color = "#56B4E9", alpha=0.25) # northeast
ax[1].axhspan(y_ax[end-9]-1, y_ax[end-4]-1, color = "#F0E442", alpha=0.25) # lakes
ax[1].axhspan(y_ax[end-16]-1, y_ax[end-9]-1, color = "#56B4E9", alpha=0.25) # south
ax[1].axhspan(0, y_ax[end-16]-1, color = "#F0E442", alpha=0.25) # Western range
ax[2].axhspan(y_ax[end-4]-1, y_ax[end]+1, color = "#56B4E9", alpha=0.25) # northeast
ax[2].axhspan(y_ax[end-9]-1, y_ax[end-4]-1, color = "#F0E442", alpha=0.25) # lakes
ax[2].axhspan(y_ax[end-16]-1, y_ax[end-9]-1, color = "#56B4E9", alpha=0.25) # south
ax[2].axhspan(0, y_ax[end-16]-1, color = "#F0E442", alpha=0.25) # Western range
plt.text(1.018, y_ax[3], "West", horizontalalignment="left", verticalalignment="center")
plt.text(1.018, y_ax[9], "South", horizontalalignment="left", verticalalignment="center")
plt.text(1.018, y_ax[15], "Lakes", horizontalalignment="left", verticalalignment="center")
plt.text(1.018, y_ax[end-2], "Northeast", horizontalalignment="left", verticalalignment="center")
custom_lines = [plt.Line2D([0], [0], color="#56B4E9", lw=4),
                plt.Line2D([0], [0], color="#F0E442", lw=4),
                ]
legend(custom_lines, ["No Host Dynamics", "Host Dynamics"], frameon=false, loc = (0.53, 0.945))
fig.text(0.53, 0.01, "amplitude NIP", ha="center")
fig.tight_layout()
fig.subplots_adjust(wspace=0, bottom=0.05)
savefig("$output_dir/amp_boxplot_NIP.png", dpi=300)
plt.close()
