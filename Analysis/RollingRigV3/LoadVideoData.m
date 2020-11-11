function [angles,centre,t] = LoadVideoData(file,cutoff)
%LOADVIDEODATA Summary of this function goes here
%   Detailed explanation goes here
if ~exist('cutoff','var')
   cutoff = 20; 
end
%load the data
vidData = load(file);
roll = vidData.roll;
leftFold = vidData.LeftFold;
rightFold = vidData.RightFold;
centre = [vidData.centreX,vidData.centreY];
t = vidData.t;

%remove jumps from 360 -> 0 -> 360 in roll data
for i =2:length(roll)
    if abs(roll(i)-roll(i-1))>180
        delta = roll(i)-roll(i-1);
        sign = abs(delta)/delta;
        roll(i:end) = roll(i:end) + 360*-sign;
    end
end

% remove outliers
roll = SelectiveMedianFilter(roll,5);
leftFold = SelectiveMedianFilter(leftFold,5);
rightFold = SelectiveMedianFilter(rightFold,5);

%design filter
order = 200;
fs = 120;
shape = [1 1 0 0];
frex = [0, cutoff, cutoff+5,fs/2]/(fs/2);
filtkern = firls(order,frex,shape);

angles = filtfilt(filtkern,1,[roll',rightFold',leftFold']);

% roll = filtfilt(filtkern,1,roll);
% leftFold = filtfilt(filtkern,1,leftFold);
% rightFold = filtfilt(filtkern,1,rightFold);
end

function data = SelectiveMedianFilter(data,scale)
    % remove nan values
    ind = find(isnan(data));
    for i = 1:length(ind)
        top_ind = min([length(data),ind(i)+25]);
        lower_ind = max([0,ind(i)-25]);
        data(ind(i)) = nanmedian(data(lower_ind:top_ind));
    end


    %remove outliers beyond a certain threshold
    data_energy = [0,data(2:end-1).^2-data(1:end-2).*data(3:end),0];
    ind = find(abs(data_energy)>std(data_energy)*scale);
    for i = 1:length(ind)
        top_ind = min([length(data),ind(i)+25]);
        lower_ind = max([1,ind(i)-25]);
        data(ind(i)) = median(data(lower_ind:top_ind));
    end
end


