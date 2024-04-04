## --

using Statistics, GLM, CSV, DataFrames, Tables, PyPlot; pygui(true)
include("plotting_funs.jl")

## --

μ_vec = [0:1:99;]
σ_vec = [0:1:99;]

## --
input_dir = "Analysis_Data"
output_dir = "Analysis_Data/Exploratory_Plots/"


# locations = [
#     "PortlandME_1971-2021", "BostonMA_1971-2021", "ConcordNH_1971-2021", "AugustaGA_1971-2021", 
#     "BurlingtonVT_1971-2021", "AlbanyNY_1971-2021", "WashingtonDC_1971-2021", "NorfolkVA_1971-2021",
#     "RaleighNC_1971-2021", "AshevilleTN_1971-2021", "RochesterNY_1971-2021", "PittsburghPA_1971-2021",
#     "ClevelandOH_1971-2021", "ColumbusOH_1971-2021", "DetroitMI_1971-2021", 
#     "TopekaKS_1971-2021", "DallasFortWorthTX_1971-2021", "MinneapolisMN_1971-2021", 
#     "BismarkND_1971-2021", "DenverCO_1971-2021", "JacksonMS_1971-2021", "StLouisMO_1971-2021"]


locations_grouped = [
        "PortlandME_1971-2021", "BostonMA_1971-2021", "ConcordNH_1971-2021", "BurlingtonVT_1971-2021", "AlbanyNY_1971-2021",
        "RochesterNY_1971-2021", "PittsburghPA_1971-2021", "ClevelandOH_1971-2021", "ColumbusOH_1971-2021", "DetroitMI_1971-2021",
        "WashingtonDC_1971-2021", "NorfolkVA_1971-2021", "RaleighNC_1971-2021", "AshevilleTN_1971-2021", "AugustaGA_1971-2021",
        "JacksonMS_1971-2021", "StLouisMO_1971-2021", 
        "BismarkND_1971-2021", "MinneapolisMN_1971-2021", "DenverCO_1971-2021", "TopekaKS_1971-2021", "DallasFortWorthTX_1971-2021",
    ]
locations_grouped = reverse(locations_grouped)

# location factor array
locations_fact = [
    4, 4, 4, 4, 4, 3, 3, 3, 3, 3, 3, 3, 
    2, 2, 2, 2, 2, 1, 1, 1, 1, 1]

# locations_fact = reverse(locations_fact)


# for location in locations_grouped

#     mkdir("Analysis_Data/Exploratory_Plots/$location/")

# end

## --

#! heatmaps of locations by latitude and longitude

locations_lat_long = [
    "BismarkND_1971-2021", "AlbanyNY_1971-2021", "BurlingtonVT_1971-2021", "ConcordNH_1971-2021", "PortlandME_1971-2021", 
    "BostonMA_1971-2021", 
    "MinneapolisMN_1971-2021", "DetroitMI_1971-2021", "ColumbusOH_1971-2021", "ClevelandOH_1971-2021", "PittsburghPA_1971-2021",
    "RochesterNY_1971-2021", 
    "DenverCO_1971-2021", "TopekaKS_1971-2021", "WashingtonDC_1971-2021", "NorfolkVA_1971-2021", "AshevilleTN_1971-2021", "RaleighNC_1971-2021",
    "DallasFortWorthTX_1971-2021", "JacksonMS_1971-2021", "StLouisMO_1971-2021", "AugustaGA_1971-2021", 
]

