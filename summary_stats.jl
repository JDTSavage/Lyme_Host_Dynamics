using CSV, DataFrames, Statistics, Tables
include("plotting.jl")

location = "PortlandME_1971-2021" 

# Calculate summary statistics for DIN, DON, NIP mean, min, max, and amplitude

# JDTS Nov 24, 2023 nlifespan_52_ is latest run

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

# Set variables for DIN, DON, NIP mean, min, max, and amplitude
# also separate to 0 variance and vector for all variance
DIN_mean = DataFrame(mean(IQN_10_avg, dims=3)[:, :, 1], :auto)
DIN_mean_no_var = DataFrame(Tables.table(DIN_mean[:, 1]))
# low variance
DIN_mean_low_var = DataFrame(Tables.table(vec(Matrix(DIN_mean[:, 2:34]))))
# med variance
DIN_mean_med_var = DataFrame(Tables.table(vec(Matrix(DIN_mean[:, 35:67]))))
# high variance
DIN_mean_high_var = DataFrame(Tables.table(vec(Matrix(DIN_mean[:, 68:end]))))


# rename column names to no variance, variance 
rename!(DIN_mean_no_var, :Column1 => :"mean DIN")
rename!(DIN_mean_low_var, :Column1 => :"mean DIN")
rename!(DIN_mean_med_var, :Column1 => :"mean DIN")
rename!(DIN_mean_high_var, :Column1 => :"mean DIN")


DIN_min = DataFrame(mean(IQN_10_min, dims=3)[:, :, 1], :auto)
DIN_min_no_var = DataFrame(Tables.table(DIN_min[:, 1]))
# low variance
DIN_min_low_var = DataFrame(Tables.table(vec(Matrix(DIN_min[:, 2:34]))))
# med variance
DIN_min_med_var = DataFrame(Tables.table(vec(Matrix(DIN_min[:, 35:67]))))
# high variance
DIN_min_high_var = DataFrame(Tables.table(vec(Matrix(DIN_min[:, 68:end]))))

# rename column names to no variance, variance 
rename!(DIN_min_no_var, :Column1 => :"min DIN")
rename!(DIN_min_low_var, :Column1 => :"min DIN")
rename!(DIN_min_med_var, :Column1 => :"min DIN")
rename!(DIN_min_high_var, :Column1 => :"min DIN")

DIN_max = DataFrame(mean(IQN_10_max, dims=3)[:, :, 1], :auto)
DIN_max_no_var = DataFrame(Tables.table(DIN_max[:, 1]))
# low variance
DIN_max_low_var = DataFrame(Tables.table(vec(Matrix(DIN_max[:, 2:34]))))
# med variance
DIN_max_med_var = DataFrame(Tables.table(vec(Matrix(DIN_max[:, 35:67]))))
# high variance
DIN_max_high_var = DataFrame(Tables.table(vec(Matrix(DIN_max[:, 68:end]))))

# rename column names to no variance, variance 
rename!(DIN_max_no_var, :Column1 => :"max DIN")
rename!(DIN_max_low_var, :Column1 => :"max DIN")
rename!(DIN_max_med_var, :Column1 => :"max DIN")
rename!(DIN_max_high_var, :Column1 => :"max DIN")

DIN_amp = DataFrame(mean(IQN_10_amp, dims=3)[:, :, 1], :auto)
DIN_amp_no_var = DataFrame(Tables.table(DIN_amp[:, 1]))
# low variance
DIN_amp_low_var = DataFrame(Tables.table(vec(Matrix(DIN_amp[:, 2:34]))))
# med variance
DIN_amp_med_var = DataFrame(Tables.table(vec(Matrix(DIN_amp[:, 35:67]))))
# high variance
DIN_amp_high_var = DataFrame(Tables.table(vec(Matrix(DIN_amp[:, 68:end]))))

# rename column names to no variance, variance 
rename!(DIN_amp_no_var, :Column1 => "amp DIN")
rename!(DIN_amp_low_var, :Column1 => "amp DIN")
rename!(DIN_amp_med_var, :Column1 => "amp DIN")
rename!(DIN_amp_high_var, :Column1 => "amp DIN")

