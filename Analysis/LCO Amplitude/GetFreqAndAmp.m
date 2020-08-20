function [peak_mean,peak_std,frequency,damping] = GetFreqAndAmp(run,localDir)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
[y,t] = ExtractAccelData(run,localDir);

%decimate time series
res = [];
for i=1:size(y,2)
    res=[res,decimate(y(:,i),10)];    
end
y = res;
t = decimate(t,10);

% filter time series
fs = 1700 / 10;
fcutoff = 5;
transw = 0.2;
order = round(17*fs/fcutoff);
shape = [1 1 0 0];
frex = [0 fcutoff fcutoff+fcutoff*transw,fs/2]/(fs/2);
filtkern = firls(order,frex,shape);


yfilt = filtfilt(filtkern,1,y(:,2));


% calc acceleration
a = diff(yfilt,2);

%for i=1:size(a,2)
%    a(:,i) = a(:,i)./max(a(:,i));
%end

%find peaks
[peakSizes,peakTimes] = findpeaks(a,fs);
peakSizes = peakSizes(peakSizes>0);
peakTimes = peakTimes(peakSizes>0);

% take the last 5 peaks 
% (dont take very last peak as signal may be on the way up at the end)
if length(peakSizes)<7
    ind = 1:length(peakSizes)-1;
else
    ind = length(peakSizes)-6:length(peakSizes)-1;
end

%get the mean and std of amplitudes
peak_mean = real(mean(peakSizes(ind)));
peak_std = real(std(peakSizes(ind)));

% get frequency
time = peakTimes(ind)-peakTimes(ind(1));
delta = time(2:end)-time(1:end-1);
frequency = 1./mean(delta);

sigmas = log(peakSizes(ind(2:end)))./time(2:end);
damping = mean(sigmas(sigmas~=0))./frequency;
end

