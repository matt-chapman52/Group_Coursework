clc
close all
clear

dataFile = "HospitalData3.xlsx";                        % Stores data set filename
dataSet = readtable(dataFile);                          % Reads the dataset and stores data into a table
height = height(dataSet);

plotData = struct;                                      % Initialises percentageSet as a struct
plotData.populations = (table2array(dataSet(:,2)))';    % Converts the table section containing population data into an array and stores to "populations2 array

months = [1:height];                                    % Constructs array of intergers from 1 to 96 (length of dataset) **NOTE could use length()?
days = [1:28*height];

for i = 1:height                                        % Main loop iterates through each data point of the set  

    monthData = dataSet{i, 2:9};

    plotData.monthlyPercentages(i) = calcMonthPercent(monthData);
    plotData.monthlyPatients(i) = sum(monthData(2:8));

    for j = 0:3
        for k = 1:7
            plotData.dailyPercentages(28*(i-1)+(7*j)+k) = calcDayPercent(monthData, k);
            plotData.dailyPatients(28*(i-1)+(7*j)+k) = monthData(k+1);
        end
    end
   
end

figure;

subplot(4,8,[1:4,9:12])
axis1 = gca;
axis1.YLim = [10 20];
plot(axis1, months, plotData.monthlyPercentages, '--x', 'LineWidth', 0.5, 'MarkerSize', 5);               % Plots month-by-month percentage against months
xlabel("Months After First Data Point");
ylabel("Percentage of population");

subplot(4, 8,[17:18,25:28])
axis2 = gca;
axis2.YLim = [0 10];
plot(axis2, days, plotData.dailyPercentages, '--x', 'LineWidth', 0.5, 'MarkerSize', 5);

figure;
plot(months, plotData.populations);                      % Plots population aginst months
xlabel("Months After First Data Point");
ylabel("Population of Town");
yyaxis right;
ax1 = gca;

%ax1.YLim = [0 20];
line(months, plotData.monthlyPatients, 'Parent', ax1);
%{

ax2 = axes('Position', get(ax1, 'Position'),'XAxisLocation','top', 'YAxisLocation','right', 'Color', 'none');
ax2.YLim = [0 11];
line(days, plotData.dailyPercentages, 'Parent', ax2);

figure;
plot(days, plotData.dailyPercentages);                   % Plots patients in hospital against months
%}
%{
hold all;

p = polyfit(days, plotData.dailyPercentages, 1);
y1 = polyval(p, days);
plot(days, y1);
ylabel("Patients In Hospital By Month");


for k = 1:8;
    xline(12*k);
end
%}

function monthlyPercentage = calcMonthPercent(monthData)
    monthPop = monthData(1);
    monthPatients = sum(monthData(2:8))*4;
    monthlyPercentage = (monthPatients/monthPop)*100;
end

function dailyPercentage = calcDayPercent(monthData, k)
    monthPop = monthData(1);
    dayPatients = monthData(k+1);
    dailyPercentage = (dayPatients/monthPop)*100;
end