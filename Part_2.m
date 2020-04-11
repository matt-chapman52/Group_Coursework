clc
close all
clear

dataFile = "HospitalData3.xlsx";                        % Stores data set filename
dataSet = readtable(dataFile);                          % Reads the dataset and stores data into a table
height = height(dataSet);

plotData = struct;                                      % Initialises percentageSet as a struct
plotData.populations = (table2array(dataSet(:,2)))';    % Converts the table section containing population data into an array and stores to "populations2 array

months = [1:height];                                    % Constructs array of intergers from 1 to 96 (length of dataset) **NOTE could use length()?
monthsProjected = [months, [height+1:height+300]];
maxPatients = input("Enter the daily patient capacity to complete expansion for: ");

for i = 1:height                                        % Main loop iterates through each data point of the set  

    monthData = dataSet{i, 2:9};

    plotData.monthlyPercentages(i) = calcMonthPercent(monthData);
    plotData.monthlyPatients(i) = sum(monthData(2:8))*4;
    
    plotData.dailyPercentages(i) = calcDayPercentAvg(monthData);
   
end

figure;

FLRows = 5;
FLColumns = 1;

subplot(FLRows, FLColumns, 1);
axis1 = gca;
axis1.YLim = [10 20];
plot(axis1, months, plotData.monthlyPercentages, '--x', 'LineWidth', 0.5, 'MarkerSize', 5);               % Plots month-by-month percentage against months
xlabel("Months After First Data Point");
ylabel({"Percentage";"of population"});

subplot(FLRows, FLColumns, 2);
plot(months, plotData.dailyPercentages, '--x', 'LineWidth', 0.5, 'MarkerSize', 5);
xlabel("Months After First Data Point");
ylabel({"Percentage";"of population"});

subplot(FLRows, FLColumns, 3:5);
plot(months, plotData.populations);                      % Plots population aginst months
ylabel("Population of Town");
yyaxis right;
plot(months, plotData.monthlyPatients);
xlabel("Months After First Data Point");
ylabel("Patients in hospital");


hold all;

for k = 1:length(monthsProjected)/12;
    xline(12*k);
end


figure;

[polyData, errorEst] = polyfit(months, plotData.populations, 1);
[yFit, delta] = polyval(polyData, monthsProjected, errorEst);
plot(monthsProjected, yFit, 'g-');
ylabel("Population of Town");
xlabel("Months After First Data Point");
hold on;
plot(monthsProjected, yFit+2*delta,'m--', monthsProjected, yFit-2*delta,'m--');
plot(months, plotData.populations);
yline(2.5*10^5);

syms f(x);
f(x) = polyData(1)*x + polyData(2);
findMonth = finverse(f);
maxPopulation = maxPatients/(max(plotData.dailyPercentages)/100);
completionMonth = abs(findMonth(maxPopulation));
plot(completionMonth, maxPopulation, 'ro');
xline(double(completionMonth),"label", "Month Of Completion");

fprintf("This expansion should be completed for 0%d/%d", mod((completionMonth-96),12), floor((completionMonth)/12)+2012);
%-----------------------------------------
function monthlyPercentage = calcMonthPercent(monthData)
    monthPop = monthData(1);
    monthPatients = sum(monthData(2:8))*4;
    monthlyPercentage = (monthPatients/monthPop)*100;
end

function dailyPercentageAverage = calcDayPercentAvg(monthData)
    monthPop = monthData(1);
    dayPatientsAvg = sum(monthData(2:8))/7;
    dailyPercentageAverage = (dayPatientsAvg/monthPop)*100;
end

