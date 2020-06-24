function [frequency,damping] = GetFreqAndDamp(run,localDir)
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


% calc acceleration and normalise
a = diff(yfilt,2);

for i=1:size(a,2)
    a(:,i) = a(:,i)./max(a(:,i));
end

%find peaks
[peakSizes,peakTimes] = findpeaks(a,fs);

%find first peak, and take 8 peaks after it
p1 = find(peakSizes>0.6,1);
numberPeaks = 8;
if p1+numberPeaks>length(peakSizes)-p1
    limit = length(peakSizes);
else
    limit = p1+numberPeaks;
end
amp = peakSizes(p1:limit);
time = peakTimes(p1:limit)-peakTimes(p1);
delta = time(2:end)-time(1:end-1);
frequency = 1/mean(delta);

sigmas = log(amp(2:end))./time(2:end);
damping = mean(sigmas(sigmas~=0));
end

