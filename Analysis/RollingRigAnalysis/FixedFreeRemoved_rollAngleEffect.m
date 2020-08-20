clear all;
%close all;
restoredefaultpath;
addpath('../CommonLibrary')
addpath('../CommonLibrary/ERA')

% set global parameters
localDir = '../../data/';  % the directory containing the 'data' folder

% Open the Meta-Data file
load([localDir,'../MetaData.mat']);     % the Metadata filepath

indicies = true([1,length(MetaData)]);
indicies = indicies & contains(string({MetaData.Job}),'RollingRigv');
indicies = indicies & ~contains(string({MetaData.Folder}),'29-Jul-2020'); % bad day of testing
indicies = indicies & [MetaData.RunNumber]~=1073; % weird speed
indicies = indicies & (strcmp(string({MetaData.RunType}),'Release')|strcmp(string({MetaData.RunType}),'Steady'));
indicies = indicies & (strcmp(string({MetaData.Job}),"RollingRigv1_45"));

RunData = MetaData(indicies);

Models = unique(string({RunData.Job}));

lines = ["-s","--o","-.*"];
colors = ["rs","go","b*","k","c"];

types = ["RollingRig_Fixed","RollingRig_Removed","RollingRig_Free"];
Vs = [20,25,30];


figure(1)
clf
for i =1:length(Vs)
    subplot(1,length(Vs),i)
    for j = 1:length(types)
        indicies = strcmp(string({RunData.MassConfig}),types(j));
        indicies = indicies & [RunData.Velocity]>(Vs(i)-1);
        indicies = indicies & [RunData.Velocity]<(Vs(i)+1);
        tempData = RunData(indicies);
        enc_deg = LoadEncoderData(tempData(1).RunNumber);
        enc_deg = enc_deg(end-1700*5:end);
        enc_deg = movmean(enc_deg,32);
        v_enc_deg = diff(enc_deg)*1700;
        index = v_enc_deg>100;

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
        plot(deg',vDeg'-nanmean(vDeg),colors(j))    
        %plot(deg',vDeg',colors(j))    
        hold on
    end
    grid minor
    ylim([-50,50])
    xlabel('Roll Angle [Deg]')
    ylabel('Variation from mean Roll rate [Deg/s]')
end
