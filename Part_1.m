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

p = polyfit(handForce1, flowRate1, 1);
yhat = polyval(p, handForce1);
plot(handForce1, yhat, '--m');
calval = polyval(p,50);


fprintf('The maximum flowrate for 50N is: %f /LPS \n', calval);

q = polyfit(handForce2, flowRate2, 1);
yhat2 = polyval(q, handForce2);
plot(handForce2, yhat2, '--b');


r = polyfit(handForce3, flowRate3, 1);
yhat3 = polyval(r, handForce3);
plot(handForce3, yhat3, '--r');


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



p = polyfit(hand1, pick1, 1);
yhat = polyval(p, hand1);
plot(hand1, yhat, '--m');
calval = polyval(p,50);
fprintf('The max pickup for shag carpet is: %f \n', calval);



q = polyfit(hand2, pick2, 1);
yhat2 = polyval(q, hand2);
plot(hand2, yhat2, '--b');

calval = polyval(p,50);
fprintf('The max pick up for hard floor is: %f \n', calval);

r = polyfit(hand3, pick3, 1);
yhat3 = polyval(r, hand3);
plot(hand3, yhat3, '--r');

calval = polyval(p,50);
fprintf('The max pick up for plush carpet is: %f \n', calval);




