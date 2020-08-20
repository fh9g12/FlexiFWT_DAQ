clear all;
close all;
restoredefaultpath;
addpath('../CommonLibrary')
addpath('../CommonLibrary/ERA')

% set global parameters
localDir = '../../data/';  % the directory containing the 'data' folder

% Open the Meta-Data file
load([localDir,'../MetaData.mat']);     % the Metadata filepath

indicies = true([1,length(MetaData)]);
indicies = indicies & string({MetaData.Job}) == 'FlutterBiSection';
indicies = indicies & (strcmp(string({MetaData.RunType}),'Steady')|strcmp(string({MetaData.RunType}),'StepInput'));
indicies = indicies & [MetaData.LCO];

RunData = MetaData(indicies);

res = zeros(length(RunData),4);
for i = 1:length(RunData)
    [a,b,c,d] = GetFreqAndAmp(RunData(i),localDir);
    res(i,:)=[a,b,c,d];
end

res(:,5) = res(:,2)./res(:,1);
res(:,6) = [RunData.RunNumber];
res(:,7) = [RunData.AoA];
res(:,8) = [RunData.Velocity];
res(:,9) = [RunData.TabAngle];


% only get stable results
res = res(res(:,5)<0.1,:);
res = res(res(:,7)==2.5,:);
%res = res(res(:,8)>22,:);
%res = res(res(:,8)<23,:);

vs = unique(res(:,8));

figure(1)
hold off

for i=1:length(vs)
   v_res = res(res(:,8)==vs(i),:);
   scatter(v_res(:,9),v_res(:,1)./max(res(:,1)),'filled')
   hold on
end


%plot(res(:,9),res(:,1)./max(res(:,1)),'+')
xlabel('Tab Angle [Deg]')
ylabel('Normalised LCO Amplitude')
ylim([0,1])
grid minor
legend(num2str(vs,'%.1f'))
title('Normalised LCO respoonse across different tab angles and velocities, AoA 2.5 Degrees')


