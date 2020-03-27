clc
clear

dataFile = "HospitalData3.xlsx";                        % Stores data set filename
dataSet = readtable(dataFile);                          % Reads the dataset and stores data into a table

percentageSet = struct;                                 % Initialises percentageSet as a struct
populations = table2array(dataSet(:,2));                % Converts the table section containing population data into an array and stores to "populations2 array

months = [1:96];                                        % Constructs array of intergers from 1 to 96 (length of dataset) **NOTE could use length()?

for i = 1:96;                                           % Main loop iterates through each data point of the set  
daysNums = dataSet{i, 3:9};                             % Extracts the data containing the patient numbers for each day of the week
daysNumsAll(i) = sum(daysNums);                         % Sums the daysnums array to find total monthly patients 
monthlyPercentage = (sum(daysNums)/ populations(i))*100;   % Calculates and stores the average monthly patients to the percentage struct **NOTE use daysnumsAll
percentageSet(i).monthPercent = monthlyPercentage;

    for j = 1:7;                                        % Sub loop calculates percentage of population by day and stores to percentage set struct
        percentageSet(i).daysPercent(j) = (dataSet{i,j+2}/populations(i))*100; % **NOTE this does not consider 4 weeks per month...
    end
   
end

plot(months, [percentageSet(1:96).monthPercent]);       % Plots month-by-month percentage against months
figure;
plot(months, populations);                              % Plots population aginst months
xlabel("Months After First Data Point");
ylabel("Population of Town")
yyaxis right;
plot(months, daysNumsAll);                              % Plots patients in hospital against months