clc
clear


data = readtable('Pickup Data Set3.xls');

data = standardizeMissing(data,'Do Not Use Data For This Row');

cleanedData = rmmissing(data);

handForce = [];
arrayCleanData = table2array(cleanedData(:,8));

for a = 1:height(cleanedData)
    
     calcForce = arrayCleanData(a, 1) / cos((55/180) * pi);
    handForce(a,1) = calcForce;
    
end
handForce = table(handForce);
Tnew = [cleanedData, handForce];
%%%Plotting Forcce produced by the hand against flow rate

handForce1 = [];
flowRate1 = [];
handForce2 = [];
flowRate2 = [];
handForce3 = [];
flowRate3 = [];

for b = 1: height(cleanedData)
    if strcmp (Tnew.SurfaceType(b), 'Shag')
        handForce1 = [handForce1 ; Tnew.handForce(b)];
        flowRate1 = [flowRate1 ; Tnew.FlowRate_LPS(b)];
    elseif strcmp (Tnew.SurfaceType(b), 'Hard Floor')
        handForce2 = [handForce2 ; Tnew.handForce(b)];
        flowRate2 = [flowRate2 ; Tnew.FlowRate_LPS(b)];
    else 
        handForce3 = [handForce3 ; Tnew.handForce(b)];
        flowRate3 = [flowRate3 ; Tnew.FlowRate_LPS(b)];
    end
    
end

figure
plot(handForce1, flowRate1, '.m')
hold on
plot(handForce2, flowRate2, '.b')
plot(handForce3, flowRate3, '.r')
grid on
legend('Shag Carpet','Hard Floor','Plush Carpet')
xlabel ('Push Force Produced by the users hands /N')
ylabel ('Flow Rate /LPS')


[calval] = plotG(handForce1, flowRate1, '--m') ;
fprintf('The maximum flowrate for 50N is: %f /LPS \n', calval);


plotG(handForce2, flowRate2, '--b') ;



plotG(handForce3, flowRate3, '--r') ;


%%% From viual inspection, shag carpet is the decided for the maximum flow
%%% rate under 50N of force applied by the hand.


%%%Plotting Forcce produced by the hand against flow rate

hand1 = [];
pick1 = [];
hand2 = [];
pick2 = [];
hand3 = [];
pick3 = [];

for b = 1: height(cleanedData)
    if strcmp (Tnew.SurfaceType(b), 'Shag')
        hand1 = [hand1 ; Tnew.handForce(b)];
        pick1 = [pick1 ; Tnew.Pickup__(b)];
    elseif strcmp (Tnew.SurfaceType(b), 'Hard Floor')
        hand2 = [hand2 ; Tnew.handForce(b)];
        pick2 = [pick2 ; Tnew.Pickup__(b)];
    else 
        hand3 = [hand3 ; Tnew.handForce(b)];
        pick3 = [pick3 ; Tnew.Pickup__(b)];
    end
    
end




figure
plot(hand1, pick1, '.m')
hold on
plot(hand2, pick2, '.b')
plot(hand3, pick3, '.r')
grid on
legend('Shag Carpet','Hard Floor','Plush Carpet')
xlabel ('Push Force Produced by the users hands /N')
ylabel ('Pickup /%')



[calval] = plotG(hand1, pick1, '--m') ;
fprintf('The max pickup for shag carpet is: %f \n', calval);





[calval] = plotG(hand2, pick2, '--b') ;
fprintf('The max pick up for hard floor is: %f \n', calval);



[calval] = plotG(hand3, pick3, '--r') ;
fprintf('The max pick up for plush carpet is: %f \n', calval);


function [calval] = plotG(var1, var2, col )


p = polyfit(var1, var2, 1);
yhat = polyval(p, var1);
plot(var1, yhat, col);

calval = polyval(p,50);
end





