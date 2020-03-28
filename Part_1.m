clc
clear

data = readtable('Pickup Data Set3.xls'); % Importing excel spreadsheet into Maltab

data = standardizeMissing(data,'Do Not Use Data For This Row');  % Telling Matlab to treat the 'Do Not Use' as missing Data

cleanedData = rmmissing(data);

handForce = [];
pushForceArray = table2array(cleanedData(:,8)); % Creating an array of just the force to then calculate the force at the users hand

for a = 1:height(cleanedData)
    
     calcForce = pushForceArray(a, 1) / cos((55/180) * pi);
    handForce(a,1) = calcForce;
    
end

handForce = table(handForce);
Tnew = [cleanedData, handForce];   %Adding the force at users hand to the table

[shag, hardFloor, plush] = floorType(Tnew);  %% Calling floor type function

figure
plot(shag.handForce, shag.flowRate, '.m')
hold, grid on
plot(hardFloor.handForce, hardFloor.flowRate, '.b')
plot(plush.handForce, plush.flowRate, '.r')
legend('Shag Carpet','Hard Floor','Plush Carpet')
xlabel ('Push Force Produced by the users hands /N')
ylabel ('Flow Rate /LPS')
% Plotting of first graph with legend, labels etc.

[calcval] = plotG(shag.handForce, shag.flowRate, '--m') ;
fprintf('The maximum flowrate for 50N, shag is: %f /LPS \n', calcval);
[calcval] = plotG(hardFloor.handForce, hardFloor.flowRate, '--b') ;
fprintf('The maximum flowrate for 50N, hard floor is: %f /LPS \n', calcval);
[calcval] = plotG(plush.handForce, plush.flowRate, '--r') ;
fprintf('The maximum flowrate for 50N, plush is: %f /LPS \n', calcval);
figure
plot(shag.handForce, shag.pickup, '.m')
hold, grid on
plot(hardFloor.handForce, hardFloor.pickup, '.b')
plot(plush.handForce, plush.pickup, '.r')
legend('Shag Carpet','Hard Floor','Plush Carpet')
xlabel ('Push Force Produced by the users hands /N')
ylabel ('Pickup /%')
%%% Plotting of Second graph with labels and titles etc.


[calcval] = plotG(shag.handForce, shag.pickup, '--m') ;
fprintf('The max pickup for shag carpet is: %f \n', calcval);

[calcval] = plotG(hardFloor.handForce, hardFloor.pickup, '--b') ;
fprintf('The max pick up for hard floor is: %f \n', calcval);

[calcval] = plotG(plush.handForce, plush.pickup, '--r') ;
fprintf('The max pick up for plush carpet is: %f \n', calcval);
%Plotting of line of best fit and using this line to interpolate values.

function [calcval] = plotG(var1, var2, col )
p = polyfit(var1, var2, 1);
yhat = polyval(p, var1);
plot(var1, yhat, col);
calcval = polyval(p,50);
%%%Function calls the two x and y variables, uses polyfit and polyval to
%%%plot a line of best fit. Calval uses linear interpolation to find the
%%%corresponding x or y value.
end


function [shag, hardFloor, plush] = floorType(Tnew)
headerNames = {'handForce', 'flowRate', 'pickup'};
shag = array2table(zeros(0,3));
shag.Properties.VariableNames = headerNames;
hardFloor = array2table(zeros(0,3));
hardFloor.Properties.VariableNames = headerNames;
plush = array2table(zeros(0,3));
plush.Properties.VariableNames = headerNames;
%Creating of empty tables for each floor type.
for b = 1: height(Tnew)
    if strcmp (Tnew.SurfaceType(b), 'Shag')
        shag(end+1,:) = {Tnew.handForce(b), Tnew.FlowRate_LPS(b), Tnew.Pickup__(b)};
    elseif strcmp (Tnew.SurfaceType(b), 'Hard Floor')
        hardFloor(end+1,:) = {Tnew.handForce(b), Tnew.FlowRate_LPS(b), Tnew.Pickup__(b)};
    else
        plush(end+1,:) = {Tnew.handForce(b), Tnew.FlowRate_LPS(b),Tnew.Pickup__(b)};
    end  
end 
% Loop to sort the data into the correct table based on floor type.
end





