clear all;
%close all;
restoredefaultpath;
addpath('../CommonLibrary')

% set global parameters
localDir = '../../data/';  % the directory containing the 'data' folder

load('MeanRollData.mat')
RunData = MeanRunData;

figure(1)
clf
aileronAngles = [20,30];

for i = 1:length(aileronAngles)
    subplot(1,2,i)
    PlotSymmetricConfigComparison(RunData,aileronAngles(i),'-','MeanRollRate45');
    grid
    %PlotSymmetricConfigComparison(RunData,-aileronAngles(i),'--','MeanRollRate45');
    title(['Velocity: ',num2str(aileronAngles(i)),' [m/s]'])
    xlabel('Aileron Angle [Deg]')
    ylabel('Mean Roll Rate [Deg/s]')
    legend('Fixed','Removed')
    grid minor
end

function h = PlotSymmetricConfigComparison(RunData,velocity,lineStyle,Channel)
    if ~exist('Channel','var')
        Channel = 'MeanRollRate90';
    end
    if ~exist('lineStyle','var')
        lineStyle = '-';
    end
    angles = [14,7,-7,-14];
    I = GetConfigIndicies(RunData,'RollingRig_Fixed',velocity,angles,[],0);
    h = PlotMeanData(RunData(I),[lineStyle],Channel,velocity,false,1);
    h.Color = [1,0,0];
    hold on

    I = GetConfigIndicies(RunData,'RollingRig_Removed',velocity,angles,[],0);
    h = PlotMeanData(RunData(I),[lineStyle],Channel,velocity,false,1);
    h.Color = [0,0,0];
    h = PlotMeanData(RunData(I),[lineStyle],Channel,velocity,false,0.381);
    h.Color = [0,0,0];
    
%     I = GetConfigIndicies(RunData,'RollingRig_Free',velocity,angles,10,0);
%     h = PlotMeanData(RunData(I),[lineStyle],Channel,velocity);
%     hold on
%     h.Color = [1,0,0];
%     
%     I = GetConfigIndicies(RunData,'RollingRig_Free',velocity,angles,20,0);
%     h = PlotMeanData(RunData(I),[lineStyle],Channel,velocity);
%     h.Color = [0,1,0];
%     
%     I = GetConfigIndicies(RunData,'RollingRig_Free',velocity,angles,30,0);
%     h = PlotMeanData(RunData(I),[lineStyle],Channel,velocity);
%     h.Color = [0,0,1];
    
    grid minor
end

function h = PlotMeanData(RunData,color,Channel,velocity,lineOfBestFit,scaleFactor)
    if ~exist('scaleFactor','var')
        scaleFactor=1;
    end
    if ~exist('lineOfBestFit','var')
        lineOfBestFit=1;
    end
    [unique_x,rr,std_rr] = GetMeanData(RunData,Channel);
    %h = errorbar(unique_Vs,rr,std_rr,color);
    rr = rr * scaleFactor;
    h = plot(unique_x,rr,color);
    hold on
    if lineOfBestFit
        p = polyfit(unique_x,rr,3);
        disp(roots(p))
        h = plot(-14:14,polyval(p,-14:14),'-.k');
    end

end

function [unique_x,rr,std_rr] = GetMeanData(RunData,Channel)
    if ~exist('Channel','var')
        Channel = 'MeanRollRate90';
    end
    unique_x = unique([RunData.AileronAngle])';
    rr = zeros(length(unique_x),1);
    std_rr = rr;
    for i =1:length(unique_x)
        ind = [RunData.AileronAngle] == unique_x(i);
        rr(i) = (mean([RunData(ind).(Channel)]));
        std_rr(i) = (std([RunData(ind).(Channel)]));
    end
end


function I = GetConfigIndicies(RunData,config,velocities,aileronAngle,flare,camber)
    I = strcmp(string({RunData.MassConfig}),config);
    if ~isempty(velocities)
        for i = 1:length(velocities)
            I = I & ([RunData.Velocity] >= velocities(i)-2.5 & [RunData.Velocity] < velocities(i)+2.5);
        end
    end
    
    if ~isempty(aileronAngle)
        for i = 1:length(aileronAngle)
            if i == 1
                ind = [RunData.AileronAngle] == aileronAngle(i);
            else
                ind = ind | [RunData.AileronAngle] == aileronAngle(i);
            end
        end
        I = I & ind;
    end
    if ~isempty(flare)
        for i = 1:length(flare)
            I = I & [RunData.FlareAngle] == flare(i);
        end
    end
    if ~isempty(camber)
        for i = 1:length(camber)
            I = I & [RunData.CamberAngle] == camber(i);
        end
    end
end

