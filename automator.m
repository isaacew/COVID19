%--------------------------------------------------------------------------
% Automator.m
%
% Description: This program first pulls the most recent data from Johns
% Hopkins' Github account which contains the most up to date CDC and WHO
% data. Using this data, a parser is used to gather the data for a country
% or province of interest. Plots are created to visulize the current
% outbreak of COVID19.
%  
% Author: Isaac Weintraub
%--------------------------------------------------------------------------
clear 
clc
close all

% Pull the most up-to-date information
!git submodule update --remote
[status cmdout] =  git('submodule update --remote');
% if status = 0
%     disp('Nothing New Reported')
% elseif status == 1
%     disp('Error Detected: Invalid Commmand');
% else
tic
statePlot = 1;
% Import the data from CSV format to matlab cell or matrix 
pops      = importdata("populationData/data/population.csv");
cases     = importdata("JohnsHopkinsData/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv");
deaths    = importdata("JohnsHopkinsData/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv");
recovered = importdata("JohnsHopkinsData/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv");
states    = importdata("JohnsHopkinsData/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv");
statesD    = importdata("JohnsHopkinsData/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_US.csv");
popStates = importdata("USA.csv");
% Gather a list of countries and provinces
Country_cas = cases.textdata(:,2);
Country_dea = deaths.textdata(:,2);
Country_rec = recovered.textdata(:,2);
Province = states.textdata(:,7);
ProvinceD = statesD.textdata(:,7);

State = popStates.textdata(2:end,1);

% Display the Country List Allow User to Select Country of Interest
CountryShort = unique(Country_cas);
ProvinceShort = unique(Province);

if statePlot
for i = 1:length(State)
    stateName = State(i);
    stateName = stateName{1};
    popState = popStates.data(i,1);
    isState = strcmp(Province,stateName);
    isState = isState(2:end);
    stateData = states.data(isState,:);
    stateDataDeath = statesD.data(isState,:);
    casesState = sum(stateData,1);
    casesStateD = sum(stateDataDeath,1);
    close all
    plot2(stateName,popState,casesState,casesStateD,[],"UnitedStates");
end
end
%
maxCountry = 0;
maxCountryName = '';
i = 1;
    % Parse through all countries
    countryNameCell = CountryShort(i);      % Gather the country's name
    countryName = countryNameCell{1};       % Convert to a string
    countryName = 'US';
    
    isCountryC = strcmp(Country_cas,countryName);    % Selection vector
    isCountryD = strcmp(Country_dea,countryName);    % Selection vector
    isCountryR = strcmp(Country_rec,countryName);    % Selection vector
    
    if strcmp(countryName,'US')
        countryName = 'United States';
    end
    isCountryPops = strcmp(pops.textdata(:,1),countryName);
    popsData =  pops.data(isCountryPops,:); % Get the data for that country for all years on record
    [~,b]= max(popsData(:,1));
    popCountry = popsData(b,2);

    if ~isempty(b) % choose to only consider countries with population data
        isCountryC = isCountryC(2:end);               % Remove header line
        isCountryD = isCountryD(2:end);
        isCountryR = isCountryR(2:end);
        for j = 3:size(cases.data,2)-1
            casesCountry(j-2)     = sum(cases.data(isCountryC,j));          
        end
        for j = 3:size(deaths.data,2)-1
            deathsCountry(j-2)    = sum(deaths.data(isCountryD,j));
        end
        for j = 3:size(recovered.data,2)-1
            recoveredCountry(j-2) = sum(recovered.data(isCountryR,j));
        end
        
        days = 1:length(casesCountry);
        if 100*casesCountry(end)./popCountry > maxCountry
            maxCountry = 100*casesCountry(end)./popCountry;
            maxCountryName = countryName;
            disp(countryName)
            disp(100*casesCountry(end)./popCountry)
        end
        M = plot2(countryName,popCountry,casesCountry,deathsCountry,recoveredCountry,"Globe");
        figureOut = gcf;
    end
   
    
disp('Country with Most Cases:')
disp(maxCountryName)
!git add .
!git commit -m "added todays state data"
!git push

% USAAnalysis              
% Pull the most up-to-date information
%
% Uncomment or run this in the terminal the first time you run the code
% !git submodule add https://github.com/CSSEGISandData/COVID-19.git
% !git submodule add https://github.com/datasets/population.git
!git submodule update --remote
%
% Import the data from CSV format to matlab cell or matrix 
%
pops      = importdata("populationData/data/population.csv");
cases     = importdata("JohnsHopkinsData/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv");
deaths    = importdata("JohnsHopkinsData/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv");
recovered = importdata("JohnsHopkinsData/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv");
popStates = importdata("USA.csv");
% Gather a list of countries and provinces
Country_cas = cases.textdata(:,2);
Country_dea = deaths.textdata(:,2);
Country_rec = recovered.textdata(:,2);
Province = cases.textdata(:,1);

