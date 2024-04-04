# initialized by plotting.jl

fig, axes = subplots(4, 6, figsize=(10, 7))

for i in 1:4
    for j in 1:6

        subplt = j + (i - 1) * 6
        # subplots below 22 except 18
        if subplt <= 23

            if subplt <= 22
                location_i = locations_lat_long[subplt]
            
                #! questing nymph average
                QN_10_avg = reshape_matrix(Matrix(CSV.read("$input_dir/$location_i/mean_QN.csv", DataFrame, header=false)))
                IQN_10_avg = reshape_matrix(Matrix(CSV.read("$input_dir/$location_i/mean_IQN.csv", DataFrame, header=false)))

                #! questing nymph total max/min
                TOT_QN_10_max = reshape_matrix(Matrix(CSV.read("$input_dir/$location_i/tot_QN_max.csv", DataFrame, header=false)))
                TOT_QN_10_min = reshape_matrix(Matrix(CSV.read("$input_dir/$location_i/tot_QN_min.csv", DataFrame, header=false)))

                #! Questing nymph min
                QN_10_min = reshape_matrix(Matrix(CSV.read("$input_dir/$location_i/min_QN.csv", DataFrame, header=false)))
                IQN_10_min = reshape_matrix(Matrix(CSV.read("$input_dir/$location_i/min_IQN.csv", DataFrame, header=false)))

                #! Questing nymph max
                QN_10_max = reshape_matrix(Matrix(CSV.read("$input_dir/$location_i/max_QN.csv", DataFrame, header=false)))
                IQN_10_max = reshape_matrix(Matrix(CSV.read("$input_dir/$location_i/max_IQN.csv", DataFrame, header=false)))

                #! Questing amplitudes (yearly)
                QN_10_amp = QN_10_max - QN_10_min
                IQN_10_amp = IQN_10_max - IQN_10_min
                TOT_10_amp = TOT_QN_10_max - TOT_QN_10_min

                #! Total NIP min/max for amps and min/max
                NIP_10_mean = IQN_10_avg./(QN_10_avg .+ IQN_10_avg)
                
                #! Total NIP min/max for amps and min/max
                TOT_NIP_10_max = reshape_matrix(Matrix(CSV.read("$input_dir/$location_i/tot_NIP_max.csv", DataFrame, header=false)))
                TOT_NIP_10_min = reshape_matrix(Matrix(CSV.read("$input_dir/$location_i/tot_NIP_min.csv", DataFrame, header=false)))
                TOT_NIP_10_amp = TOT_NIP_10_max - TOT_NIP_10_min
                 
                # mean for max, min, amp, and mean NIP
                NIP_10_aamp = mean(TOT_NIP_10_amp, dims=3)[:, :]
                NIP_10_mean = mean(NIP_10_mean, dims=3)[:, :]
                NIP_10_max = mean(TOT_NIP_10_max, dims=3)[:, :]
                NIP_10_min = mean(TOT_NIP_10_min, dims=3)[:, :]

                # DIN 
                DIN_mean = mean(IQN_10_avg, dims=3)[:, :]
                DIN_max = mean(IQN_10_max, dims=3)[:, :]
                DIN_min = mean(IQN_10_min, dims=3)[:, :]
                DIN_amp = DIN_max - DIN_min

                # 
            end

            if subplt <= 18
                axes[i, j].imshow(DIN_amp, cmap="cividis", interpolation="nearest", origin="lower")
                axes[i, j].set_title("$(replace(replace(location_i, "_1971-2021" => ""), "FortWorth" => "FW "))")
            elseif subplt <= 22
                axes[i, j+1].imshow(DIN_amp, cmap="cividis", interpolation="nearest", origin="lower")
                axes[i, j+1].set_title("$(replace(replace(location_i, "_1971-2021" => ""), "FortWorth" => "FW "))")
            end

            # set x and y tick labels for plots on the left and bottom only
            if subplt in [1, 7]
                axes[i, j].set_yticks([0:25:75;])
                axes[i, j].set_yticklabels(["0", "25", "50", "75"])
                axes[i, j].set_xticks([])
            elseif subplt in [18]
                axes[i, j].set_xticks([0:25:75;])
                axes[i, j].set_xticklabels(["0", "25", "50", "75"])
                axes[i, j].set_yticks([])
            elseif subplt in [13]
                axes[i, j].set_xticks([0:25:75;])
                axes[i, j].set_yticks([0:25:75;])
                axes[i, j].set_xticklabels(["0", "25", "50", "75"])
                axes[i, j].set_yticklabels(["0", "25", "50", "75"])
            elseif subplt in [19]
                axes[i, j+1].set_xticks([0:25:75;])
                axes[i, j+1].set_yticks([0:25:75;])
                axes[i, j+1].set_xticklabels(["0", "25", "50", "75"])
                axes[i, j+1].set_yticklabels(["0", "25", "50", "75"])
                axes[i, j].set_axis_off()
            elseif subplt in [20, 21, 22, 23]
                axes[i, j+1].set_xticks([0:25:75;])
                axes[i, j+1].set_xticklabels(["0", "25", "50", "75"])
                axes[i, j+1].set_yticks([])
            else
                axes[i, j].set_xticks([])
                axes[i, j].set_yticks([])
            end
            # savefig("$output_dir/$(location)/ampheatmap_NIP.png")
            # tight_layout()
            # plt.close()
        else 
            axes[i, j].set_axis_off()
        end
        
    end
