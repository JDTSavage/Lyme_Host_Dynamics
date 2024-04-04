# Initialized with plotting.jl

#! 3d curves - Portland

# start with portland data
location = "PortlandME_1971-2021"
input_dir = "Analysis_Data"
output_dir = "Analysis_Data/Exploratory_Plots/PortlandME_1971-2021"

#! DIN

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
TOT_NIP_10_max = reshape_matrix(Matrix(CSV.read("$input_dir/$location/nlifespan_52_tot_NIP_max.csv", DataFrame, header=false)))
TOT_NIP_10_min = reshape_matrix(Matrix(CSV.read("$input_dir/$location/nlifespan_52_tot_NIP_min.csv", DataFrame, header=false)))
TOT_NIP_10_amp = TOT_NIP_10_max - TOT_NIP_10_min

IQN_10_amean = mean(IQN_10_avg./(QN_10_avg .+ IQN_10_avg), dims=3)[:, :]
DIN_10_amean = mean(IQN_10_avg, dims=3)[:, :]

# mean, min, max, amp for DIN 
DIN_amean = mean(IQN_10_avg, dims=3)[:, :]
DIN_amin = mean(IQN_10_min, dims=3)[:, :]
DIN_amax = mean(IQN_10_max, dims=3)[:, :]
DIN_aamp = mean(IQN_10_amp, dims=3)[:, :]

# mean, min, max, amp for DON
DON_amean = mean(IQN_10_avg + QN_10_avg, dims=3)[:, :]
DON_amin = mean(TOT_QN_10_min, dims=3)[:, :]
DON_amax = mean(TOT_QN_10_max, dims=3)[:, :]
DON_aamp = mean(TOT_10_amp, dims=3)[:, :]

# mean, min, max, amp for NIP
NIP_amean = mean(IQN_10_avg./(QN_10_avg .+ IQN_10_avg), dims=3)[:, :]
NIP_amin = mean(TOT_NIP_10_min, dims=3)[:, :]
NIP_amax = mean(TOT_NIP_10_max, dims=3)[:, :]
NIP_aamp = mean(TOT_NIP_10_amp, dims=3)[:, :]

# matrix is x by y, each element is the NIP
# reshape matrix to store x, y and NIP values from matrix
# matrix will by 10000 by 3
function matrix_to_longer(matrix)
    matrix_reshaped = zeros(size(matrix)[1] * size(matrix)[2], 3)
    for i in 1:100
        for j in 1:100
            matrix_reshaped[(i - 1) * 100 + j, 1] = i
            matrix_reshaped[(i - 1) * 100 + j, 2] = j
            matrix_reshaped[(i - 1) * 100 + j, 3] = matrix[i, j]
        end
    end
    return matrix_reshaped
end

# make each matrix of  mean, min, max, amp for DIN, DON, NIP to longer
DIN_amean_longer = matrix_to_longer(DIN_amean)
DIN_amin_longer = matrix_to_longer(DIN_amin)
DIN_amax_longer = matrix_to_longer(DIN_amax)
DIN_aamp_longer = matrix_to_longer(DIN_aamp)

DON_amean_longer = matrix_to_longer(DON_amean)
DON_amin_longer = matrix_to_longer(DON_amin)
DON_amax_longer = matrix_to_longer(DON_amax)
DON_aamp_longer = matrix_to_longer(DON_aamp)

NIP_amean_longer = matrix_to_longer(NIP_amean)
NIP_amin_longer = matrix_to_longer(NIP_amin)
NIP_amax_longer = matrix_to_longer(NIP_amax)
NIP_aamp_longer = matrix_to_longer(NIP_aamp)

# write each of the above matrices to csv
CSV.write("$output_dir/surface_data/lifespan_52_Mean_DIN.csv", Tables.table(DIN_amean_longer), header=false)
CSV.write("$output_dir/surface_data/lifespan_52_Min_DIN.csv", Tables.table(DIN_amin_longer), header=false)
CSV.write("$output_dir/surface_data/lifespan_52_Max_DIN.csv", Tables.table(DIN_amax_longer), header=false)
CSV.write("$output_dir/surface_data/lifespan_52_Amp_DIN.csv", Tables.table(DIN_aamp_longer), header=false)

CSV.write("$output_dir/surface_data/lifespan_52_Mean_DON.csv", Tables.table(DON_amean_longer), header=false)
CSV.write("$output_dir/surface_data/lifespan_52_Min_DON.csv", Tables.table(DON_amin_longer), header=false)
CSV.write("$output_dir/surface_data/lifespan_52_Max_DON.csv", Tables.table(DON_amax_longer), header=false)
CSV.write("$output_dir/surface_data/lifespan_52_Amp_DON.csv", Tables.table(DON_aamp_longer), header=false)

CSV.write("$output_dir/surface_data/lifespan_52_Mean_NIP.csv", Tables.table(NIP_amean_longer), header=false)
CSV.write("$output_dir/surface_data/lifespan_52_Min_NIP.csv", Tables.table(NIP_amin_longer), header=false)
CSV.write("$output_dir/surface_data/lifespan_52_Max_NIP.csv", Tables.table(NIP_amax_longer), header=false)
CSV.write("$output_dir/surface_data/lifespan_52_Amp_NIP.csv", Tables.table(NIP_aamp_longer), header=false)

#IQN_μ_vec = IQN_10_amean_reshaped[:, 1]
#IQN_σ_vec = IQN_10_amean_reshaped[:, 2]
#IQN_NIP_vec = IQN_10_amean_reshaped[:, 3]



# read in csv
function meshgrid(x, y)
    X = [i for i in x, j in 1:length(y)]
    Y = [j for i in 1:length(x), j in y]
    return Y, X
end

# plot NIP amplitude
#surf_pred = Matrix(CSV.read("Analysis_Data/Exploratory_Plots/PortlandME_1971-2021/surface_data/Amp_NIP_surf.csv", DataFrame, header=false))

#IQN_μ_vec = surf_pred[:, 1]
#IQN_σ_vec = surf_pred[:, 2]
#IQN_NIP_vec = surf_pred[:, 3:end]

#x_grd,y_grd = meshgrid(IQN_μ_vec, IQN_σ_vec)


# plot_surface(IQN_μ_vec, IQN_σ_vec, IQN_NIP_vec)
# plot_surface(x_grd, y_grd, IQN_NIP_vec)

#norm = plt.Normalize(minimum(IQN_NIP_vec), maximum(IQN_NIP_vec))
#colors = plt.cm.cividis(norm(IQN_NIP_vec))
#rcounts = size(colors)[1]
#ccounts = size(colors)[2]


#fig = plt.figure()
#ax = fig.gca(projection="3d")
#ax.xaxis.set_pane_color((1.0, 1.0, 1.0, 0.0))
#ax.yaxis.set_pane_color((1.0, 1.0, 1.0, 0.0))
#ax.zaxis.set_pane_color((1.0, 1.0, 1.0, 0.0))
#ax.grid(false)
#surf = ax.plot_surface(x_grd, y_grd, IQN_NIP_vec, rcount=rcounts, ccount=ccounts, facecolors=colors, shade=false)
#surf.set_facecolor((0,0,0,0))
#plt.show()

#xlabel("μ Mouse")
#ylabel("σ Mouse")
#zlabel("NIP")
