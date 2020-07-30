%=========================================================================
% FileName:    	Main.m
% Description: 	This program first pulls the most recent data from Johns
% Hopkins' Github account which contains the most up to date CDC and WHO
% data. Using this data, a parser is used to gather the data for a country
% or province of interest. Plots are created to visulize the current
% outbreak of COVID19.
% Author: 	Isaac Weintraub
%=========================================================================
function [] = Main()

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
[date1,state,positive,negative,pending,hospitalizedCurrently,hospitalizedCumulative,inIcuCurrently,inIcuCumulative,onVentilatorCurrently,onVentilatorCumulative,recovered1,dataQualityGrade,lastUpdateEt,dateModified,checkTimeEt,death,hospitalized,dateChecked,totalTestsViral,positiveTestsViral,negativeTestsViral,positiveCasesViral,deathConfirmed,deathProbable,fips,positiveIncrease,negativeIncrease,total,totalTestResults,totalTestResultsIncrease,posNeg,deathIncrease,hospitalizedIncrease,hash,commercialScore,negativeRegularScore,negativeScore,positiveScore,score,grade] = importfile("covid-tracking-data/data/states_daily_4pm_et.csv");

end

function [date1,state,positive,negative,pending,hospitalizedCurrently,hospitalizedCumulative,inIcuCurrently,inIcuCumulative,onVentilatorCurrently,onVentilatorCumulative,recovered1,dataQualityGrade,lastUpdateEt,dateModified,checkTimeEt,death,hospitalized,dateChecked,totalTestsViral,positiveTestsViral,negativeTestsViral,positiveCasesViral,deathConfirmed,deathProbable,fips,positiveIncrease,negativeIncrease,total,totalTestResults,totalTestResultsIncrease,posNeg,deathIncrease,hospitalizedIncrease,hash,commercialScore,negativeRegularScore,negativeScore,positiveScore,score,grade] = importfile(filename, startRow, endRow)
%IMPORTFILE Import numeric data from a text file as column vectors.
%   [DATE1,STATE,POSITIVE,NEGATIVE,PENDING,HOSPITALIZEDCURRENTLY,HOSPITALIZEDCUMULATIVE,INICUCURRENTLY,INICUCUMULATIVE,ONVENTILATORCURRENTLY,ONVENTILATORCUMULATIVE,RECOVERED1,DATAQUALITYGRADE,LASTUPDATEET,DATEMODIFIED,CHECKTIMEET,DEATH,HOSPITALIZED,DATECHECKED,TOTALTESTSVIRAL,POSITIVETESTSVIRAL,NEGATIVETESTSVIRAL,POSITIVECASESVIRAL,DEATHCONFIRMED,DEATHPROBABLE,FIPS,POSITIVEINCREASE,NEGATIVEINCREASE,TOTAL,TOTALTESTRESULTS,TOTALTESTRESULTSINCREASE,POSNEG,DEATHINCREASE,HOSPITALIZEDINCREASE,HASH,COMMERCIALSCORE,NEGATIVEREGULARSCORE,NEGATIVESCORE,POSITIVESCORE,SCORE,GRADE]
%   = IMPORTFILE(FILENAME) Reads data from text file FILENAME for the
%   default selection.
%
%   [DATE1,STATE,POSITIVE,NEGATIVE,PENDING,HOSPITALIZEDCURRENTLY,HOSPITALIZEDCUMULATIVE,INICUCURRENTLY,INICUCUMULATIVE,ONVENTILATORCURRENTLY,ONVENTILATORCUMULATIVE,RECOVERED1,DATAQUALITYGRADE,LASTUPDATEET,DATEMODIFIED,CHECKTIMEET,DEATH,HOSPITALIZED,DATECHECKED,TOTALTESTSVIRAL,POSITIVETESTSVIRAL,NEGATIVETESTSVIRAL,POSITIVECASESVIRAL,DEATHCONFIRMED,DEATHPROBABLE,FIPS,POSITIVEINCREASE,NEGATIVEINCREASE,TOTAL,TOTALTESTRESULTS,TOTALTESTRESULTSINCREASE,POSNEG,DEATHINCREASE,HOSPITALIZEDINCREASE,HASH,COMMERCIALSCORE,NEGATIVEREGULARSCORE,NEGATIVESCORE,POSITIVESCORE,SCORE,GRADE]
%   = IMPORTFILE(FILENAME, STARTROW, ENDROW) Reads data from rows STARTROW
%   through ENDROW of text file FILENAME.
%
% Example:
%   [date1,state,positive,negative,pending,hospitalizedCurrently,hospitalizedCumulative,inIcuCurrently,inIcuCumulative,onVentilatorCurrently,onVentilatorCumulative,recovered1,dataQualityGrade,lastUpdateEt,dateModified,checkTimeEt,death,hospitalized,dateChecked,totalTestsViral,positiveTestsViral,negativeTestsViral,positiveCasesViral,deathConfirmed,deathProbable,fips,positiveIncrease,negativeIncrease,total,totalTestResults,totalTestResultsIncrease,posNeg,deathIncrease,hospitalizedIncrease,hash,commercialScore,negativeRegularScore,negativeScore,positiveScore,score,grade] = importfile('states_daily_4pm_et.csv',2, 7970);
%
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2020/07/26 12:13:03

