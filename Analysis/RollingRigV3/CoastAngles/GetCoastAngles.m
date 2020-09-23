clear all;
%close all;
restoredefaultpath;
addpath('../../CommonLibrary')
addpath('..')

% directory with data and VideoData folders in
dataDir = '/Volumes/Seagate Expansi/PhD Files/Data/WT data/';

load([dataDir,'MetaData.mat'],'MetaData')
load([dataDir,'VideoMetaData.mat'],'VideoMetaData')

%get metadata for only runs with a video
ind = zeros(1,length(MetaData));
runs = [MetaData.RunNumber];
for i=1:length(VideoMetaData)
    ind = ind | runs == VideoMetaData(i).RunNumber;
end
RunData = MetaData(ind);

% pick only rolling rig jobs
ind = contains(string({RunData.Job}),'RollingRigv2');
ind = ind & strcmp(string({RunData.RunType}),'Release_GoPro');
%ind = ind & contains(string({RunData.MassConfig}),'Free');
RunData = RunData(ind);


coast_angles = zeros(length(RunData),2);

parfor i = 1:length(RunData) 
    tt = VideoMetaData([VideoMetaData.RunNumber] == RunData(i).RunNumber);
    ss = strsplit(tt.Filename,'.');
    [angles,centre,t_vid] = LoadVideoData([dataDir,'VideoData/',tt.Folder,ss{1},'.mat']);
    
    coast_angles(i,:) = mean(angles(1:120,2:3));
end

for i = 1:length(RunData)
    RunData(i).LeftCruise = coast_angles(i,1);
    RunData(i).RightCruise = coast_angles(i,2);
end

ind = false(7,length(RunData));

ind(1,:) = contains(string({RunData.MassConfig}),'Free');

ind(2,:) = ind(1,:) & [RunData.FlareAngle] == 20;
ind(3,:) = ind(1,:) & [RunData.FlareAngle] == 30;
ind(4,:) = ind(1,:) & [RunData.FlareAngle] == 20;
ind(5,:) = ind(1,:) & [RunData.FlareAngle] == 20;
ind(1,:) = ind(1,:) & [RunData.FlareAngle] == 10;
ind(4,:) = ind(4,:) & [RunData.CamberAngle] == -10;
ind(5,:) = ind(5,:) & [RunData.CamberAngle] == 10;
ind(2,:) = ind(2,:) & [RunData.CamberAngle] == 0;

ind(5,:) = contains(string({RunData.MassConfig}),'RightFixed');

ind(6,:) = ind(5,:) & [RunData.AileronAngle] <0;
ind(5,:) = ind(5,:) & [RunData.AileronAngle] > 0;


figure(5)
clf;
colors = {[1,0,0],[0 1 0],[0 0 1]};
rows = [1,2,3];
flare = [10,20,30];
for row =1:length(rows)
    i = rows(row);
    plot([RunData(ind(i,:)).Velocity],[RunData(ind(i,:)).LeftCruise],'+','color',colors{row},'DisplayName',['Left Cruise Angle, Flare ',num2str(flare(row))])
    hold on
    plot([RunData(ind(i,:)).Velocity],[RunData(ind(i,:)).RightCruise],'o','color',colors{row},'DisplayName',['Right Cruise Angle, Flare ',num2str(flare(row))])
end
legend
grid minor
xlabel('Velocity [m/s]')
ylabel('Cruise Angle [Deg]')


figure(6)
clf;
colors = {[1,0,0],[0 0 1],[0 0 1]};
rows = [5,6];
flare = ['positive','negative'];
for row =1:length(rows)
    i = rows(row);
    plot([RunData(ind(i,:)).Velocity],[RunData(ind(i,:)).LeftCruise],'+','color',colors{row},'DisplayName',['Left Cruise Angle, Aileron Angle ',num2str(flare(row))])
    hold on
    plot([RunData(ind(i,:)).Velocity],[RunData(ind(i,:)).RightCruise],'o','color',colors{row},'DisplayName',['Right Cruise Angle, Aileron Angle ',num2str(flare(row))])
end
legend
grid minor
xlabel('Velocity [m/s]')
ylabel('Cruise Angle [Deg]')
    