DON_mean = DataFrame(mean(IQN_10_avg .+ QN_10_avg, dims=3)[:, :, 1], :auto)
DON_mean_no_var = DataFrame(Tables.table(DON_mean[:, 1]))
# low variance
DON_mean_low_var = DataFrame(Tables.table(vec(Matrix(DON_mean[:, 2:34]))))
# med variance
DON_mean_med_var = DataFrame(Tables.table(vec(Matrix(DON_mean[:, 35:67]))))
# high variance
DON_mean_high_var = DataFrame(Tables.table(vec(Matrix(DON_mean[:, 68:end]))))


# rename column names to no variance, variance
rename!(DON_mean_no_var, :Column1 => :"mean DON")
rename!(DON_mean_low_var, :Column1 => :"mean DON")
rename!(DON_mean_med_var, :Column1 => :"mean DON")
rename!(DON_mean_high_var, :Column1 => :"mean DON")

DON_min = DataFrame(mean(TOT_QN_10_min .+ QN_10_min, dims=3)[:, :, 1], :auto)
DON_min_no_var = DataFrame(Tables.table(DON_min[:, 1]))
# low variance
DON_min_low_var = DataFrame(Tables.table(vec(Matrix(DON_min[:, 2:34]))))
# med variance
DON_min_med_var = DataFrame(Tables.table(vec(Matrix(DON_min[:, 35:67]))))
# high variance
DON_min_high_var = DataFrame(Tables.table(vec(Matrix(DON_min[:, 68:end]))))

# rename column names to no variance, variance
rename!(DON_min_no_var, :Column1 => :"min DON")
rename!(DON_min_low_var, :Column1 => :"min DON")
rename!(DON_min_med_var, :Column1 => :"min DON")
rename!(DON_min_high_var, :Column1 => :"min DON")

DON_max = DataFrame(mean(TOT_QN_10_max .+ QN_10_max, dims=3)[:, :, 1], :auto)
DON_max_no_var = DataFrame(Tables.table(DON_max[:, 1]))
# low variance
DON_max_low_var = DataFrame(Tables.table(vec(Matrix(DON_max[:, 2:34]))))
# med variance
DON_max_med_var = DataFrame(Tables.table(vec(Matrix(DON_max[:, 35:67]))))
# high variance
DON_max_high_var = DataFrame(Tables.table(vec(Matrix(DON_max[:, 68:end]))))

# rename column names to no variance, variance
rename!(DON_max_no_var, :Column1 => :"max DON")
rename!(DON_max_low_var, :Column1 => :"max DON")
rename!(DON_max_med_var, :Column1 => :"max DON")
rename!(DON_max_high_var, :Column1 => :"max DON")

DON_amp = DataFrame(mean(TOT_10_amp, dims=3)[:, :, 1], :auto)
DON_amp_no_var = DataFrame(Tables.table(DON_amp[:, 1]))
# low variance
DON_amp_low_var = DataFrame(Tables.table(vec(Matrix(DON_amp[:, 2:34]))))
# med variance
DON_amp_med_var = DataFrame(Tables.table(vec(Matrix(DON_amp[:, 35:67]))))
# high variance
DON_amp_high_var = DataFrame(Tables.table(vec(Matrix(DON_amp[:, 68:end]))))

# rename column names to no variance, variance
rename!(DON_amp_no_var, :Column1 => :"amp DON")
rename!(DON_amp_low_var, :Column1 => :"amp DON")
rename!(DON_amp_med_var, :Column1 => :"amp DON")
rename!(DON_amp_high_var, :Column1 => :"amp DON")