end

fig.add_subplot(111, frameon=false)
tick_params(labelcolor="none", which="both", top=false, bottom=false, left=false, right=false)
xlabel("σ Mouse")
ylabel("μ Mouse")
mappable = axes[1].get_children()[end-1]
subplots_adjust(hspace=0.2, wspace=0.2)
# tight_layout()
colorbar(mappable, label="Amp DIN", ax=axes, pad=0.025, fraction=0.1)
savefig("$output_dir/aamp_heatmaps_location_DIN.png")
plt.close()


# fig, ax = subplots(10, 10, figsize=(10, 7))

# for axis in ax
#     axis.set_xticks([])
#     axis.set_yticks([])
# end

# fig.subplots_adjust(hspace=0, wspace=0)



# locations_lat_long = [
#     "BismarkND_1971-2021", "AlbanyNY_1971-2021", "BurlingtonVT_1971-2021", "ConcordNH_1971-2021", "PortlandME_1971-2021", 
#     "BostonMA_1971-2021", 
#     "MinneapolisMN_1971-2021", "DetroitMI_1971-2021", "ColumbusOH_1971-2021", "ClevelandOH_1971-2021", "PittsburghPA_1971-2021",
#     "RochesterNY_1971-2021", 
#     "DenverCO_1971-2021", "TopekaKS_1971-2021", "WashingtonDC_1971-2021", "NorfolkVA_1971-2021", "AshevilleTN_1971-2021", "RaleighNC_1971-2021",
#     "DallasFortWorthTX_1971-2021", "JacksonMS_1971-2021", "StLouisMO_1971-2021", "AugustaGA_1971-2021", 
# ]


# # create 8 x 9 grid of subplots
# fig, axes = subplots(8, 9, figsize=(10, 7))

# # for each location at a time, place a subplot in the grid
# # loction 1 from locations_lat_long
# location_i = locations_lat_long[1]

# title = "BismarkND"

# # place at subplot 3, 2
# i = 3
# j = 2

# # create a subplot at the specified location
# TOT_NIP_10_max = reshape_matrix(Matrix(CSV.read("$input_dir/$location_i/tot_NIP_max.csv", DataFrame, header=false)))
# TOT_NIP_10_min = reshape_matrix(Matrix(CSV.read("$input_dir/$location_i/tot_NIP_min.csv", DataFrame, header=false)))
# TOT_NIP_10_amp = TOT_NIP_10_max - TOT_NIP_10_min

# IQN_10_aamp = mean(TOT_NIP_10_amp, dims=3)[:, :]
# axes[i, j].imshow(IQN_10_aamp, cmap="cividis", interpolation="nearest", origin="lower")
# axes[i, j].set_title("BismarkND")

# # for next location
# location_i = locations_lat_long[2]

# # place at subplot 3, 7
# i = 3
# j = 7