%% Initialize variables.
delimiter = ',';
if nargin<=2
    startRow = 2;
    endRow = inf;
end

%% Read columns of data as text:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines', startRow(1)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines', startRow(block)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Convert the contents of columns containing numeric text to numbers.
% Replace non-numeric text with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = mat2cell(dataArray{col}, ones(length(dataArray{col}), 1));
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[1,3,4,5,6,7,8,9,10,11,12,17,18,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,36,37,38,39,40]
    % Converts text in the input cell array to numbers. Replaced non-numeric
    % text with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1)
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData(row), regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if numbers.contains(',')
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'))
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric text to numbers.
            if ~invalidThousandsSeparator
                numbers = textscan(char(strrep(numbers, ',', '')), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch
            raw{row, col} = rawData{row};
        end
    end
end

% Convert the contents of columns with dates to MATLAB datetimes using the
% specified date format.
try
    dates{14} = datetime(dataArray{14}, 'Format', 'MM/dd/yyyy HH:mm', 'InputFormat', 'MM/dd/yyyy HH:mm');
catch
    try
        % Handle dates surrounded by quotes
        dataArray{14} = cellfun(@(x) x(2:end-1), dataArray{14}, 'UniformOutput', false);
        dates{14} = datetime(dataArray{14}, 'Format', 'MM/dd/yyyy HH:mm', 'InputFormat', 'MM/dd/yyyy HH:mm');
    catch
        dates{14} = repmat(datetime([NaN NaN NaN]), size(dataArray{14}));
    end
end

dates = dates(:,14);

%% Split data into numeric and string columns.
rawNumericColumns = raw(:, [1,3,4,5,6,7,8,9,10,11,12,17,18,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,36,37,38,39,40]);
rawStringColumns = string(raw(:, [2,13,15,16,19,35,41]));


%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),rawNumericColumns); % Find non-numeric cells
rawNumericColumns(R) = {NaN}; % Replace non-numeric cells

%% Make sure any text containing <undefined> is properly converted to an <undefined> categorical
for catIdx = [1,2,3,4,5]
    idx = (rawStringColumns(:, catIdx) == "<undefined>");
    rawStringColumns(idx, catIdx) = "";
end

%% Allocate imported array to column variable names
date1 = cell2mat(rawNumericColumns(:, 1));
state = categorical(rawStringColumns(:, 1));
positive = cell2mat(rawNumericColumns(:, 2));
negative = cell2mat(rawNumericColumns(:, 3));
pending = cell2mat(rawNumericColumns(:, 4));
hospitalizedCurrently = cell2mat(rawNumericColumns(:, 5));
hospitalizedCumulative = cell2mat(rawNumericColumns(:, 6));
inIcuCurrently = cell2mat(rawNumericColumns(:, 7));
inIcuCumulative = cell2mat(rawNumericColumns(:, 8));
onVentilatorCurrently = cell2mat(rawNumericColumns(:, 9));
onVentilatorCumulative = cell2mat(rawNumericColumns(:, 10));
recovered1 = cell2mat(rawNumericColumns(:, 11));
dataQualityGrade = categorical(rawStringColumns(:, 2));
lastUpdateEt = dates{:, 1};
dateModified = categorical(rawStringColumns(:, 3));
checkTimeEt = categorical(rawStringColumns(:, 4));
death = cell2mat(rawNumericColumns(:, 12));
hospitalized = cell2mat(rawNumericColumns(:, 13));
dateChecked = categorical(rawStringColumns(:, 5));
totalTestsViral = cell2mat(rawNumericColumns(:, 14));
positiveTestsViral = cell2mat(rawNumericColumns(:, 15));
negativeTestsViral = cell2mat(rawNumericColumns(:, 16));
positiveCasesViral = cell2mat(rawNumericColumns(:, 17));
deathConfirmed = cell2mat(rawNumericColumns(:, 18));
deathProbable = cell2mat(rawNumericColumns(:, 19));
fips = cell2mat(rawNumericColumns(:, 20));
positiveIncrease = cell2mat(rawNumericColumns(:, 21));
negativeIncrease = cell2mat(rawNumericColumns(:, 22));
total = cell2mat(rawNumericColumns(:, 23));
totalTestResults = cell2mat(rawNumericColumns(:, 24));
totalTestResultsIncrease = cell2mat(rawNumericColumns(:, 25));
posNeg = cell2mat(rawNumericColumns(:, 26));
deathIncrease = cell2mat(rawNumericColumns(:, 27));
hospitalizedIncrease = cell2mat(rawNumericColumns(:, 28));
hash = rawStringColumns(:, 6);
commercialScore = cell2mat(rawNumericColumns(:, 29));
negativeRegularScore = cell2mat(rawNumericColumns(:, 30));
negativeScore = cell2mat(rawNumericColumns(:, 31));
positiveScore = cell2mat(rawNumericColumns(:, 32));
score = cell2mat(rawNumericColumns(:, 33));
grade = rawStringColumns(:, 7);

% For code requiring serial dates (datenum) instead of datetime, uncomment
% the following line(s) below to return the imported dates as datenum(s).

% lastUpdateEt=datenum(lastUpdateEt);



end