NIP_mean = DataFrame(mean((IQN_10_avg)./(IQN_10_avg .+ QN_10_avg), dims=3)[:, :, 1], :auto)
NIP_mean_no_var = DataFrame(Tables.table(NIP_mean[:, 1]))
# low variance
NIP_mean_low_var = DataFrame(Tables.table(vec(Matrix(NIP_mean[:, 2:34]))))
# med variance
NIP_mean_med_var = DataFrame(Tables.table(vec(Matrix(NIP_mean[:, 35:67]))))
# high variance
NIP_mean_high_var = DataFrame(Tables.table(vec(Matrix(NIP_mean[:, 68:end]))))

# rename column names to no variance, variance
rename!(NIP_mean_no_var, :Column1 => :"mean NIP")
rename!(NIP_mean_low_var, :Column1 => :"mean NIP")
rename!(NIP_mean_med_var, :Column1 => :"mean NIP")
rename!(NIP_mean_high_var, :Column1 => :"mean NIP")

NIP_min = DataFrame(mean(TOT_NIP_10_min, dims=3)[:, :, 1], :auto)
NIP_min_no_var = DataFrame(Tables.table(NIP_min[:, 1]))
# low variance
NIP_min_low_var = DataFrame(Tables.table(vec(Matrix(NIP_min[:, 2:34]))))
# med variance
NIP_min_med_var = DataFrame(Tables.table(vec(Matrix(NIP_min[:, 35:67]))))
# high variance
NIP_min_high_var = DataFrame(Tables.table(vec(Matrix(NIP_min[:, 68:end]))))

# rename column names to no variance, variance
rename!(NIP_min_no_var, :Column1 => :"min NIP")
rename!(NIP_min_low_var, :Column1 => :"min NIP")
rename!(NIP_min_med_var, :Column1 => :"min NIP")
rename!(NIP_min_high_var, :Column1 => :"min NIP")

NIP_max = DataFrame(mean(TOT_NIP_10_max, dims=3)[:, :, 1], :auto)
NIP_max_no_var = DataFrame(Tables.table(NIP_max[:, 1]))
# low variance
NIP_max_low_var = DataFrame(Tables.table(vec(Matrix(NIP_max[:, 2:34]))))
# med variance
NIP_max_med_var = DataFrame(Tables.table(vec(Matrix(NIP_max[:, 35:67]))))
# high variance
NIP_max_high_var = DataFrame(Tables.table(vec(Matrix(NIP_max[:, 68:end]))))


# rename column names to no variance, variance
rename!(NIP_max_no_var, :Column1 => :"max NIP")
rename!(NIP_max_low_var, :Column1 => :"max NIP")
rename!(NIP_max_med_var, :Column1 => :"max NIP")
rename!(NIP_max_high_var, :Column1 => :"max NIP")

NIP_amp = DataFrame(mean(TOT_NIP_10_amp, dims=3)[:, :, 1], :auto)
NIP_amp_no_var = DataFrame(Tables.table(NIP_amp[:, 1]))
# low variance
NIP_amp_low_var = DataFrame(Tables.table(vec(Matrix(NIP_amp[:, 2:34]))))
# med variance
NIP_amp_med_var = DataFrame(Tables.table(vec(Matrix(NIP_amp[:, 35:67]))))
# high variance
NIP_amp_high_var = DataFrame(Tables.table(vec(Matrix(NIP_amp[:, 68:end]))))


# rename column names to no variance, variance
rename!(NIP_amp_no_var, :Column1 => :"amp NIP")
rename!(NIP_amp_low_var, :Column1 => :"amp NIP")
rename!(NIP_amp_med_var, :Column1 => :"amp NIP")
rename!(NIP_amp_high_var, :Column1 => :"amp NIP")

# Stats will be mean, median, (Q1, Q3), min, max for 0 variance and all variance groups
DIN_mean_no_var_stats = DataFrame(describe(DIN_mean_no_var, :all)[1, [1, 2, 4, 5, 6, 7, 8]])
DIN_mean_low_var_stats = DataFrame(describe(DIN_mean_low_var, :all)[1, [1, 2, 4, 5, 6, 7, 8]])
DIN_mean_med_var_stats = DataFrame(describe(DIN_mean_med_var, :all)[1, [1, 2, 4, 5, 6, 7, 8]])
DIN_mean_high_var_stats = DataFrame(describe(DIN_mean_high_var, :all)[1, [1, 2, 4, 5, 6, 7, 8]])

