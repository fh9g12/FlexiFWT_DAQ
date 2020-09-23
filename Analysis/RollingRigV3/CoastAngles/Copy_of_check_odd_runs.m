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
RunData = RunData(ind);

[~,index] = sortrows([MetaData.RunNumber].'); MetaData = MetaData(index); clear index


coast_angles = zeros(length(RunData),2);

runs = [1819,1818,1817];

figure(1)
clf;
for i = 1:length(runs) 
    tt = VideoMetaData([VideoMetaData.RunNumber] == runs(i));
    meta = MetaData([MetaData.RunNumber] == runs(i));
    ss = strsplit(tt.Filename,'.');
    [angles,centre,t_vid] = LoadVideoData([dataDir,'VideoData/',tt.Folder,ss{1},'.mat']);
    plot(t_vid(1:end-1),diff(angles(:,1)),'DisplayName',[num2str(runs(i)),': ',num2str(meta.FlareAngle),': ', num2str(meta.AileronAngle)])
    hold on
end
legend