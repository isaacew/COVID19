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
cd('COVID-19')
!git pull
cd('/Users/isaac_weintraub_admin/Projects/COVID19')
cd('covid-tracking-data')
!git pull
cd('/Users/isaac_weintraub_admin/Projects/COVID19')

[status cmdout] =  git('submodule update --remote');
% if status = 0
%     disp('Nothing New Reported')
% elseif status == 1
%     disp('Error Detected: Invalid Commmand');
% else

statePlot = 1;
% Import the data from CSV format to matlab cell or matrix 
pops         = importdata("populationData/data/population.csv");
cases        = importdata("COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv");
deaths       = importdata("COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv");
recovered    = importdata("COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv");
states       = importdata("COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv");
statesD      = importdata("COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_US.csv");
% us_daily     = importfile1("covid-tracking-data/data/us_daily.csv");
% states_daily = importfile2("covid-tracking-data/data/states_daily_4pm_et.csv");


%%
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
%     fig86 = figure(86);
%     hold on
    stateName = State(i);
    stateName = stateName{1};
    popState = popStates.data(i,1);
    isState = strcmp(Province,stateName);
    isState = isState(2:end);
    stateData = states.data(isState,:);
    stateDataDeath = statesD.data(isState,:);
    cases = sum(stateData,1);
    casesStateD = sum(stateDataDeath,1);

    
    
    if length(casesStateD)~=length(cases)
        minL = min([length(casesStateD) length(cases)]);
        casesStateD = casesStateD(1:minL);
        cases  = cases(1:minL);
    end



    Dcases = filter(-smooth_diff(10),1,cases);
    Ddeaths = filter(-smooth_diff(10),1,casesStateD);
    DDcases = filter(-smooth_diff(10),1,Dcases);
    DDDcases = filter(-smooth_diff(10),1,DDcases);
    DDdeaths = filter(-smooth_diff(10),1,Ddeaths);
    
    [maxRate,indexMaxRate] = max(Dcases);
    indexNegAcc = find(DDcases<0, 1, 'first');
    firstNegAcc = DDcases(indexNegAcc);
    dateVector = 22+[1:length(cases)];
    numDays = dateVector(end)-22;
    
%     plot(dateVector,Dcases)
%     xlim([0 dateVector(end)+90]); grid on
%     [a,b]=max(Dcases);
%     text(b+20,a,stateName)
%     ylabel('Confirmed Cases/Day')
%     datetick('x','mmm')

% %     fig2 =figure(99);
% %     hold on
% %     Y = fft(cases);
% %     Fs = 1;
% %     L = length(dateVector);
% %     P2 = abs(Y/L);
% %     P1 = P2(1:L/2+1);
% %     P1(2:end-1) = 2*P1(2:end-1);
% %     f = Fs*(0:(L/2))/L;
% %     semilogy(f,P1) 
% %     
% %     text(f(5),P1(5),stateName)
% %     fig2.Children.YScale = 'log';
% %     title('Single-Sided Amplitude Spectrum of X(t)')
% %     xlabel('f (Hz)')
% %     ylabel('|P1(f)|')
    %myPlot3(stateName,popState,casesState,casesStateD,[],"UnitedStates");
    
