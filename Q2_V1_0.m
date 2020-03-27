clc
clear

dataFile = "HospitalData3.xlsx";    % Stores data set filename
dataSet = xlsread(dataFile);        % Reads the dataset and stores data into a matrix

populations = dataSet(:,1);         % Assigns the first column to populations array

days = ["Mondays", "Tuesdays", "Wednesdays", "Thursdays", "Fridays", "Saturdays", "Sundays"];
months = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sept", "Oct", "Nov", "Dec"};
periods = [days, months];           % Creates a matrix containing days and months
meanPercentages = [];               % Creates empty arrays to store percentages     
medianPercentages = [];             % ^^


for i = 1:length(periods);          % Main loop cycles through each day of week and month of year
tempPercentages = [];               % Empty array re-initialised on each iteration to store temporary percentages

    

    if find(days == periods(i))                                     % Block within IF executed if the period element is found in "days" array
        for j = 1:length(dataSet);                                  % Sub loop cycles through each data point, or month, of the dataset
            monthPopulation = populations(j);                       % The contained block calculates the percentage of population in hospital on the given day
            monthPatients = dataSet(j,i+1);
            monthlyPercent = (monthPatients/monthPopulation)*100;
            tempPercentages(j) = monthlyPercent;                    % This percentage set is contained into "monthlyPercent" array **NOTE - unused var?
        end
    else                                                            % Block within IF executed if the period element is NOT found in "days" array i.e. a month
        for j = 1:length(dataSet)/12;                               % Sub loop cycles through each data point for the given month e.g. every Jan or every May etc.
            monthPopulation = populations(j);                       % The contained block calculated the percentage of the population in hospital for the entire month 
            monthPatients = sum(dataSet(12*(j-1)+(i-7),2:end));
            monthlyPercent = (monthPatients/monthPopulation)*100;
            tempPercentages(j) = monthlyPercent;                    % This percentage set is contained into monthlyPercent array **NOTE - unused var?
        end
    end
        
    
    meanPercentages(i) = mean(tempPercentages);                     % Each period's percentage data is stored into the global percentage arrays
    medianPercentages(i) = median(tempPercentages);
 
end

averageTable = table(periods.', meanPercentages.', medianPercentages.','VariableNames',{'Period','MeanPercentages','MedianPercentages'}); % Average data table generated from percentage data
         