State = popStates.textdata(2:end,1);

% Display the Country List Allow User to Select Country of Interest
CountryShort = unique(Country_cas);
ProvinceShort = unique(Province);

%% US STATES
maxState = 0;
maxStateName = '';
for i = 1:length(State)             % loop throught all the states
    stateCell = State(i);        % Gather the current cell
    stateName = stateCell{1};    % Convert to a string
    % now stateName is a string which contains the current state
    isProvince = strcmp(Province,stateName);
    isProvince = isProvince(2:end);
    isState    = strcmp(State,stateName);
    if sum(isProvince) ~= 0
        popState = popStates.data(isState);
        for j = 3:size(cases.data,2)-1
                casesState(j-2)     = sum(cases.data(isProvince,j));
                deathsState(j-2)    = sum(deaths.data(isProvince,j));
                recoveredState(j-2) = sum(recovered.data(isProvince,j));
        end
        days = 1:length(casesState);
        if 100*casesState(end)./popState > maxState
            maxState = 100*casesState(end)./popState;
            maxStateName = stateName;
            disp(stateName)
            disp(100*casesState(end)./popState)
        end
        plotData(stateName,popState,casesState,deathsState,recoveredState)
        figureOut = gcf;
        saveas(figureOut,['Figures/' date '/' stateName '.jpg'])
        close all
        plotDataRates(stateName,popState,casesState,deathsState,recoveredState)
        figureOut = gcf;
        saveas(figureOut,['Figures/' date '/Rate' stateName '.jpg'])
        close all
    end
end

disp('State with Most Cases:')
disp(maxStateName)

%%
maxCountry = 0;
maxCountryName = '';
for i = 1:length(CountryShort)-1

    % Parse through all countries
    countryNameCell = CountryShort(i);      % Gather the country's name
    countryName = countryNameCell{1};       % Convert to a string
    
    isCountryC = strcmp(Country_cas,countryName);    % Selection vector
    isCountryD = strcmp(Country_dea,countryName);    % Selection vector
    isCountryR = strcmp(Country_rec,countryName);    % Selection vector
    
    if strcmp(countryName,'US')
        countryName = 'United States';
    end
    isCountryPops = strcmp(pops.textdata(:,1),countryName);
    popsData =  pops.data(isCountryPops,:); % Get the data for that country for all years on record
    [~,b]= max(popsData(:,1));
    popCountry = popsData(b,2);

    if ~isempty(b) % choose to only consider countries with population data
        isCountryC = isCountryC(2:end);               % Remove header line
        isCountryD = isCountryD(2:end);
        isCountryR = isCountryR(2:end);
        for j = 3:size(cases.data,2)-1
            casesCountry(j-2)     = sum(cases.data(isCountryC,j));          
        end
        for j = 3:size(deaths.data,2)-1
            deathsCountry(j-2)    = sum(deaths.data(isCountryD,j));
        end
        for j = 3:size(recovered.data,2)-1
            recoveredCountry(j-2) = sum(recovered.data(isCountryR,j));
        end
        
        days = 1:length(casesCountry);
        if 100*casesCountry(end)./popCountry > maxCountry
            maxCountry = 100*casesCountry(end)./popCountry;
            maxCountryName = countryName;
            disp(countryName)
            disp(100*casesCountry(end)./popCountry)
        end
        %plotData(countr;oyName,popCountry,casesCountry,deathsCountry,recoveredCountry)
        plot2(countryName,popCountry,casesCountry,deathsCountry,recoveredCountry,"Globe");
%         figureOut = gcf;
%         saveas(figureOut,['Figures/' countryName '.jpg']);

%         plotDataRates(countryName,popCountry,casesCountry,deathsCountry,recoveredCountry)
%         figureOut = gcf;
%         saveas(figureOut,['Figures/' date '/Rate' countryName '.jpg'])
        
%         plotDataAccel(countryName,popCountry,casesCountry,deathsCountry,recoveredCountry)
%         figureOut = gcf;
%         saveas(figureOut,['Figures/' date '/Accel' countryName '.jpg'])
%         close all
        
        close all
    end
end
disp('Country with Most Cases:')
disp(maxCountryName)


%% WORLD
popEarth = 7.594e9;
%cases     = importdata("COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv");
%deaths    = importdata("COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv");
%recovered = importdata("COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv");

casesEarth = sum(cases.data,1);
deathEarth = sum(deaths.data,1);
recovEarth = sum(recovered.data,1);
plot2('Earth',popEarth,casesEarth,deathEarth,recovEarth,"Globe");

totalTime = toc
!git add .
!git commit -m "added todays Country data"
!git push
% end
