# start with portland data
location = "PortlandME_1971-2021"
input_dir = "Analysis_Data"
output_dir = "Analysis_Data/Exploratory_Plots/PortlandME_1971-2021"

#! DIN

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
TOT_NIP_10_max = reshape_matrix(Matrix(CSV.read("$input_dir/$location/tot_NIP_max.csv", DataFrame, header=false)))
TOT_NIP_10_min = reshape_matrix(Matrix(CSV.read("$input_dir/$location/tot_NIP_min.csv", DataFrame, header=false)))
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
# CSV.write("$output_dir/surface_data/Mean_DIN.csv", Tables.table(DIN_amean_longer), header=false)
# CSV.write("$output_dir/surface_data/Min_DIN.csv", Tables.table(DIN_amin_longer), header=false)
# CSV.write("$output_dir/surface_data/Max_DIN.csv", Tables.table(DIN_amax_longer), header=false)
# CSV.write("$output_dir/surface_data/Amp_DIN.csv", Tables.table(DIN_aamp_longer), header=false)

# CSV.write("$output_dir/surface_data/Mean_DON.csv", Tables.table(DON_amean_longer), header=false)
# CSV.write("$output_dir/surface_data/Min_DON.csv", Tables.table(DON_amin_longer), header=false)
# CSV.write("$output_dir/surface_data/Max_DON.csv", Tables.table(DON_amax_longer), header=false)
# CSV.write("$output_dir/surface_data/Amp_DON.csv", Tables.table(DON_aamp_longer), header=false)

# CSV.write("$output_dir/surface_data/Mean_NIP.csv", Tables.table(NIP_amean_longer), header=false)
# CSV.write("$output_dir/surface_data/Min_NIP.csv", Tables.table(NIP_amin_longer), header=false)
# CSV.write("$output_dir/surface_data/Max_NIP.csv", Tables.table(NIP_amax_longer), header=false)
# CSV.write("$output_dir/surface_data/Amp_NIP.csv", Tables.table(NIP_aamp_longer), header=false)

# get μ, σ, measure from mean, min, max, amp for DIN, DON, NIP
DIN_mean_μ_vec = DIN_amean_longer[:, 1]
DIN_mean_σ_vec = DIN_amean_longer[:, 2]
DIN_mean_DIN_vec = DIN_amean_longer[:, 3]

# min
DIN_min_μ_vec = DIN_amin_longer[:, 1]
DIN_min_σ_vec = DIN_amin_longer[:, 2]
DIN_min_DIN_vec = DIN_amin_longer[:, 3]

# max
DIN_max_μ_vec = DIN_amax_longer[:, 1]
DIN_max_σ_vec = DIN_amax_longer[:, 2]
DIN_max_DIN_vec = DIN_amax_longer[:, 3]

# amp 
DIN_amp_μ_vec = DIN_aamp_longer[:, 1]
DIN_amp_σ_vec = DIN_aamp_longer[:, 2]
DIN_amp_DIN_vec = DIN_aamp_longer[:, 3]

# for DON 
DON_mean_μ_vec = DON_amean_longer[:, 1]
DON_mean_σ_vec = DON_amean_longer[:, 2]
DON_mean_DON_vec = DON_amean_longer[:, 3]

# min 
DON_min_μ_vec = DON_amin_longer[:, 1]
DON_min_σ_vec = DON_amin_longer[:, 2]
DON_min_DON_vec = DON_amin_longer[:, 3]

# max
DON_max_μ_vec = DON_amax_longer[:, 1]
DON_max_σ_vec = DON_amax_longer[:, 2]
DON_max_DON_vec = DON_amax_longer[:, 3]

# amp
DON_amp_μ_vec = DON_aamp_longer[:, 1]
DON_amp_σ_vec = DON_aamp_longer[:, 2]
DON_amp_DON_vec = DON_aamp_longer[:, 3]

# for NIP
NIP_mean_μ_vec = NIP_amean_longer[:, 1]
NIP_mean_σ_vec = NIP_amean_longer[:, 2]
NIP_mean_NIP_vec = NIP_amean_longer[:, 3]

# min
NIP_min_μ_vec = NIP_amin_longer[:, 1]
NIP_min_σ_vec = NIP_amin_longer[:, 2]
NIP_min_NIP_vec = NIP_amin_longer[:, 3]

# max 
NIP_max_μ_vec = NIP_amax_longer[:, 1]
NIP_max_σ_vec = NIP_amax_longer[:, 2]
NIP_max_NIP_vec = NIP_amax_longer[:, 3]

