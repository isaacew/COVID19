#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Dec 15 11:21:09 2020

@author: weintraub0
"""

# Import the packages that I commonly need
import os                # Necessary to run system commands
import csv               # Necessary to read the csv files
import pandas as pd      # Necessary for reading in data
import numpy as np       # 
import scipy as sp       #
import matplotlib as mpl #
import matplotlib.pyplot as plt #

# Commands for GIT Tracking
os.system('cd COVID-19')
os.system('git pull')
os.system('cd /Users/weintraub0/Documents/Projects/COVID19')
os.system('git submodule update --remote')

# FLAGS FOR Operation
Flag_plot = True;
Flag_usa = True;
Flag_country = True;
Flag_statePlot = True;

# Import the data which was just updated
pops       = pd.read_csv('populationData/data/population.csv')
cases      = pd.read_csv('COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv')
deaths     = pd.read_csv('COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv') 
recovered  = pd.read_csv('COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv') 
states     = pd.read_csv('COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv')
statesD    = pd.read_csv('COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_US.csv')
popStates  = pd.read_csv('USA.csv')
    
stateNames = popStates.iloc[:,0] # Gather a vector of the state names
countryName = cases.iloc[:,1]   # Gather a list of all the countries 

stateNamesStr = stateNames.values
if Flag_statePlot:
    print('United States Plots')
    for f in range(0,10+0*np.size(stateNamesStr)):
        name       = popStates.values[f,0] # - Name of Each State
        population = popStates.values[f,1] # - Populations of Each State
        isState = states.Province_State == name
        #stateData = states.iloc[isState,11:]
        data = states.loc[states.Province_State.values == name]
        cases = data.iloc[:,11:]
        stateCases = np.sum(cases)
        
        data = statesD.loc[statesD.Province_State == name,:]
        deaths = data.iloc[:,11:]
        stateDeaths = np.sum(deaths[1:])
        
        fig, ax = plt.subplots()
        ax.semilogy(stateCases/population)
        ax.set(xlabel='time (s)', ylabel='percent of infected',
        title=name)
        ax.grid()
        #fig.savefig("test.png")
        
        
        ax.semilogy(stateDeaths[2:]/population)
        ax.set(xlabel='time (s)', ylabel='number of deaths',
        title=name)
        ax.grid()
        ax.set_ylim([1e-8,1])
        #fig.savefig("test.png")
        plt.show()

# if statePlot
# for i = 1:length(State)
#     fig86 = figure(86);
#     stateName = State(i);
#     stateName = stateName{1};
#     popState = popStates.data(i,1);
#     isState = strcmp(Province,stateName);
#     isState = isState(2:end);
#     stateData = states.data(isState,:);
#     stateDataDeath = statesD.data(isState,:);
#     casesState = sum(stateData,1);
#     casesStateD = sum(stateDataDeath,1);
#     %myPlot3(stateName,popState,casesState,casesStateD,[],"UnitedStates");
# end



