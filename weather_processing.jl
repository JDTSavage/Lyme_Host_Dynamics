## Joseph Savage
# March 15 2022
# This is a script for processing long term weather data from : https://kilthub.cmu.edu/articles/dataset/Compiled_daily_temperature_and_precipitation_data_for_the_U_S_cities/7890488

## Weeklyizing the data, removing NAs
using Dates, TimeSeries, Statistics, DataFrames, CSV

# Read in raw data csv.
RAW_location = "RochesterNY"
raw_weather = "Input_Data/RAW_WEATHER/$RAW_location.csv"
RAW_WEATHER_DATA = CSV.read(raw_weather, DataFrame, types=Dict(1=>Int64, 2=>Date, 3=>Float64, 4=>Float64, 5=>Float64));

# Filter out dates from 1971-01-01 - 2021-12-31
FILTERED_RAW_WEATHER_DATA = RAW_WEATHER_DATA[RAW_WEATHER_DATA[:, "Date"] .>= Dates.Date("1971-01-01"), :] #1971-01-01 ---  2021-12-31
T_AND_P = FILTERED_RAW_WEATHER_DATA[:, 2:5]

# computer average temp from min and max, covert to celsius
T_AND_P[!, :Temp] = (((T_AND_P[:, :tmax] .+ T_AND_P[:, :tmin]) ./ 2) .- 32) .* 5 ./9

# deal with missing data in Temp and precipitation before converting to TimeArray
for i in 1:length(T_AND_P[:, :Temp])

    if (ismissing(T_AND_P[i, :Temp]))
        
        # search left and right to find average values. 
        j = i
        k = i
        foundj = false
        foundk = false
        endj = false
        endk = false
        # find non missing values
        while !foundj || !foundk
            
            if !ismissing(T_AND_P[j, :Temp])
                foundj = true
            end

            if !ismissing(T_AND_P[k, :Temp])
                foundk = true
            end
            if j-1 > 0 && endk === false && !foundj
                j-=1
            elseif !foundj
                j+=1
                endj = true
            end
            if k+1 <=  length(T_AND_P[:, :Temp]) && endk === false && !foundk
                k+=1
            elseif !foundk
                k-=1
                endk = true
            end

            if k <= j
                print(j, " \n")
                # stop()
            end

        end
        
        # average out
        T_AND_P[i, :Temp] = (T_AND_P[j, :Temp] + T_AND_P[k, :Temp])/2

        print(i, " new temp ", T_AND_P[i, :Temp], " \n")
        
    end

    # none showed missing for prcp augusta
    if (ismissing(T_AND_P[i, :prcp]))
        # search left and right to find average values. 
        j = i
        k = i
        foundj = false
        foundk = false
        endj = false
        endk = false
        # find non missing values
        while !foundj || !foundk
            
            if !ismissing(T_AND_P[j, :prcp])
                foundj = true
            end

            if !ismissing(T_AND_P[k, :prcp])
                foundk = true
            end

            if j-1 > 0 && endj === false && !foundj
                j-=1
            elseif !foundj
                j+=1
                endj = true
            end
            if k+1 <= length(T_AND_P[:, :Temp]) && endk === false && !foundk
                k+=1
            elseif !foundk
                k-=1
                endk = true
            end

            if k <= j
                print(j, " \n")
                # stop()
            end

        end
        
        # average out
        T_AND_P[i, :prcp] = (T_AND_P[j, :prcp] + T_AND_P[k, :prcp])/2

        print(i, " new prcp ", T_AND_P[i, :prcp], " \n")
    end    
end

# Time array allows easy collapsing by week!
T_AND_P = TimeArray(T_AND_P, timestamp = :Date)

T_AND_P = collapse(T_AND_P,week,first,mean)

T_AND_P = DataFrame(T_AND_P)

# calculate precipitation index
PI = zeros(length(T_AND_P[:, :prcp]))
PI[1] = T_AND_P[1, :prcp]
for i in 2:length(PI)
    PI[i] = T_AND_P[i, :prcp]/10 + PI[i-1] * 0.65 
end

T_AND_P[!, :PrecI] = PI

FINAL_WEATHER = T_AND_P[2:end-1, :]

# Check to confirm no NAs
# for i in 1:length(FINAL_WEATHER[:, :Temp])

#     if (ismissing(FINAL_WEATHER[i, :Temp]))
#         print(i, " \n")
#     end

# end

CSV.write("Input_Data/$(RAW_location)_1971-2021.csv", (FINAL_WEATHER), writeheader=true)

# isfile("R:/honors_thesis/Output_Data/Mice/mice_0_0_AlbanyNY_1971-2021_standard.csv")
#! Notes on files: # ? FIll these out!!!!!
# * Portland ME: Station ID: USW00014764
# * Manchester NH: Station ID : USW00014710
# * Augusta GA: 5 missing values for temperature idx: [9572, 9573, 9921, 9923] Station ID : USW00003820
