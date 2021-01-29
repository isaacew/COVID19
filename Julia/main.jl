#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# PROGRAM NAME: main.jl
# DESCRIPTION:  This program reads the most recent data from
#               the CDC and plots for data visualization purposes
# AUTHOR:       Isaac Weintraub Jan 2021
# VERSION	0.1
# REQ.PACKAGES:	CSV
#
#
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
cd("/Users/weintraub0/Documents/Projects/COVID19/COVID-19")
run(`git pull`)    # Get the latest data
cd("/Users/weintraub0/Documents/Projects/COVID19/")
using CSV           # Need to read the CSV data
using Plots         # Allows the genation of plots
using DataFrames
#using Pandas
include("covidPlot2.jl")
pyplot()
# reading the csv file
data_popStates = CSV.read("USA.csv", DataFrame)    # Read the population data from the united states
data_casesUSA  = CSV.read("COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv", DataFrame)
data_deathUSA  = CSV.read("COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_US.csv", DataFrame)

data_popStates.Province .== "Ohio"
n = size(data_popStates.Province,1); # Number to search through

for state in data_popStates.Province
    println(state)
    casesDF = data_casesUSA[data_casesUSA.Province_State .== state,:]   # cases
    deathDF = data_deathUSA[data_deathUSA.Province_State .== state,:]   # deaths
    popDF   = data_popStates[data_popStates.Province .== state,:]
    cases = casesDF[:,12:end]
    death = deathDF[:,12:end]
    popState   = popDF[1,2]
    casesArray = convert(Array, cases[1:end,:])
    casesState = sum(casesArray,dims=1)
    deathArray = convert(Array, cases[1:end,:])
    deathState = sum(deathArray,dims=1)
    covidPlot2(casesState,deathState,popState,state)
end


