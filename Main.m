%=========================================================================
% FileName:    	Main.m
% Description: 	This program first pulls the most recent data from Johns
% Hopkins' Github account which contains the most up to date CDC and WHO
% data. Using this data, a parser is used to gather the data for a country
% or province of interest. Plots are created to visulize the current
% outbreak of COVID19.
% Author: 	Isaac Weintraub
%=========================================================================
clear 
clc
close all
% Population Information for Countries of Interest
popUSA 		= 327.2e6; 
popUK 		= 66.44e6;
popOH 		= 11.69e6;  
popIsrael 	= 8.712e6;
popFL 		= 21.3e6;   
popTN 		= 6.77e6;
popSK 		= 51.47e6;
popItaly 	=  60.48e6;
popFr 		= 66.99e6;
popIran 	= 81.16e6;
popSpain 	= 46.66e6;
popIceland 	= 364260;
popChina 	= 1.386e9;
popNY 		= 8.623e6;
popEarth 	= 7.53e9;

% Pull the most up-to-date information
% Run this the first time
% !git clone https://github.com/CSSEGISandData/COVID-19.git
% !git clone https://github.com/datasets/population.git
% !git submodule add https://github.com/CSSEGISandData/COVID-19.git
% !git submodule add https://github.com/datasets/population.git
!git submodule update --remote

%
% Import the data from CSV format to matlab cell or matrix 
%
cases     = importdata("COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv");
deaths    = importdata("COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv");
recovered = importdata("COVID-19/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv");

Country = cases.textdata(:,2);
Province = cases.textdata(:,1);


% Display the Country List Allow User to Select Country of Interest
CountryShort = unique(Country);
ProvinceShort = unique(Province);

% USA
isUSA = strcmp(Country,'US'); 
isUSA(200:end) = 0;      % Ignore minor outlaying islands
isUSA = isUSA(2:end);     % Remove the header
% Ohio
isOH = strcmp(Province,'Ohio');
isOH = isOH(2:end);
% Tennessee
isTN = strcmp(Province,'Tennessee');
isTN = isTN(2:end);
% FLorida
isFL   = strcmp(Province,'Florida');
isFL   = isFL(2:end);
% NY
isNY = strcmp(Province,'New York');
isNY = isNY(2:end);
% China
isChina = strcmp(Country,'China');
isChina = isChina(2:end);
% South Korea
isSK = strcmp(Country,'Korea, South');
isSK = isSK(2:end);
% Iran
isIran = strcmp(Country,'Iran');
isIran = isIran(2:end);
% Italy
isItaly = strcmp(Country,'Italy');
isItaly = isItaly(2:end);
% Spain
isSpain = strcmp(Country,'Spain');
isSpain = isSpain(2:end);
% France
isFrance = strcmp(Country,'France');
isFrance = isFrance(2:end);
% Iceland
isIceland = strcmp(Country,'Iceland');
isIceland = isIceland(2:end);
% United Kingdom
isUK = strcmp(Country,'United Kingdom');
isUK = isUK(2:end);
% China
isIsrael = strcmp(Country,'Israel');
isIsrael = isIsrael(2:end);
% Earth
isEarth = ones(size(isUSA));
isEarth = isEarth(2:end);

index = 0;
for i = 3:size(cases.data,2)-1
    
%     casesUSA(i-2)     = sum(cases.data(isUSA,i)); 
%     deathsUSA(i-2)    = sum(deaths.data(isUSA,i));
%     recoveredUSA(i-2) = sum(recovered.data(isUSA,i));
% 
%     casesIceland(i-2)     = sum(cases.data(isIceland,i));
%     deathsIceland(i-2)    = sum(deaths.data(isIceland,i));
%     recoveredIceland(i-2) = sum(recovered.data(isIceland,i));
%     
%     casesUK(i-2) = sum(cases.data(isUK,i));
%     deathsUK(i-2) = sum(deaths.data(isUK,i));
%     recoveredUK(i-2) = sum(recovered.data(isUK,i));
%     
%     casesIsrael(i-2) = sum(cases.data(isIsrael,i));
%     deathsIsrael(i-2) = sum(deaths.data(isIsrael,i));
%     recoveredIsrael(i-2) = sum(recovered.data(isIsrael,i));
%     
%     casesItaly(i-2)     = sum(cases.data(isItaly,i));
%     deathsItaly(i-2)    = sum(deaths.data(isItaly,i));
%     recoveredItaly(i-2) = sum(recovered.data(isItaly,i));
% 
%     casesChina(i-2)     = sum(cases.data(isChina,i));
%     deathsChina(i-2)    = sum(deaths.data(isChina,i));
%     recoveredChina(i-2) = sum(recovered.data(isChina,i));
%     
%     casesOH(i-2)      = sum(cases.data(isOH,i));
%     deathsOH(i-2)      = sum(deaths.data(isOH,i));
%     recoveredOH(i-2)  = sum(recovered.data(isOH,i));
%     
%     casesFL(i-2)      = sum(cases.data(isFL,i));
%     deathsFL(i-2)      = sum(deaths.data(isFL,i));
%     recoveredFL(i-2)  = sum(recovered.data(isFL,i));
%     
%     casesNY(i-2)      = sum(cases.data(isNY,i));
%     deathsNY(i-2)      = sum(deaths.data(isNY,i));
%     recoveredNY(i-2)  = sum(recovered.data(isNY,i));
%     
%     casesTN(i-2)      = sum(cases.data(isTN,i));
%     deathsTN(i-2)      = sum(deaths.data(isTN,i));
%     recoveredTN(i-2)  = sum(recovered.data(isTN,i));
    
    
    casesEarth(i-2)      = sum(cases.data(:,i));
    deathsEarth(i-2)     = sum(deaths.data(:,i));
    recoveredEarth(i-2)   = sum(recovered.data(:,i));
    
end
% days = 1:length(casesUSA);

%
% Plotting the Data
% 
plotData('Earth',popEarth,casesEarth,deathsEarth,recoveredEarth)
% plotData('USA',popUSA,casesUSA,deathsUSA,recoveredUSA)
% plotData('Iceland',popIceland,casesIceland,deathsIceland,recoveredIceland)
% plotData('Italy',popItaly,casesItaly,deathsItaly,recoveredItaly)
% plotData('China',popChina,casesChina,deathsChina,recoveredChina)
% plotData('United Kingdom',popUK,casesUK,deathsUK,recoveredUK)
% plotData('Israel',popIsrael,casesIsrael,deathsIsrael,recoveredIsrael)
% % States of USA
% plotData('Ohio',popOH,casesOH,deathsOH,recoveredOH)
% plotData('Florida',popFL,casesFL,deathsFL,recoveredFL)
% plotData('New York',popNY,casesNY,deathsNY,recoveredNY)
% plotData('Tennessee',popTN,casesTN,deathsTN,recoveredTN)




