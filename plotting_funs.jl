function plot_amean_boxplot(data, labels)
    
    no_var = mean(data[:, 1, :], dims=2)
    variance = mean(data[:, 2:end, :], dims=3)

    no_var = reshape(no_var, (length(no_var), 1))[:, 1]
    variance = reshape(variance, (length(variance), 1))[:, 1]

    bxplt = boxplot( [ no_var,  variance], labels=labels, whis=[0, 100])

    return bxplt

end

function plot_mean_boxplot(data)

    no_var = (data[:, 1, :])
    variance = (data[:, 2:end, :])

    no_var = reshape(no_var, (length(no_var), 1))[:, 1]
    variance = reshape(variance, (length(variance), 1))[:, 1]

    bxplt = boxplot( [ no_var,  variance], whis=[0, 100])

    return bxplt

end

function plot_amean_location_boxplot(location_data, locations_fact, labels)

    plot_dat = []
    for data in location_data

        no_var = mean(data[:, 1, :], dims=2)
        variance = mean(data[:, 35:67, :], dims=3)

        # subtract no_var vector from each column of variance matrix
        # variance = variance .- no_var

        no_var = reshape(no_var, (length(no_var), 1))[:, 1]
        variance = reshape(variance, (length(variance), 1))[:, 1]


        push!(plot_dat, no_var)
        push!(plot_dat, variance)
        
    end

    grouped_loc = []
    # collect data of same factor into location by location box plots
    for loc_factor in [4:-1:1;]
            
        # get data for this location
        data = location_data[findall(locations_fact .== loc_factor)]
        print(labels[findall(locations_fact .== loc_factor)], " location \n")
        num_locs = length(data)

        location_no_var = zeros(0)
        location_variance = zeros(0)
        for loc in data
            no_var = mean(loc[:, 1, :], dims=2)
            variance = mean(loc[:, 35:67, :], dims=3)
            
            # append to location_no_var and location_variance
            append!(location_no_var, no_var)
            append!(location_variance, variance)
        end
        # push to grouped_loc
        push!(grouped_loc, location_no_var)
        push!(grouped_loc, location_variance)
    end

    # start figure
    fig, ax = subplots(1, 2, figsize=(10, 10))
   
    bxplt1 = ax[1].boxplot(
        plot_dat, whis=[0, 100],
        patch_artist=true, vert=false) # labels=labels
    # xticks(rotation=270)
    bxplt2 = ax[2].boxplot(
        grouped_loc, whis=[0, 100],
        patch_artist=true, vert=false,
        positions=[3.5, 7.5, 15.5, 19.5, 27.5, 31.5, 37.5, 41.5],
        widths=2.5) # labels=labels

    colors = ["#56B4E9", "#F0E442"]
    # set to 1 if odd, 2 if even
    odd_even = 1
    for patch in bxplt1["boxes"]
        patch.set_facecolor(colors[odd_even])
        if odd_even == 1
            odd_even = 2
        else
            odd_even = 1
        end
    end

    odd_even = 1
    for patch in bxplt2["boxes"]
        patch.set_facecolor(colors[odd_even])
        if odd_even == 1
            odd_even = 2
        else
            odd_even = 1
        end
    end

    tight_layout()

    return fig, ax

end

function scatter_means(data)

    fig, ax = subplots()

    if length(size(data)) != 3
        x = repeat(collect(0:size(data)[1]-1), inner=size(data)[2])
        #! transpose data to reshape by row instead of by col.
        y = reshape(transpose(data), (length(data), 1))[:, 1]
        c = repeat(collect(1:size(data)[2]), outer=size(data)[1])
        print(size(x), " \n")
        print(size(y), " \n")
        print(size(c), " \n")
        
        img = ax.scatter(x, y, c=c, s = 5)
        
        colorbar(img, label = "σ Mouse")
        # for row in 1:size(data)[1]
        #     ax.scatter(ones(size(data)[2]) * (row - 1), data[row, :], c=1:size(data)[2], s = 5)
        # end
    else
        for row in 1:size(data)[1]
            ax.scatter(ones(size(data)[2], size(data)[3]) * (row - 1), data[row, :, :], c=1:(size(data)[2]*size(data)[3]), s = 5)
        end
    end
    # plot(1:size(IQN_10_avg)[1], IQN_10_avg[:, 40], color = "black")

    return ax

end

function scatter_variances(data)

    fig, ax = subplots()

    if length(size(data)) != 3
        x = repeat(collect(0:size(data)[2]), inner=size(data)[2])
        y = reshape((data), (length(data), 1))[:, 1]
        c = repeat(collect(1:size(data)[2]), outer=size(data)[2])
        print(size(x), " \n")
        print(size(y), " \n")
        print(size(c), " \n")
        
        img = ax.scatter(x, y, c=c, s = 5)
        
        colorbar(img, label="μ Mouse")
        
        # for col in 1:size(data)[2]
        #     ax.scatter(ones(size(data)[1]) * (col - 1), data[:, col], c=1:size(data)[1], s = 5)
        # end
    else
        for col in 1:size(data)[2]
           ax.scatter(ones(size(data)[1], size(data)[3]) * (col - 1), data[:, col, :], c=1:(size(data)[1]*size(data)[3]), s = 5)
        end
    
    end
    # plot(1:size(IQN_10_avg)[2], IQN_10_avg[40, :], color = "black")

    return ax

end

function reshape_matrix(data; dims = (100, 100, 10))

    output = zeros(dims)

    for i in 1:dims[1]
        for j in 1:dims[2]
            row = (i - 1) * 100 + j
            output[i, j, :] = data[row, :]
        end
    end

    return output

end

#! Take matrix 100 by 100 and reshape to be (10000, 3)
#! so columns are (mean, variance, value)
function reshape_matrix_longer(data; dims = (100, 100))

    output = zeros(dims[1] * dims[2], 3)

    for i in 1:dims[1]
        for j in 1:dims[2]
            row = (i - 1) * dims[2] + j
            #! column 1 is mean, column 2 is variance, column 3 is value
            output[row, :] = [i-1, j-1, data[i, j]]
        end
    end

    return output

end