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
vidData = load([dataDir,'VideoData/',tt.Folder,ss{1},'.mat']);
roll = vidData.roll;
for i =2:length(roll)
    if abs(roll(i)-roll(i-1))>180
        delta = roll(i)-roll(i-1);
        sign = abs(delta)/delta;
        roll(i:end) = roll(i:end) + 360*-sign;
    end
end

roll_energy = [0,roll(2:end-1).^2-roll(1:end-2).*roll(3:end),0];
ind = find(roll_energy>std(roll_energy)*5);

for i = 1:length(ind)
    top_ind = min([length(roll),ind(i)+25]);
    lower_ind = max([0,ind(i)-25]);
    roll(ind(i)) = median(roll(lower_ind:top_ind));
end
roll_energy = [0,roll(2:end-1).^2-roll(1:end-2).*roll(3:end),0];
t = vidData.t;

order = 120;
fs = 120;
cutoff = 20;
shape = [1 1 0 0];
frex = [0, cutoff, cutoff+5,fs/2]/(fs/2);

filtkern = firls(order,frex,shape);
filtKErnX = abs(fft(filtkern,length(roll))).^2;

signalX = fft(roll);
signalAmp = 2*abs(signalX)/length(roll);

roll_filt = filtfilt(filtkern,1,roll);

signalX_filt = fft(roll_filt);
signalAmp_filt = 2*abs(signalX_filt)/length(roll);


hz = linspace(0,fs/2,floor(length(roll)/2)+1);
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
plot(t,mod(roll,360))
hold on
plot(t,mod(roll_filt,360))

