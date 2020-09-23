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
[enc,t] = LoadEncoderData(RunData(1).RunNumber,dataDir,false);

order = 1700;
fs = 1700;
cutoff = 20;
shape = [1 1 0 0];
frex = [0, cutoff, cutoff+5,fs/2]/(fs/2);

filtkern = firls(order,frex,shape);
filtKErnX = abs(fft(filtkern,length(enc))).^2;

signalX = fft(enc);
signalAmp = 2*abs(signalX)/length(enc);

enc_filt = filtfilt(filtkern,1,enc);

signalX_filt = fft(enc_filt);
signalAmp_filt = 2*abs(signalX_filt)/length(enc);


hz = linspace(0,fs/2,floor(length(enc)/2)+1);
ind = hz < 50;
figure(1)
clf;
subplot(2,3,1)
plot((-order/2:order/2)/fs,filtkern)
subplot(2,3,4)
plot(hz(ind),filtKErnX(ind))
subplot(2,3,[2,5])
plot(hz(ind),signalAmp(ind))
hold on
plot(hz(ind),signalAmp_filt(ind))
set(gca, 'YScale', 'log')
subplot(2,3,[3,6])
plot(t,mod(enc,360))
hold on
plot(t,mod(enc_filt,360))

