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
%indicies = indicies & [MetaData.LCO];

RunData = MetaData(indicies);

Models = unique(string({RunData.Job}));

lines = ["-s","--o","-.*"];
colors = ["rs","go","b*","k","c"];

types = ["RollingRig_Fixed","RollingRig_Removed","RollingRig_Free"];
Vs = [20,25,30];


figure(1)
clf
for k = 1:length(types)
    for j = 1:length(Vs)
        indicies = strcmp(string({RunData.MassConfig}),types(k));
        indicies = indicies & [RunData.Velocity]>(Vs(j)-1);
        indicies = indicies & [RunData.Velocity]<(Vs(j)+1);
        frameData = RunData(indicies);
        subplot(length(Vs),length(types),(k-1)*length(types)+j)
        for i = 1:length(Models)
            tempData = frameData(string({frameData.Job})==Models(i));         
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
            for ii = 1:length(deg)
                inds = enc_deg>=x_prime(ii) & enc_deg<x_prime(ii+1);
                vDeg(ii) = mean(v_enc_deg(inds));
            end
            plot(deg',vDeg'-nanmean(vDeg),colors(i))    
            %plot(deg',vDeg',colors(i)) 
            
            
            %enc_deg = enc_deg(end-1700*5:end);
            %enc_deg = movmean(enc_deg,32);
            %v_enc_deg = diff(enc_deg)*1700;
            %index = v_enc_deg>100;

            %enc_deg = enc_deg(2:end);
            %enc_deg = mod(enc_deg(index),360);
            %v_enc_deg = v_enc_deg(index);


            %plot(enc_deg,v_enc_deg-mean(v_enc_deg),colors(i))    
            hold on
        end
        grid minor
        ylim([-50,50])
        if k==3
            xlabel('Roll Angle [Deg]')          
        end
        if j == 1        
            ylabel('Av var in Roll Rate [Deg/s]')
        end
    end
end
% figure(1)
% clf
% hold off
% for i = 1:length(Models)
%     tempData = RunData(string({RunData.Job})==Models(i));
%     enc_deg = LoadEncoderData(tempData(1).RunNumber);
%     enc_deg = enc_deg(end-1700*5:end);
%     enc_deg = movmean(enc_deg,32);
%     v_enc_deg = diff(enc_deg)*1700;
%     index = v_enc_deg>100;
%     
%     enc_deg = enc_deg(2:end);
%     enc_deg = mod(enc_deg(index),360);
%     v_enc_deg = v_enc_deg(index);
%     
%     
%     plot(enc_deg,v_enc_deg-mean(v_enc_deg),colors(i))    
%     hold on
% end
ylim([-100,100])
grid minor

% t = runData.daq.t;
% 
% figure(1)
% hold off
% plot(t,enc_deg,'r-')
% %hold on
% %plot(t,enc_deg_filt,'b-')
% 
% 
% figure(2)
% hold off
% plot(mod(enc_deg(2:end),360),diff(enc_deg),'r.')
% hold on 
% plot(mod(enc_deg_filt(2:end),360),diff(enc_deg_filt),'b.')
% ylim([-1 1])