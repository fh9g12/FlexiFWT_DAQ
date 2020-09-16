clear all;
%close all;
restoredefaultpath;
addpath('../CommonLibrary')

% set global parameters
localDir = '../../data/';  % the directory containing the 'data' folder

%load('RollData.mat')
%ind = [RollData.Velocity]>19;
%ind = ind & [RollData.Velocity]<21;
%ind = ind & [RollData.AileronAngle] == -21;

%tempData = RollData(ind);

runs = [1614,1555,1701];
offset = [0.54,0.89,0.6];

figure(1)
clf;
for i = 1:length(runs)
    [data,t] = LoadEncoderData(runs(i));
    rollRate = diff(movmean(data,20),1)*1700;
    meanRollRate = mean(rollRate(end-1700*5:end));
    plot(t(1:end-1)-offset(i),rollRate./meanRollRate)
    hold on
end
xlabel('time [s]')
ylabel('Roll Rate [Deg/s]')
xlim([-0.2,4])
%ylim([0,1.2])
grid minor
legend('Fixed','Removed','Free-10 degrees Flare','location','southeast')