DIN_min_no_var_stats = DataFrame(describe(DIN_min_no_var, :all)[1, [1, 2, 4, 5, 6, 7, 8]])
DIN_min_low_var_stats = DataFrame(describe(DIN_min_low_var, :all)[1, [1, 2, 4, 5, 6, 7, 8]])
DIN_min_med_var_stats = DataFrame(describe(DIN_min_med_var, :all)[1, [1, 2, 4, 5, 6, 7, 8]])
DIN_min_high_var_stats = DataFrame(describe(DIN_min_high_var, :all)[1, [1, 2, 4, 5, 6, 7, 8]])

DIN_max_no_var_stats = DataFrame(describe(DIN_max_no_var, :all)[1, [1, 2, 4, 5, 6, 7, 8]])
DIN_max_low_var_stats = DataFrame(describe(DIN_max_low_var, :all)[1, [1, 2, 4, 5, 6, 7, 8]])
DIN_max_med_var_stats = DataFrame(describe(DIN_max_med_var, :all)[1, [1, 2, 4, 5, 6, 7, 8]])
DIN_max_high_var_stats = DataFrame(describe(DIN_max_high_var, :all)[1, [1, 2, 4, 5, 6, 7, 8]])

DIN_amp_no_var_stats = DataFrame(describe(DIN_amp_no_var, :all)[1, [1, 2, 4, 5, 6, 7, 8]])
DIN_amp_low_var_stats = DataFrame(describe(DIN_amp_low_var, :all)[1, [1, 2, 4, 5, 6, 7, 8]])
DIN_amp_med_var_stats = DataFrame(describe(DIN_amp_med_var, :all)[1, [1, 2, 4, 5, 6, 7, 8]])
DIN_amp_high_var_stats = DataFrame(describe(DIN_amp_high_var, :all)[1, [1, 2, 4, 5, 6, 7, 8]])

DON_mean_no_var_stats = DataFrame(describe(DON_mean_no_var, :all)[1, [1, 2, 4, 5, 6, 7, 8]])
DON_mean_low_var_stats = DataFrame(describe(DON_mean_low_var, :all)[1, [1, 2, 4, 5, 6, 7, 8]])
DON_mean_med_var_stats = DataFrame(describe(DON_mean_med_var, :all)[1, [1, 2, 4, 5, 6, 7, 8]])
DON_mean_high_var_stats = DataFrame(describe(DON_mean_high_var, :all)[1, [1, 2, 4, 5, 6, 7, 8]])

DON_min_no_var_stats = DataFrame(describe(DON_min_no_var, :all)[1, [1, 2, 4, 5, 6, 7, 8]])
DON_min_low_var_stats = DataFrame(describe(DON_min_low_var, :all)[1, [1, 2, 4, 5, 6, 7, 8]])
DON_min_med_var_stats = DataFrame(describe(DON_min_med_var, :all)[1, [1, 2, 4, 5, 6, 7, 8]])
DON_min_high_var_stats = DataFrame(describe(DON_min_high_var, :all)[1, [1, 2, 4, 5, 6, 7, 8]])

DON_max_no_var_stats = DataFrame(describe(DON_max_no_var, :all)[1, [1, 2, 4, 5, 6, 7, 8]])
DON_max_low_var_stats = DataFrame(describe(DON_max_low_var, :all)[1, [1, 2, 4, 5, 6, 7, 8]])
DON_max_med_var_stats = DataFrame(describe(DON_max_med_var, :all)[1, [1, 2, 4, 5, 6, 7, 8]])
DON_max_high_var_stats = DataFrame(describe(DON_max_high_var, :all)[1, [1, 2, 4, 5, 6, 7, 8]])