# # create a subplot at the specified location
# TOT_NIP_10_max = reshape_matrix(Matrix(CSV.read("$input_dir/$location_i/tot_NIP_max.csv", DataFrame, header=false)))
# TOT_NIP_10_min = reshape_matrix(Matrix(CSV.read("$input_dir/$location_i/tot_NIP_min.csv", DataFrame, header=false)))
# TOT_NIP_10_amp = TOT_NIP_10_max - TOT_NIP_10_min

# IQN_10_aamp = mean(TOT_NIP_10_amp, dims=3)[:, :]
# axes[i, j].imshow(IQN_10_aamp, cmap="cividis", interpolation="nearest", origin="lower")
# axes[i, j].set_title("AlbanyNY")

# # for next location
# location_i = locations_lat_long[3]

# title = "BurlingtonVT"

# # place at subplot 2, 8
# i = 2
# j = 8


# # create a subplot at the specified location
# TOT_NIP_10_max = reshape_matrix(Matrix(CSV.read("$input_dir/$location_i/tot_NIP_max.csv", DataFrame, header=false)))
# TOT_NIP_10_min = reshape_matrix(Matrix(CSV.read("$input_dir/$location_i/tot_NIP_min.csv", DataFrame, header=false)))
# TOT_NIP_10_amp = TOT_NIP_10_max - TOT_NIP_10_min


# IQN_10_aamp = mean(TOT_NIP_10_amp, dims=3)[:, :]
# axes[i, j].imshow(IQN_10_aamp, cmap="cividis", interpolation="nearest", origin="lower")
# axes[i, j].set_title("BurlingtonVT")


# # for next location
# location_i = locations_lat_long[4]

# title = "ConcordNH"


# # place at subplot 2, 9
# i = 2
# j = 9


# # create a subplot at the specified location
# TOT_NIP_10_max = reshape_matrix(Matrix(CSV.read("$input_dir/$location_i/tot_NIP_max.csv", DataFrame, header=false)))
# TOT_NIP_10_min = reshape_matrix(Matrix(CSV.read("$input_dir/$location_i/tot_NIP_min.csv", DataFrame, header=false)))
# TOT_NIP_10_amp = TOT_NIP_10_max - TOT_NIP_10_min


# IQN_10_aamp = mean(TOT_NIP_10_amp, dims=3)[:, :]
# axes[i, j].imshow(IQN_10_aamp, cmap="cividis", interpolation="nearest", origin="lower")
# axes[i, j].set_title("ConcordNH")


# # for next location
# location_i = locations_lat_long[5]

# title = "PortlandME"


# # place at subplot 1, 9
# i = 1
# j = 9

# # create a subplot at the specified location
# TOT_NIP_10_max = reshape_matrix(Matrix(CSV.read("$input_dir/$location_i/tot_NIP_max.csv", DataFrame, header=false)))
# TOT_NIP_10_min = reshape_matrix(Matrix(CSV.read("$input_dir/$location_i/tot_NIP_min.csv", DataFrame, header=false)))
# TOT_NIP_10_amp = TOT_NIP_10_max - TOT_NIP_10_min


# IQN_10_aamp = mean(TOT_NIP_10_amp, dims=3)[:, :]
# axes[i, j].imshow(IQN_10_aamp, cmap="cividis", interpolation="nearest", origin="lower")
# axes[i, j].set_title("PortlandME")


# # for next location
# location_i = locations_lat_long[6]

# title = "BostonMA"


# # place at subplot 2, 7
# i = 2
# j = 7

# # create a subplot at the specified location
# TOT_NIP_10_max = reshape_matrix(Matrix(CSV.read("$input_dir/$location_i/tot_NIP_max.csv", DataFrame, header=false)))
# TOT_NIP_10_min = reshape_matrix(Matrix(CSV.read("$input_dir/$location_i/tot_NIP_min.csv", DataFrame, header=false)))
# TOT_NIP_10_amp = TOT_NIP_10_max - TOT_NIP_10_min


# IQN_10_aamp = mean(TOT_NIP_10_amp, dims=3)[:, :]
# axes[i, j].imshow(IQN_10_aamp, cmap="cividis", interpolation="nearest", origin="lower")
# axes[i, j].set_title("BostonMA")


# # for next location
# location_i = locations_lat_long[7]


# title = "MineapolisMN"


# # place at subplot 3, 3
# i = 3
# j = 3


