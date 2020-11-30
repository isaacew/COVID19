%--------------------------------------------------------------------------
% USAAnalysis.m
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

modelFlag = 0;
% Pull the most up-to-date information
!git submodule update --remote
statePlot = 1;
% Import the data from CSV format to matlab cell or matrix 
pops      = importdata("populationData/data/population.csv");
cases     = importdata("COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv");
deaths    = importdata("COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv");
recovered = importdata("COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv");
states    = importdata("COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv");
statesD    = importdata("COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_US.csv");
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
    plot2(stateName,popState,casesState,casesStateD,[])
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
        M = plot2(countryName,popCountry,casesCountry,deathsCountry,recoveredCountry)
        figureOut = gcf;
    end
   
    
disp('Country with Most Cases:')
disp(maxCountryName)
!git add .
!git commit -m "added todays state data"
!git push

if modelFlag
%% Regression Fit of the SIR Model to the COVID19 Outbreak
clc; close all
days = 1:200;
% Initial Conditions
S0 = popCountry;
I0 = 5e-3;%casesCountry(1);
R0 = 0;
X0 = [S0;I0;R0];
% Guess for parameters
gamma = 0.1191;
beta  = 0.3720;
% Store into the structure of variables to pass
const.beta = beta; 
const.gamma = gamma;
% Ode45
tspan = [1 days(end)-1]; % time vector
[TOUT,YOUT] = ode45(@(t,X)SIR(t,X,gamma,beta),tspan,X0)
close all


f99 = figure(99); clf;
 plot(TOUT,YOUT,'LineWidth',3)
 hold on
 plot(1:length(casesCountry),casesCountry,'ko','MarkerSize',10)
 f99.Children.YScale = 'log';
 xlim([0 max(days)])
 drawnow
 title('United States')
 legend('Susceptible','Infections','Recovered','CDC Data','Model Evaluation')
 xlabel('Days Since 22 Jan 2020')
 ylabel('Number of People')
 
% % f98 = figure(98); clf;
% % plot(TOUT,YOUT)
% % hold on
% % plot(1:length(casesCountry),casesCountry,'ko','MarkerSize',10)
% % %ylim([0 3e5])
% % xlim([0 max(days)])
% % %f98.Children.Yaxis = 'log';
% % %legend('S','I','R')
% % % Generate Error
% % %I_indexed = interp1(TOUT,YOUT(:,2),1:length(casesCountry));
% % %plot(1:length(casesCountry),I_indexed,'bx','MarkerSize',10)
% % error = abs(I_indexed-casesCountry);
% % sumError = sum(error);

%%
clc
gamma = 0.1; beta = 0.1;
X0 = [gamma;beta];
options = optimoptions('fmincon','Display','iter',...
                       'Algorithm','sqp',...
                       'MaxIterations',1e6,...
                        'MaxFunctionEvaluations',1e6);

Z = fmincon(@(X)myfun(X,casesCountry,popCountry),X0,[],[],[],[],[0.001 0.001],[10.0 10.0],[],options);
grid on
end