DON_amp_no_var_stats = DataFrame(describe(DON_amp_no_var, :all)[1, [1, 2, 4, 5, 6, 7, 8]])
DON_amp_low_var_stats = DataFrame(describe(DON_amp_low_var, :all)[1, [1, 2, 4, 5, 6, 7, 8]])
DON_amp_med_var_stats = DataFrame(describe(DON_amp_med_var, :all)[1, [1, 2, 4, 5, 6, 7, 8]])
DON_amp_high_var_stats = DataFrame(describe(DON_amp_high_var, :all)[1, [1, 2, 4, 5, 6, 7, 8]])

NIP_mean_no_var_stats = DataFrame(describe(NIP_mean_no_var, :all)[1, [1, 2, 4, 5, 6, 7, 8]])
NIP_mean_low_var_stats = DataFrame(describe(NIP_mean_low_var, :all)[1, [1, 2, 4, 5, 6, 7, 8]])
NIP_mean_med_var_stats = DataFrame(describe(NIP_mean_med_var, :all)[1, [1, 2, 4, 5, 6, 7, 8]])
NIP_mean_high_var_stats = DataFrame(describe(NIP_mean_high_var, :all)[1, [1, 2, 4, 5, 6, 7, 8]])

NIP_min_no_var_stats = DataFrame(describe(NIP_min_no_var, :all)[1, [1, 2, 4, 5, 6, 7, 8]])
NIP_min_low_var_stats = DataFrame(describe(NIP_min_low_var, :all)[1, [1, 2, 4, 5, 6, 7, 8]])
NIP_min_med_var_stats = DataFrame(describe(NIP_min_med_var, :all)[1, [1, 2, 4, 5, 6, 7, 8]])
NIP_min_high_var_stats = DataFrame(describe(NIP_min_high_var, :all)[1, [1, 2, 4, 5, 6, 7, 8]])

NIP_max_no_var_stats = DataFrame(describe(NIP_max_no_var, :all)[1, [1, 2, 4, 5, 6, 7, 8]])
NIP_max_low_var_stats = DataFrame(describe(NIP_max_low_var, :all)[1, [1, 2, 4, 5, 6, 7, 8]])
NIP_max_med_var_stats = DataFrame(describe(NIP_max_med_var, :all)[1, [1, 2, 4, 5, 6, 7, 8]])
NIP_max_high_var_stats = DataFrame(describe(NIP_max_high_var, :all)[1, [1, 2, 4, 5, 6, 7, 8]])

NIP_amp_no_var_stats = DataFrame(describe(NIP_amp_no_var, :all)[1, [1, 2, 4, 5, 6, 7, 8]])
NIP_amp_low_var_stats = DataFrame(describe(NIP_amp_low_var, :all)[1, [1, 2, 4, 5, 6, 7, 8]])
NIP_amp_med_var_stats = DataFrame(describe(NIP_amp_med_var, :all)[1, [1, 2, 4, 5, 6, 7, 8]])
NIP_amp_high_var_stats = DataFrame(describe(NIP_amp_high_var, :all)[1, [1, 2, 4, 5, 6, 7, 8]])



# join above stats into one dataframe
descriptive_table = outerjoin(
    DIN_mean_no_var_stats, DIN_mean_low_var_stats, DIN_mean_med_var_stats, DIN_mean_high_var_stats,
    DIN_min_no_var_stats, DIN_min_low_var_stats, DIN_min_med_var_stats, DIN_min_high_var_stats,
    DIN_max_no_var_stats, DIN_max_low_var_stats, DIN_max_med_var_stats, DIN_max_high_var_stats,
    DIN_amp_no_var_stats, DIN_amp_low_var_stats, DIN_amp_med_var_stats, DIN_amp_high_var_stats,
    DON_mean_no_var_stats, DON_mean_low_var_stats, DON_mean_med_var_stats, DON_mean_high_var_stats,
    DON_min_no_var_stats, DON_min_low_var_stats, DON_min_med_var_stats, DON_min_high_var_stats,
    DON_max_no_var_stats, DON_max_low_var_stats, DON_max_med_var_stats, DON_max_high_var_stats,
    DON_amp_no_var_stats, DON_amp_low_var_stats, DON_amp_med_var_stats, DON_amp_high_var_stats,
    NIP_mean_no_var_stats, NIP_mean_low_var_stats, NIP_mean_med_var_stats, NIP_mean_high_var_stats,
    NIP_min_no_var_stats, NIP_min_low_var_stats, NIP_min_med_var_stats, NIP_min_high_var_stats,
    NIP_max_no_var_stats, NIP_max_low_var_stats, NIP_max_med_var_stats, NIP_max_high_var_stats,
    NIP_amp_no_var_stats, NIP_amp_low_var_stats, NIP_amp_med_var_stats, NIP_amp_high_var_stats,
    on = [:variable, :mean, :min, :q25, :median, :q75, :max])
