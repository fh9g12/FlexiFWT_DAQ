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

enc_tot = [];
angles_tot = [];
t_tot = [];

for i = 1:length(RunData)

    %load run data
    [enc,t] = LoadEncoderData(RunData(i).RunNumber,dataDir);

    % load video data
    tt = VideoMetaData([VideoMetaData.RunNumber] == RunData(i).RunNumber);
    ss = strsplit(tt.Filename,'.');
    [angles,centre,t_vid] = LoadVideoData([dataDir,'VideoData/',tt.Folder,ss{1},'.mat']);

    % align data
    [t,enc,angles] = align_encoder_video_data(t_vid,angles,t,enc);
    
    
    enc_tot = [enc_tot;enc];
    angles_tot = [angles_tot;angles];
    t_tot = [t_tot;t];
end

figure(5)
clf;
subplot(1,2,1)
plot(mod(enc_tot,360),mod(enc_tot,360)-mod(angles_tot(:,1),360),'.')
%plot(mod(enc_tot(1:end-1),360),diff(enc_tot-angles_tot(:,1))*1700,'.')
%ylim([-3,3])
xlabel('roll angle')
ylabel('delta roll between video and encoder')
title('comparison of roll angle measured with the two systems')
subplot(1,2,2)
plot(mod(enc_tot,360),angles_tot(:,2),'r.')
hold on
plot(mod(enc_tot+180,360),-angles_tot(:,3),'b.')
title('Fold Angles ')

x = mod(enc_tot,360);
y = mod(enc_tot,360)-mod(angles_tot(:,1),360);
ind = abs(y)<10;
x = x(ind);
y = y(ind);


ft=fittype('Correct_video(x,a,b,c,d)', ...
           'independent', {'x'}, ...
           'coefficients',{'a','b','c','d'});

f = fit( x, y,...
        ft, 'Start', [std(y), 0.5,0,mean(y)] );
figure(6);
clf;
h = plot(f,x,y);
set(h,'LineWidth',4)