# amp   
NIP_amp_μ_vec = NIP_aamp_longer[:, 1]
NIP_amp_σ_vec = NIP_aamp_longer[:, 2]
NIP_amp_NIP_vec = NIP_aamp_longer[:, 3]

# 2d histograms 
output_dir = "Analysis_Data/Exploratory_Plots" 
# DIN for μ and σ for mean, min, max, amp
hist2D(DIN_mean_σ_vec, DIN_mean_DIN_vec, bins=[30, 20], density=true, cmap="cividis")
colorbar(label="Density")
xlabel("μ Mouse")
ylabel("DIN")
tight_layout()
savefig("$output_dir/$(location)/amean_DIN_variance_2dhist.png", dpi=300)
plt.close()

hist2D(DIN_mean_μ_vec, DIN_mean_DIN_vec, bins=[30, 20], density=true, cmap="cividis")
colorbar(label="Density")
xlabel("μ Mouse")
ylabel("DIN")
tight_layout()
savefig("$output_dir/$(location)/amean_DIN_mean_2dhist.png", dpi=300)
plt.close()

# max σ
hist2D(DIN_max_σ_vec, DIN_max_DIN_vec, bins=[30, 20], density=true, cmap="cividis")
colorbar(label="Density")
xlabel("μ Mouse")
ylabel("DIN")
tight_layout()
savefig("$output_dir/$(location)/amax_DIN_variance_2dhist.png", dpi=300)
plt.close()

# max μ
hist2D(DIN_max_μ_vec, DIN_max_DIN_vec, bins=[30, 20], density=true, cmap="cividis")
colorbar(label="Density")
xlabel("μ Mouse")
ylabel("DIN")
tight_layout()
savefig("$output_dir/$(location)/amax_DIN_mean_2dhist.png", dpi=300)
plt.close()

# min σ
hist2D(DIN_min_σ_vec, DIN_min_DIN_vec, bins=[30, 20], density=true, cmap="cividis")
colorbar(label="Density")
xlabel("μ Mouse")
ylabel("DIN")
tight_layout()
savefig("$output_dir/$(location)/amin_DIN_variance_2dhist.png", dpi=300)
plt.close()

# min μ
hist2D(DIN_min_μ_vec, DIN_min_DIN_vec, bins=[30, 20], density=true, cmap="cividis")
colorbar(label="Density")
xlabel("μ Mouse")
ylabel("DIN")
tight_layout()
savefig("$output_dir/$(location)/amin_DIN_mean_2dhist.png", dpi=300)
plt.close()

# amp σ
hist2D(DIN_amp_σ_vec, DIN_amp_DIN_vec, bins=[30, 20], density=true, cmap="cividis")
colorbar(label="Density")
xlabel("μ Mouse")
ylabel("DIN")
tight_layout()
savefig("$output_dir/$(location)/aamp_DIN_variance_2dhist.png", dpi=300)
plt.close()

# amp μ
hist2D(DIN_amp_μ_vec, DIN_amp_DIN_vec, bins=[30, 20], density=true, cmap="cividis")
colorbar(label="Density")
xlabel("μ Mouse")
ylabel("DIN")
tight_layout()
savefig("$output_dir/$(location)/aamp_DIN_mean_2dhist.png", dpi=300)
plt.close()

# DON for μ and σ for mean, min, max, amp
hist2D(DON_mean_σ_vec, DON_mean_DON_vec, bins=[30, 20], density=true, cmap="cividis")
colorbar(label="Density")
xlabel("μ Mouse")
ylabel("DON")
tight_layout()
savefig("$output_dir/$(location)/amean_DON_variance_2dhist.png", dpi=300)
plt.close()

# mean μ
hist2D(DON_mean_μ_vec, DON_mean_DON_vec, bins=[30, 20], density=true, cmap="cividis")
colorbar(label="Density")
xlabel("μ Mouse")
ylabel("DON")
tight_layout()
savefig("$output_dir/$(location)/amean_DON_mean_2dhist.png", dpi=300)
plt.close()

# max σ
hist2D(DON_max_σ_vec, DON_max_DON_vec, bins=[30, 20], density=true, cmap="cividis")
colorbar(label="Density")
xlabel("μ Mouse")
ylabel("DON")
tight_layout()
savefig("$output_dir/$(location)/amax_DON_variance_2dhist.png", dpi=300)
plt.close()