# rearrange columns with select!
select!(descriptive_table, [:variable, :min, :q25, :mean, :median, :q75, :max])

# round DIN, DON to 0 decimal places,
descriptive_table[1:32, 2:end] = convert.(Int64, round.(descriptive_table[1:32, 2:end], digits = 0))
# round NIP to 2 decimal places
descriptive_table[33:end, 2:end] = convert.(Float64, round.(descriptive_table[33:end, 2:end], digits = 2))

# insert column after variable called variance
# vector of colum length with alternating "0" and "1-99"
variance_vector = repeat(["0", "1-33", "34-66", "67-99"], outer = convert(Int64, length(descriptive_table[! ,:variable])/4))
insertcols!(descriptive_table, 2, :variance => variance_vector)

using Latexify

dt = descriptive_table
for row in [1:4:length(dt[!, :variable]);]    
    if row < 33
        type_conv = Int64
    else
        type_conv = Float64
    end 
    print(
        string(dt[row, :variable]) * " & " * 
        " \\makecell{" * string(dt[row, :variance]) * " \\\\ " * string(dt[row + 1, :variance]) * " \\\\ " * string(dt[row + 2, :variance]) * " \\\\ " * string(dt[row + 3, :variance])  * "}" * " & " *
        " \\makecell{" * string(convert(type_conv, dt[row, :min])) * " \\\\ " * string(convert(type_conv, dt[row + 1, :min])) * " \\\\ " * string(convert(type_conv, dt[row + 2, :min])) * " \\\\ " * string(convert(type_conv, dt[row + 3, :min])) * "}" * " & " *
        " \\makecell{" * string(convert(type_conv, dt[row, :q25])) * " \\\\ " * string(convert(type_conv, dt[row + 1, :q25])) * " \\\\ " * string(convert(type_conv, dt[row + 2, :q25])) * " \\\\ " * string(convert(type_conv, dt[row + 3, :q25])) * "}" * " & " *
        " \\makecell{" * string(convert(type_conv, dt[row, :mean])) * " \\\\ " * string(convert(type_conv, dt[row + 1, :mean])) * " \\\\ " * string(convert(type_conv, dt[row + 2, :mean])) * " \\\\ " * string(convert(type_conv, dt[row + 3, :mean])) *"}" * " & " *
        " \\makecell{" * string(convert(type_conv, dt[row, :median])) * " \\\\ " * string(convert(type_conv, dt[row + 1, :median])) * " \\\\ " * string(convert(type_conv, dt[row + 2, :median])) * " \\\\ " * string(convert(type_conv, dt[row + 3, :median])) * "}" * " & " *
        " \\makecell{" * string(convert(type_conv, dt[row, :q75])) * " \\\\ " * string(convert(type_conv, dt[row + 1, :q75])) * " \\\\ " * string(convert(type_conv, dt[row + 2, :q75])) * " \\\\ " * string(convert(type_conv, dt[row + 3, :q75])) * "}" * " & " *
        " \\makecell{" * string(convert(type_conv, dt[row, :max])) * " \\\\ " * string(convert(type_conv, dt[row + 1, :max])) * " \\\\ " * string(convert(type_conv, dt[row + 2, :max])) * " \\\\ " * string(convert(type_conv, dt[row + 3, :max]))  * "}" *
        "\\\\\n") 
end


# latexify(descriptive_table, latex=false, env = :table)

