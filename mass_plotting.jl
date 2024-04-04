# To be run after initializing with plotting.jl

for location in locations

    # location = locations[1]
    
        #! Questing larvae average
        # QL_10_avg = reshape_matrix(Matrix(CSV.read("$input_dir/$location/mean_QL.csv", DataFrame, header=false)))
        # QL_10_max = reshape_matrix(Matrix(CSV.read("$input_dir/$location/max_QL.csv", DataFrame, header=false)))
        
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
    
        # #! Mouse avg
        # SM_10_avg = reshape_matrix(Matrix(CSV.read("$input_dir/$location/mean_SM.csv", DataFrame, header=false)))
        # ISM_10_avg = reshape_matrix(Matrix(CSV.read("$input_dir/$location/mean_ISM.csv", DataFrame, header=false)))
    
        # #! Mouse min
        # SM_10_min = reshape_matrix(Matrix(CSV.read("$input_dir/$location/min_SM.csv", DataFrame, header=false)))
        # ISM_10_min = reshape_matrix(Matrix(CSV.read("$input_dir/$location/min_ISM.csv", DataFrame, header=false)))
    
        # #! Mouse max
        # SM_10_max = reshape_matrix(Matrix(CSV.read("$input_dir/$location/max_SM.csv", DataFrame, header=false)))
        # ISM_10_max = reshape_matrix(Matrix(CSV.read("$input_dir/$location/max_ISM.csv", DataFrame, header=false)))
    
        #! Box plot creation
    
        #! Get no variance and variance data separated, process means as well (box plot is mean mean)
    
        #! DIL
        # bxplt = plot_amean_boxplot(QL_10_avg, ["No Variance", "Variance"])
        # savefig("$output_dir/$(location)/amean_boxplot_DIL.png")
        # tight_layout()
        # plt.close()
    
        # bxplt = plot_amean_boxplot(QL_10_max, ["No Variance", "Variance"])
        # savefig("$output_dir/$(location)/amean_boxplot_DIN.png")
        # tight_layout()
        # plt.close()
    
        #! DIN
        bxplt = plot_amean_boxplot(IQN_10_avg, ["No Variance", "Variance"])
        savefig("$output_dir/$(location)/amean_boxplot_DIN.png")
        tight_layout()
        plt.close()
    
        bxplt = plot_amean_boxplot(IQN_10_max, ["No Variance", "Variance"])
        savefig("$output_dir/$(location)/amax_boxplot_DIN.png")
        tight_layout()
        plt.close()
    
        bxplt = plot_amean_boxplot(IQN_10_min, ["No Variance", "Variance"])
        savefig("$output_dir/$(location)/amin_boxplot_DIN.png")
        tight_layout()
        plt.close()
    
        bxplt = plot_amean_boxplot(IQN_10_amp, ["No Variance", "Variance"])
        savefig("$output_dir/$(location)/aamp_boxplot_DIN.png")
        tight_layout()
        plt.close()
    
        #! DON
        bxplt = plot_amean_boxplot(QN_10_avg .+ IQN_10_avg, ["No Variance", "Variance"])
        savefig("$output_dir/$(location)/amean_boxplot_DON.png")
        tight_layout()
        plt.close()
    
        bxplt = plot_amean_boxplot(TOT_QN_10_max, ["No Variance", "Variance"])
        savefig("$output_dir/$(location)/amax_boxplot_DON.png")
        tight_layout()
        plt.close()
    
        bxplt = plot_amean_boxplot(TOT_QN_10_min, ["No Variance", "Variance"])
        savefig("$output_dir/$(location)/amin_boxplot_DON.png")
        tight_layout()
        plt.close()
    
        bxplt = plot_amean_boxplot(TOT_10_amp, ["No Variance", "Variance"])
        savefig("$output_dir/$(location)/aamp_boxplot_DON.png")
        tight_layout()
        plt.close()
    
        #!NIP
        bxplt = plot_amean_boxplot(IQN_10_avg./(QN_10_avg .+ IQN_10_avg), ["No Variance", "Variance"])
        savefig("$output_dir/$(location)/amean_boxplot_NIP.png")
        tight_layout()
        plt.close()
    
        bxplt = plot_amean_boxplot(TOT_NIP_10_max, ["No Variance", "Variance"])
        savefig("$output_dir/$(location)/amax_boxplot_NIP.png")
        tight_layout()
        plt.close()
    
        bxplt = plot_amean_boxplot(TOT_NIP_10_min, ["No Variance", "Variance"])
        savefig("$output_dir/$(location)/amin_boxplot_NIP.png")
        tight_layout()
        plt.close()
    
        bxplt = plot_amean_boxplot(TOT_NIP_10_amp, ["No Variance", "Variance"])
        savefig("$output_dir/$(location)/aamp_boxplot_NIP.png")
        tight_layout()
        plt.close()
    
        #! boxplot with mean of each year separately
    
        # bxplt = plot_mean_boxplot(IQN_10_avg)
        
        ##! Scatterplot Average means
    
        #! DIN
        IQN_10_amean = mean(IQN_10_avg, dims=3)[:, :]
        scttr = scatter_means(IQN_10_amean)
        xlabel("μ Mouse")
        ylabel("DIN")
        savefig("$output_dir/$(location)/amean_scatterplot_DIN.png")
        tight_layout()
        plt.close()
    
        IQN_10_amax = mean(IQN_10_max, dims=3)[:, :]
        scttr = scatter_means(IQN_10_amax)
        xlabel("μ Mouse")
        ylabel("DIN")
        savefig("$output_dir/$(location)/amax_scatterplot_DIN.png")
        tight_layout()
        plt.close()
    
        IQN_10_amin = mean(IQN_10_min, dims=3)[:, :]
        scttr = scatter_means(IQN_10_amin)
        xlabel("μ Mouse")
        ylabel("DIN")
        savefig("$output_dir/$(location)/amin_scatterplot_DIN.png")
        tight_layout()
        plt.close()
    
        IQN_10_aamp = mean(IQN_10_amp, dims=3)[:, :]
        scttr = scatter_means(IQN_10_aamp)
        xlabel("μ Mouse")
        ylabel("DIN")
        savefig("$output_dir/$(location)/aamp_scatterplot_DIN.png")
        tight_layout()
        plt.close()
    
        #! DON
        # IQN_10_amean = mean(QN_10_avg .+ IQN_10_avg, dims=3)[:, :]
        # scttr = scatter_means(IQN_10_amean)
        # xlabel("μ Mouse")
        # ylabel("DON")
        # savefig("$output_dir/$(location)/amean_scatterplot_DON.png")
        # tight_layout()
        # plt.close()
    
        IQN_10_amean = mean(QN_10_avg .+ IQN_10_avg, dims=3)[:, :]
        scttr = scatter_means(IQN_10_amean)
        xlabel("μ Mouse")
        ylabel("DON")
        savefig("$output_dir/$(location)/amean_scatterplot_DON.png")
        tight_layout()
        plt.close()
    
        IQN_10_amax = mean(TOT_QN_10_max, dims=3)[:, :]
        scttr = scatter_means(IQN_10_amax)
        xlabel("μ Mouse")
        ylabel("DON")
        savefig("$output_dir/$(location)/amax_scatterplot_DON.png")
        tight_layout()
        plt.close()
    
        IQN_10_amin = mean(TOT_QN_10_min, dims=3)[:, :]
        scttr = scatter_means(IQN_10_amin)
        xlabel("μ Mouse")
        ylabel("DON")
        savefig("$output_dir/$(location)/amin_scatterplot_DON.png")
        tight_layout()
        plt.close()
    
        IQN_10_aamp = mean(TOT_10_amp, dims=3)[:, :]
        scttr = scatter_means(IQN_10_aamp)
        xlabel("μ Mouse")
        ylabel("DON")
        savefig("$output_dir/$(location)/aamp_scatterplot_DON.png")
        tight_layout()
        plt.close()
    
        #! NIP
        IQN_10_amean = mean(IQN_10_avg./(QN_10_avg .+ IQN_10_avg), dims=3)[:, :]
        scttr = scatter_means(IQN_10_amean)
        xlabel("μ Mouse")
        ylabel("NIP")
        savefig("$output_dir/$(location)/amean_scatterplot_NIP.png")
        tight_layout()
        plt.close()
    
        IQN_10_amax = mean(TOT_NIP_10_max, dims=3)[:, :]
        scttr = scatter_means(IQN_10_amax)
        xlabel("μ Mouse")
        ylabel("NIP")
        savefig("$output_dir/$(location)/amax_scatterplot_NIP.png")
        tight_layout()
        plt.close()
    
        IQN_10_amin = mean(TOT_NIP_10_min, dims=3)[:, :]
        scttr = scatter_means(IQN_10_amin)
        xlabel("μ Mouse")
        ylabel("NIP")
        savefig("$output_dir/$(location)/amin_scatterplot_NIP.png")
        tight_layout()
        plt.close()
    
        IQN_10_aamp = mean(TOT_NIP_10_amp, dims=3)[:, :]
        scttr = scatter_means(IQN_10_aamp)
        xlabel("μ Mouse")
        ylabel("NIP")
        savefig("$output_dir/$(location)/aamp_scatterplot_NIP.png")
        tight_layout()
        plt.close()
    
        ##! -- Scatterplot of Variance
        
        #! DIN
        IQN_10_amean = mean(IQN_10_avg, dims=3)[:, :]
        scttr = scatter_variances(IQN_10_amean)
        xlabel("σ Mouse")
        ylabel("DIN")
        savefig("$output_dir/$(location)/variance_scatterplot_DIN.png")
        tight_layout()
        plt.close()
    
        IQN_10_amax = mean(IQN_10_max, dims=3)[:, :]
        scttr = scatter_variances(IQN_10_amax)
        xlabel("σ Mouse")
        ylabel("DIN")
        savefig("$output_dir/$(location)/maxvariance_scatterplot_DIN.png")
        tight_layout()
        plt.close()
    
        IQN_10_amin = mean(IQN_10_min, dims=3)[:, :]
        scttr = scatter_variances(IQN_10_amin)
        xlabel("σ Mouse")
        ylabel("DIN")
        savefig("$output_dir/$(location)/minvariance_scatterplot_DIN.png")
        tight_layout()
        plt.close()
    
        IQN_10_aamp = mean(IQN_10_amp, dims=3)[:, :]
        scttr = scatter_variances(IQN_10_aamp)
        xlabel("σ Mouse")
        ylabel("DIN")
        savefig("$output_dir/$(location)/ampvariance_scatterplot_DIN.png")
        tight_layout()
        plt.close()
    
        #! DON
        IQN_10_amean = mean(QN_10_avg .+ IQN_10_avg, dims=3)[:, :]
        scttr = scatter_variances(IQN_10_amean)
        xlabel("σ Mouse")
        ylabel("DON")
        savefig("$output_dir/$(location)/variance_scatterplot_DON.png")
        tight_layout()
        plt.close()
    
        IQN_10_amax = mean(TOT_QN_10_max, dims=3)[:, :]
        scttr = scatter_variances(IQN_10_amax)
        xlabel("σ Mouse")
        ylabel("DON")
        savefig("$output_dir/$(location)/maxvariance_scatterplot_DON.png")
        tight_layout()
        plt.close()
    
        IQN_10_amin = mean(TOT_QN_10_min, dims=3)[:, :]
        scttr = scatter_variances(IQN_10_amin)
        xlabel("σ Mouse")
        ylabel("DON")
        savefig("$output_dir/$(location)/minvariance_scatterplot_DON.png")
        tight_layout()
        plt.close()
    
        IQN_10_aamp = mean(TOT_10_amp, dims=3)[:, :]
        scttr = scatter_variances(IQN_10_aamp)
        xlabel("σ Mouse")
        ylabel("DON")
        savefig("$output_dir/$(location)/ampvariance_scatterplot_DON.png")
        tight_layout()
        plt.close()
        
        #! NIP
        IQN_10_amean = mean(IQN_10_avg./(QN_10_avg .+ IQN_10_avg), dims=3)[:, :]
        scttr = scatter_variances(IQN_10_amean)
        xlabel("σ Mouse")
        ylabel("NIP")
        savefig("$output_dir/$(location)/variance_scatterplot_NIP.png")
        tight_layout()
        plt.close()
    
        IQN_10_amax = mean(TOT_NIP_10_max, dims=3)[:, :]
        scttr = scatter_variances(IQN_10_amax)
        xlabel("σ Mouse")
        ylabel("NIP")
        savefig("$output_dir/$(location)/maxvariance_scatterplot_NIP.png")
        tight_layout()
        plt.close()
    
        IQN_10_amin = mean(TOT_NIP_10_min, dims=3)[:, :]
        scttr = scatter_variances(IQN_10_amin)
        xlabel("σ Mouse")
        ylabel("NIP")
        savefig("$output_dir/$(location)/minvariance_scatterplot_NIP.png")
        tight_layout()
        plt.close()
    
        IQN_10_aamp = mean(TOT_NIP_10_amp, dims=3)[:, :]
        scttr = scatter_variances(IQN_10_aamp)
        xlabel("σ Mouse")
        ylabel("NIP")
        savefig("$output_dir/$(location)/ampvariance_scatterplot_NIP.png")
        tight_layout()
        plt.close()
        
        ## -- heatmap
        
        #! DIN
        IQN_10_amean = mean(IQN_10_avg, dims=3)[:, :]
        imshow(IQN_10_amean, cmap="cividis", interpolation="nearest", origin="lower")
        xlabel("σ Mouse")
        ylabel("μ Mouse")
        colorbar(label="DIN")
        savefig("$output_dir/$(location)/heatmap_DIN.png")
        tight_layout()
        plt.close()
    
        IQN_10_amax = mean(IQN_10_max, dims=3)[:, :]
        imshow(IQN_10_amax, cmap="cividis", interpolation="nearest", origin="lower")
        xlabel("σ Mouse")
        ylabel("μ Mouse")
        colorbar(label="DIN")
        savefig("$output_dir/$(location)/maxheatmap_DIN.png")
        tight_layout()
        plt.close()
    
        IQN_10_amin = mean(IQN_10_min, dims=3)[:, :]
        imshow(IQN_10_amin, cmap="cividis", interpolation="nearest", origin="lower")
        xlabel("σ Mouse")
        ylabel("μ Mouse")
        colorbar(label="DIN")
        savefig("$output_dir/$(location)/minheatmap_DIN.png")
        tight_layout()
        plt.close()
    
        IQN_10_aamp = mean(IQN_10_aamp, dims=3)[:, :]
        imshow(IQN_10_aamp, cmap="cividis", interpolation="nearest", origin="lower")
        xlabel("σ Mouse")
        ylabel("μ Mouse")
        colorbar(label="DIN")
        savefig("$output_dir/$(location)/ampheatmap_DIN.png")
        tight_layout()
        plt.close()
    
        #! DON
        IQN_10_amean = mean(QN_10_avg .+ IQN_10_avg, dims=3)[:, :]
        imshow(IQN_10_amean, cmap="cividis", interpolation="nearest", origin="lower")
        xlabel("σ Mouse")
        ylabel("μ Mouse")
        colorbar(label="DON")
        savefig("$output_dir/$(location)/heatmap_DON.png")
        tight_layout()
        plt.close()
    
        IQN_10_amax = mean(TOT_QN_10_max, dims=3)[:, :]
        imshow(IQN_10_amax, cmap="cividis", interpolation="nearest", origin="lower")
        xlabel("σ Mouse")
        ylabel("μ Mouse")
        colorbar(label="DON")
        savefig("$output_dir/$(location)/maxheatmap_DON.png")
        tight_layout()
        plt.close()
    
        IQN_10_amin = mean(TOT_QN_10_min, dims=3)[:, :]
        imshow(IQN_10_amin, cmap="cividis", interpolation="nearest", origin="lower")
        xlabel("σ Mouse")
        ylabel("μ Mouse")
        colorbar(label="DON")
        savefig("$output_dir/$(location)/minheatmap_DON.png")
        tight_layout()
        plt.close()
    
        IQN_10_aamp = mean(TOT_10_amp, dims=3)[:, :]
        imshow(IQN_10_aamp, cmap="cividis", interpolation="nearest", origin="lower")
        xlabel("σ Mouse")
        ylabel("μ Mouse")
        colorbar(label="DON")
        savefig("$output_dir/$(location)/ampheatmap_DON.png")
        tight_layout()
        plt.close()
    
        #! NIP
        IQN_10_amean = mean(IQN_10_avg./(QN_10_avg .+ IQN_10_avg), dims=3)[:, :]
        imshow(IQN_10_amean, cmap="cividis", interpolation="nearest", origin="lower")
        xlabel("σ Mouse")
        ylabel("μ Mouse")
        colorbar(label="NIP")
        savefig("$output_dir/$(location)/heatmap_NIP.png")
        tight_layout()
        plt.close()
    
        IQN_10_amax = mean(TOT_NIP_10_max, dims=3)[:, :]
        imshow(IQN_10_amax, cmap="cividis", interpolation="nearest", origin="lower")
        xlabel("σ Mouse")
        ylabel("μ Mouse")
        colorbar(label="NIP")
        savefig("$output_dir/$(location)/maxheatmap_NIP.png")
        tight_layout()
        plt.close()
    
        IQN_10_amin = mean(TOT_NIP_10_min, dims=3)[:, :]
        imshow(IQN_10_amin, cmap="cividis", interpolation="nearest", origin="lower")
        xlabel("σ Mouse")
        ylabel("μ Mouse")
        colorbar(label="NIP")
        savefig("$output_dir/$(location)/minheatmap_NIP.png")
        tight_layout()
        plt.close()
    
        IQN_10_aamp = mean(TOT_NIP_10_amp, dims=3)[:, :]
        imshow(IQN_10_aamp, cmap="cividis", interpolation="nearest", origin="lower")
        xlabel("σ Mouse")
        ylabel("μ Mouse")
        colorbar(label="NIP")
        savefig("$output_dir/$(location)/ampheatmap_NIP.png")
        tight_layout()
        plt.close()
    
    end