# max μ
hist2D(DON_max_μ_vec, DON_max_DON_vec, bins=[30, 20], density=true, cmap="cividis")
colorbar(label="Density")
xlabel("μ Mouse")
ylabel("DON")
tight_layout()
savefig("$output_dir/$(location)/amax_DON_mean_2dhist.png", dpi=300)
plt.close()

# min σ
hist2D(DON_min_σ_vec, DON_min_DON_vec, bins=[30, 20], density=true, cmap="cividis")
colorbar(label="Density")
xlabel("μ Mouse")
ylabel("DON")
tight_layout()
savefig("$output_dir/$(location)/amin_DON_variance_2dhist.png", dpi=300)
plt.close()

# min μ
hist2D(DON_min_μ_vec, DON_min_DON_vec, bins=[30, 20], density=true, cmap="cividis")
colorbar(label="Density")
xlabel("μ Mouse")
ylabel("DON")
tight_layout()
savefig("$output_dir/$(location)/amin_DON_mean_2dhist.png", dpi=300)
plt.close()

# amp σ
hist2D(DON_amp_σ_vec, DON_amp_DON_vec, bins=[30, 20], density=true, cmap="cividis")
colorbar(label="Density")
xlabel("μ Mouse")
ylabel("DON")
tight_layout()
savefig("$output_dir/$(location)/aamp_DON_variance_2dhist.png", dpi=300)
plt.close()

# amp μ
hist2D(DON_amp_μ_vec, DON_amp_DON_vec, bins=[30, 20], density=true, cmap="cividis")
colorbar(label="Density")
xlabel("μ Mouse")
ylabel("DON")
tight_layout()
savefig("$output_dir/$(location)/aamp_DON_mean_2dhist.png", dpi=300)
plt.close()

# NIP for μ and σ for mean, min, max, amp
hist2D(NIP_mean_σ_vec, NIP_mean_NIP_vec, bins=[30, 20], density=true, cmap="cividis")
colorbar(label="Density")
xlabel("μ Mouse")
ylabel("NIP")
tight_layout()
savefig("$output_dir/$(location)/amean_NIP_variance_2dhist.png", dpi=300)
plt.close()

# mean μ
hist2D(NIP_mean_μ_vec, NIP_mean_NIP_vec, bins=[30, 20], density=true, cmap="cividis")
colorbar(label="Density")
xlabel("μ Mouse")
ylabel("NIP")
tight_layout()
savefig("$output_dir/$(location)/amean_NIP_mean_2dhist.png", dpi=300)
plt.close()

# max σ
hist2D(NIP_max_σ_vec, NIP_max_NIP_vec, bins=[30, 20], density=true, cmap="cividis")
colorbar(label="Density")
xlabel("μ Mouse")
ylabel("NIP")
tight_layout()
savefig("$output_dir/$(location)/amax_NIP_variance_2dhist.png", dpi=300)
plt.close()

# max μ
hist2D(NIP_max_μ_vec, NIP_max_NIP_vec, bins=[30, 20], density=true, cmap="cividis")
colorbar(label="Density")
xlabel("μ Mouse")
ylabel("NIP")
tight_layout()
savefig("$output_dir/$(location)/amax_NIP_mean_2dhist.png", dpi=300)
plt.close()

# min σ
hist2D(NIP_min_σ_vec, NIP_min_NIP_vec, bins=[30, 20], density=true, cmap="cividis")
colorbar(label="Density")
xlabel("μ Mouse")
ylabel("NIP")
tight_layout()
savefig("$output_dir/$(location)/amin_NIP_variance_2dhist.png", dpi=300)
plt.close()

# min μ
hist2D(NIP_min_μ_vec, NIP_min_NIP_vec, bins=[30, 20], density=true, cmap="cividis")
colorbar(label="Density")
xlabel("μ Mouse")
ylabel("NIP")
tight_layout()
savefig("$output_dir/$(location)/amin_NIP_mean_2dhist.png", dpi=300)
plt.close()

# amp σ
hist2D(NIP_amp_σ_vec, NIP_amp_NIP_vec, bins=[30, 20], density=true, cmap="cividis")
colorbar(label="Density")
xlabel("μ Mouse")
ylabel("NIP")
tight_layout()
savefig("$output_dir/$(location)/aamp_NIP_variance_2dhist.png", dpi=300)
plt.close()

# amp μ
hist2D(NIP_amp_μ_vec, NIP_amp_NIP_vec, bins=[30, 20], density=true, cmap="cividis")
colorbar(label="Density")
xlabel("μ Mouse")
ylabel("NIP")
tight_layout()
savefig("$output_dir/$(location)/aamp_NIP_mean_2dhist.png", dpi=300)
plt.close()



