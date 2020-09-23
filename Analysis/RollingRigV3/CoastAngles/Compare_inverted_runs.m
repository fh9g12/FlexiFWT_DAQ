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
ind = ind & contains(string({RunData.RunType}),'_GoPro');
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

runs = [1817,1821,1825,1829,2002,2009,2012,2019];
inverted_runs = [1820,1824,1828,1832,2001,2010,2011,2020];

cruise_angles_deltas = zeros(7,length(runs));

for i = 1:length(runs)
    run_i = find([RunData.RunNumber]==runs(i));
    inverted_i = find([RunData.RunNumber]==inverted_runs(i));
    cruise_angles_deltas(1:2,i) = coast_angles(run_i,:)';
    cruise_angles_deltas(3:4,i) = flipud(-coast_angles(inverted_i,:)');
    cruise_angles_deltas(5,i) = cruise_angles_deltas(1,i)-cruise_angles_deltas(2,i);
    cruise_angles_deltas(6,i) = cruise_angles_deltas(3,i)-cruise_angles_deltas(4,i);
    cruise_angles_deltas(7,i) = RunData(run_i).Velocity;
end
cruise_angles_deltas = cruise_angles_deltas';

figure(1)
clf;
plot(cruise_angles_deltas(1:4,7),cruise_angles_deltas(1:4,5),'o-')
hold on
plot(cruise_angles_deltas(1:4,7),cruise_angles_deltas(1:4,6),'s-')
xlabel('Velocity [m/s]')
ylabel('Left-Right Delta [Deg]')
grid minor
min_val = max(max(abs(cruise_angles_deltas(1:4,5:6))));
ylim([-min_val*1.1,min_val*1.1])
legend('Upright','Inverted')