%     fig3 = figure(98);
%     fig3.Position = [680 37 560 1061];
%     c = [0;1;];
%     hold on
%     if i<52
%     for j = 1:length(cases)
%         x = [j j+1 j+1 j];
%         y = [i i i+1/4 i+1/4];
%         patch(x,y,cases(j)/popState*[0 1 0],'EdgeColor','none') 
%         
%         x = [j j+1 j+1 j];
%         y = [i+1/4 i+1/4 i+2/4 i+2/4];
%         patch(x,y,Dcases(j)/max(Dcases)*[0 1 0],'EdgeColor','none') 
%          
%         x = [j j+1 j+1 j];
%         y = [i+2/4 i+2/4 i+3/4 i+3/4];
%         if DDcases(j)>0
%             patch(x,y,DDcases(j)/(max(DDcases)-min(DDcases))*[0 1 0],'EdgeColor','none') 
%         elseif DDcases(j)<0
%             patch(x,y,-DDcases(j)/(max(DDcases)-min(DDcases))*[0 1 0],'EdgeColor','none') 
%         else
%             patch(x,y,[0 0 0],'EdgeColor','none') 
%         end
%         
%         x = [j j+1 j+1 j];
%         y = [i+3/4 i+3/4 i+4/4 i+4/4];
%         if DDDcases(j)>0
%             patch(x,y,DDDcases(j)/(max(DDDcases)-min(DDDcases))*[0 1 0],'EdgeColor','none') 
%         elseif DDDcases(j)<0
%             patch(x,y,-DDDcases(j)/(max(DDDcases)-min(DDDcases))*[0 1 0],'EdgeColor','none') 
%         else
%             patch(x,y,[0 0 0],'EdgeColor','none') 
%         end
%           
%     end
%     text(2,i+0.5,stateName,'color','white')
%     end
%     ylim([0 52])
%     xlim([0 length(cases)])
    
    
    fig4 = figure(96);
    hold on
    if i<52
    for j = 1:length(cases)
        x = [j j+1 j+1 j]+22;
        f1 = cases(j)/max(cases);
        f2 = Dcases(j)/max(Dcases);
        f3 = abs(DDcases(j)/(max(DDcases)-min(DDcases)));
        f4 = abs(DDDcases(j)/(max(DDDcases)-min(DDDcases)));
        %patch(x,[i i i+1/3 i+1/3],...
        %    f1*[0.6 0.2 0.1],'EdgeColor','none')
        patch(x,[i i i+1 i+1],...
            f2*[0.1 0.2 0.6],'EdgeColor','none')  
        %if DDcases(j)>0
        %patch(x,[i+2/3 i+2/3 i+3/3 i+3/3],...
        %    f3*[0.1 0.6 0.2],'EdgeColor','none')
        %else
        %patch(x,[i+2/3 i+2/3 i+3/3 i+3/3],...
        %    f3*[0.9 0.9 0.1],'EdgeColor','none')
        %end
    end
    fig4.Position = [1343 34 560 1061];
    plot([22 22+length(cases)],[i i],'color',[0.5 0.5 0.5])
    text(24,i+0.5,stateName,'color','white')
    end
end
    ylim([0 52])
    xlim([22 length(cases)])
    xlabel('Date')
    datetick('x','mmm')
    set(gca,'ytick',[])
    axis tight
    saveas(fig4,'Figures/stateComparison.jpg')
% ffig = gcf;
% ffig.Children.YScale = 'linear';
% legend('location','NorthEast')
% grid on
% title('State Rate Comparisons')
% %ylabel('Cases/Day')
% xlabel('Date')
% datetick('x','mmm')
% numDays = length(casesState);
% xlim([60 numDays+60])
end
%% PLOT THE NEW DATA FROM COVID TRACKING PROJECT
clc
close all
stateShortName = unique(states_daily.state);
for i = 1:length(stateShortName)
    disp(stateShortName(i))
    isState = states_daily.state == stateShortName(i);
    curStateData = states_daily(isState,:);
    
    % Obtain the Date
    year  = floor(curStateData.date/10000);
    month = floor((curStateData.date-year*10000)/100);
    day   = curStateData.date;
    day   =  day - year*10000 - month*100;
    n = datenum(year,month,day); % Get the Datenum
    
    
    plot(n,curStateData.positive,'ro')
    hold on
    plot(n,curStateData.negative,'bo')
    plot(n,curStateData.hospitalizedCurrently,'r-')
    plot(n,curStateData.hospitalizedCumulative,'b-')
    plot(n,curStateData.recovered,'k-')
    plot(n,curStateData.death,'r>')
    curStateData
end

%%

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

%% USAAnalysis              
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
cases     = importdata("COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv");
deaths    = importdata("COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv");
recovered = importdata("COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv");
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
close all
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
% % end