# # create a subplot at the specified location
# TOT_NIP_10_max = reshape_matrix(Matrix(CSV.read("$input_dir/$location_i/tot_NIP_max.csv", DataFrame, header=false)))
# TOT_NIP_10_min = reshape_matrix(Matrix(CSV.read("$input_dir/$location_i/tot_NIP_min.csv", DataFrame, header=false)))
# TOT_NIP_10_amp = TOT_NIP_10_max - TOT_NIP_10_min


# IQN_10_aamp = mean(TOT_NIP_10_amp, dims=3)[:, :]
# axes[i, j].imshow(IQN_10_aamp, cmap="cividis", interpolation="nearest", origin="lower")
# axes[i, j].set_title("MineapolisMN")


# # for next location
# location_i = locations_lat_long[8]

# title = "DetroitMI"


# # place at subplot 3, 5
# i = 3
# j = 5

# # create a subplot at the specified location
# TOT_NIP_10_max = reshape_matrix(Matrix(CSV.read("$input_dir/$location_i/tot_NIP_max.csv", DataFrame, header=false)))
# TOT_NIP_10_min = reshape_matrix(Matrix(CSV.read("$input_dir/$location_i/tot_NIP_min.csv", DataFrame, header=false)))
# TOT_NIP_10_amp = TOT_NIP_10_max - TOT_NIP_10_min


# IQN_10_aamp = mean(TOT_NIP_10_amp, dims=3)[:, :]
# axes[i, j].imshow(IQN_10_aamp, cmap="cividis", interpolation="nearest", origin="lower")
# axes[i, j].set_title("DetroitMI")


# # for next location
# location_i = locations_lat_long[9]

# title = "ColumbusOH"

# # place at subplot 4, 5
# i = 4
# j = 5

# # create a subplot at the specified location
# TOT_NIP_10_max = reshape_matrix(Matrix(CSV.read("$input_dir/$location_i/tot_NIP_max.csv", DataFrame, header=false)))
# TOT_NIP_10_min = reshape_matrix(Matrix(CSV.read("$input_dir/$location_i/tot_NIP_min.csv", DataFrame, header=false)))
# TOT_NIP_10_amp = TOT_NIP_10_max - TOT_NIP_10_min


# IQN_10_aamp = mean(TOT_NIP_10_amp, dims=3)[:, :]
# axes[i, j].imshow(IQN_10_aamp, cmap="cividis", interpolation="nearest", origin="lower")
# axes[i, j].set_title("ColumbusOH")


# # for next location
# location_i = locations_lat_long[10]

# title = "ClevelandOH"


# # place at subplot 3, 5
# i = 5
# j = 5

# # create a subplot at the specified location
# TOT_NIP_10_max = reshape_matrix(Matrix(CSV.read("$input_dir/$location_i/tot_NIP_max.csv", DataFrame, header=false)))
# TOT_NIP_10_min = reshape_matrix(Matrix(CSV.read("$input_dir/$location_i/tot_NIP_min.csv", DataFrame, header=false)))
# TOT_NIP_10_amp = TOT_NIP_10_max - TOT_NIP_10_min


# IQN_10_aamp = mean(TOT_NIP_10_amp, dims=3)[:, :]
# axes[i, j].imshow(IQN_10_aamp, cmap="cividis", interpolation="nearest", origin="lower")
# axes[i, j].set_title("ClevelandOH")


# # for next location
# location_i = locations_lat_long[11]

# title = "PittsburghPA"

    
# # place at subplot 5, 5
# i = 4
# j = 6

# # create a subplot at the specified location
# TOT_NIP_10_max = reshape_matrix(Matrix(CSV.read("$input_dir/$location_i/tot_NIP_max.csv", DataFrame, header=false)))
# TOT_NIP_10_min = reshape_matrix(Matrix(CSV.read("$input_dir/$location_i/tot_NIP_min.csv", DataFrame, header=false)))
# TOT_NIP_10_amp = TOT_NIP_10_max - TOT_NIP_10_min


# IQN_10_aamp = mean(TOT_NIP_10_amp, dims=3)[:, :]
# axes[i, j].imshow(IQN_10_aamp, cmap="cividis", interpolation="nearest", origin="lower")
# axes[i, j].set_title("PittsburghPA")


# # for next location
# location_i = locations_lat_long[12]
