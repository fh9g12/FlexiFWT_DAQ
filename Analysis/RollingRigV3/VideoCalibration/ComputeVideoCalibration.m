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

% pick only fixed rolling rig jobs
ind = contains(string({RunData.Job}),'RollingRigv2');
ind = ind & strcmp(string({RunData.MassConfig}),'RollingRig_Fixed');
ind = ind & strcmp(string({RunData.RunType}),'Release_GoPro');
RunData = RunData(ind);


%load run data
[enc,t] = LoadEncoderData(RunData(1).RunNumber,dataDir);

% load video data
tt = VideoMetaData([VideoMetaData.RunNumber] == RunData(1).RunNumber);
ss = strsplit(tt.Filename,'.');
[angles,centre,t_vid] = LoadVideoData([dataDir,'VideoData/',tt.Folder,ss{1},'.mat']);

% align data
[t,enc,angles] = align_encoder_video_data(t_vid,angles,t,enc);

enc_v = diff(enc)*1700;
roll_v = diff(angles(:,1))*1700;
figure(1);
clf;
subplot(1,2,1)
plot(mod(enc(1:end-1),360),enc_v,'r.')
hold on
plot(mod(angles(1:end-1,1),360),roll_v,'b.')
subplot(1,2,2)
plot(t(1:end-1),enc_v,'r-')
hold on
plot(t(1:end-1),roll_v,'b-')

figure(5)
clf;
subplot(1,2,1)
plot(mod(enc,360),mod(enc,360)-mod(angles(:,1),360),'.')
ylim([-3,3])
subplot(1,2,2)
plot(mod(enc,360),angles(:,2),'r.')
hold on
plot(mod(enc+180,360),-angles(:,3),'b.')


