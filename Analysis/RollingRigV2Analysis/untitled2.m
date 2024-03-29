clear all;
%close all;
restoredefaultpath;
addpath('../CommonLibrary')
addpath('../CommonLibrary/ERA')

% set global parameters
localDir = '../../data/';  % the directory containing the 'data' folder

RunData = GetV2Runs(localDir);

Models = unique(string({RunData.Job}));

figure(1)
clf
for i =1:length(RunData)
    subplot(4,4,i)
    enc_deg = LoadEncoderData(RunData(i).RunNumber);
    enc_deg = enc_deg(end-1700*5:end);
    enc_deg = movmean(enc_deg,32);
    v_enc_deg = diff(enc_deg)*1700;
    index = abs(v_enc_deg)>50;

    enc_deg = enc_deg(2:end);
    enc_deg = mod(enc_deg(index),360);
    v_enc_deg = v_enc_deg(index);

    %bin the data
    delta = 2;
    x_prime = 0:delta:360;
    deg=((x_prime(2:end)-x_prime(1:end-1))/2)+x_prime(1:end-1);
    vDeg = zeros(size(deg));
    for k = 1:length(deg)
        inds = enc_deg>=x_prime(k) & enc_deg<x_prime(k+1);
        vDeg(k) = mean(v_enc_deg(inds));
    end
    plot(deg',vDeg'-nanmean(vDeg),'r.')    
    %plot(deg',vDeg',colors(j))    
    grid minor
    ylim([-50,50])
    xlabel('Roll Angle [Deg]')
    ylabel('Variation from mean Roll rate [Deg/s]')
end