#data_casesUSA   = CSV.read("COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv",header=true)       # cases of COVID 19 in the USA
#data_deathUSA   = CSV.read("COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_US.csv",header=true)          # deaths in the USA from COVID 19
#data_casesGlobe = CSV.read("COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv",header=true)   # casess of COVID 19 around the globe
#data_deathGlobe = CSV.read("COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv",header=true)      # deaths in the Globe from COVID 19
#data_recovGlobe = CSV.read("COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv",header=true)   # recovered global COVID 19 Cases
#data_populGlobe = CSV.read("population/data/population.csv",header=true) # get the population data
# data_casesUSAstateList = data_casesUSA[:,7]       # Gather a list of all the states
# countryList = unique(data_populGlobe[:,1]) # Remove Duplicates
#
# n = size(countryList)[1]
# global casesC
# global deathC
# global recovC
# @showprogress 0.01 for i = 1:n              # show a progress meter and for loop through the countries
#     countryName = countryList[i]
#         year = maximum(data_populGlobe[data_populGlobe[:,1].==countryName,3])
#         select = data_populGlobe[:,1].==countryName
#         index = data_populGlobe[select,3].==year
#         selectPopulations = data_populGlobe[select,4]
#     countryPopulation = selectPopulations[index][1]
#     if countryName == "United States"
#         countryName = "US"
#     end
#     if sum(data_casesGlobe[:,2] .== countryName) > 0
#         #print(countryName*"\n")
#         index = data_casesGlobe[:,2] .== countryName
#
# 		cases = data_casesGlobe[index,5:end]
# 		death = data_deathGlobe[index,5:end]
# 		#recov = data_recovGlobe[index,5:end]
#
#         casesMatrix = convert(Array, cases[1:end,:])
#         deathMatrix = convert(Array, death[1:end,:])
# 		#recovMatrix = convert(Array, recov[1:end,:])
#
# 		countryCases = sum(casesMatrix,dims=1)
# 		countryDeath = sum(deathMatrix,dims=1)
# 		#countryRecov = sum(recovMatrix,dims=1)
# 		#covidPlot1(countryCases,countryPopulation,countryName) 	# Plot the Covid Data
# 		covidPlot2(countryCases,countryDeath,countryPopulation,countryName)
#     end
# end
#
#
# n = size(data_popStates)[1]                  # the number of provinces and states of the USA
# global USACases
# global USApop
# global USADeaths
# @showprogress 0.01 for i = 1:n               # show a progress meter and for loop through the states
#     stateName        = data_popStates[i,1]          # get the name of the current state (STRING)
#     statePopulation  = data_popStates[i,2]          # get the population of the current state (FLOAT)
#     index            = data_casesUSA[:,7] .== stateName   # get the subset of indexies whicih corespond to data for that state
#     stateCases       = data_casesUSA[index,12:end]  # parse the subset of the data for the state of interest
#     stateDeaths      = data_deathUSA[index,12:end]             # Gather the deaths
#     stateCaseMatrix  = convert(Array, stateCases[1:end,:])              # Conver the data to a matrix for manipulation reasons
#     stateDeathMatrix = convert(Array, stateDeaths[1:end,:])    # Convert the deat data to a matrix for manipulation reasons
#     stateCases       = sum(stateCaseMatrix,dims=1)              # summing is easier as a matrix than as a data frame NEED THE TOTAL NUMBER OF CASES in each state
#     stateDeathCases  = sum(stateDeathMatrix,dims=1)    # summing of the deaths
#     global USACases
#     global USApop
#     global USADeaths
#     if i == 1
#         USACases  = stateCases
#         USADeaths = stateDeathCases
#         USApop    = statePopulation
#     elseif i > 2
#         USACases  = USACases .+ stateCases
#         USADeaths = USADeaths .+ (stateDeathCases)
#         USApop    = USApop .+ statePopulation
#     end
#     # Plot the current state or provices
#     p1 = plot()
#     hspan!(p1,[0,1e2], color  = :red, alpha   = 0.6, labels = false);
#     hspan!(p1,[0,1e1], color  = :white, alpha = 0.1, labels = false);
#     hspan!(p1,[0,1e0], color  = :white, alpha = 0.1, labels = false);
#     hspan!(p1,[0,1e-1], color = :white, alpha = 0.1, labels = false);
#     hspan!(p1,[0,1e-2], color = :white, alpha = 0.1, labels = false);
#     hspan!(p1,[0,1e-3], color = :white, alpha = 0.1, labels = false);
#     hspan!(p1,[0,1e-4], color = :white, alpha = 0.1, labels = false);
#     hspan!(p1,[0,1e-5], color = :white, alpha = 0.1, labels = false);
#     hspan!(p1,[0,1e-6], color = :white, alpha = 0.1, labels = false);
#     scatter!(1:size(stateCases)[2],
#         100*stateCases[1,:]./statePopulation,lab=stateName*" COVID Cases",
#         scale=:log10,
#         yticks = [1e-6,1e-5,1e-4,1e-3,1e-2,1e-1,1,1e1,1e2],
#         yaxis="Percent of State", xaxis="Days since Jan 22",
#         marker =:o,
#         color =:red)
#     scatter!(1:size(stateDeathCases)[2],
#         100*stateDeathCases[1,:]./statePopulation,lab=stateName*" COVID Deaths",
#         scale=:log10,
#         yticks = [1e-6,1e-5,1e-4,1e-3,1e-2,1e-1,1,1e1,1e2],
#         yaxis="Percent of State", xaxis="Days since Jan 22",
#         marker =:x,
#         color=:black)
#     plot!(xscale=:identity,xticks=0:10:100)
#     xlims!((0,100))
#     ylims!((1e-6,100))
#     png(p1,"StateFigures/$stateName.png")
# end
# # PLOT THE UNITED STATES PLOT FOR ALL THE CASES IN THE USA USING STATE/PROVINCE DATA
# p2 = plot()
# hspan!(p2,[0,1e2], color  = :red, alpha   = 0.6, labels = false);
# hspan!(p2,[0,1e1], color  = :white, alpha = 0.1, labels = false);
# hspan!(p2,[0,1e0], color  = :white, alpha = 0.1, labels = false);
# hspan!(p2,[0,1e-1], color = :white, alpha = 0.1, labels = false);
# hspan!(p2,[0,1e-2], color = :white, alpha = 0.1, labels = false);
# hspan!(p2,[0,1e-3], color = :white, alpha = 0.1, labels = false);
# hspan!(p2,[0,1e-4], color = :white, alpha = 0.1, labels = false);
# hspan!(p2,[0,1e-5], color = :white, alpha = 0.1, labels = false);
# hspan!(p2,[0,1e-6], color = :white, alpha = 0.1, labels = false);
# scatter!(1:size(USACases)[2],100*USACases[1,:]./USApop,lab="USA",
#      scale=:log10,
#      yticks = [1e-6,1e-5,1e-4,1e-3,1e-2,1e-1,1,1e1,1e2],
#      yaxis="Percent of USA Pop", xaxis="Days since Jan 22",
#      marker=:o)
# plot!(xscale=:identity,xticks=0:10:100)
# xlims!((0,100))
# ylims!((1e-6,100))
# png(p2,"StateFigures/USA.png")
# print("Done")
