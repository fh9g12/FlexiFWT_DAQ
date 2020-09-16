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
aileronAngles = [7,14,21,-7,-14,-21];

for i = 1:length(aileronAngles)
    subplot(2,3,i)
    PlotSymmetricConfigComparison(RunData,aileronAngles(i),'-','MeanRollRate45');
    PlotSymmetricConfigComparison(RunData,-aileronAngles(i),'--','MeanRollRate45');
    grid minor
    title(['Aileron Angle: ',num2str(aileronAngles(i)),' [Deg]'])
    xlabel('Velocity [m/s]')
    ylabel('Mean Roll Rate [Deg/2]')  
end

figure(2)
clf
aileronAngles = [7,14,21,-7,-14,-21];

for i = 1:length(aileronAngles)
   subplot(2,3,i)
   PlotCamberConfigComparison(RunData,aileronAngles(i));
   title(['Aileron Angle: ',num2str(aileronAngles(i)),' [Deg]'])
   xlabel('Velocity [m/s]')
   ylabel('Mean Roll Rate [Deg/2]')    
end


function h = PlotCamberConfigComparison(RunData,aileronAngle)
    I = GetConfigIndicies(RunData,'RollingRig_Free',aileronAngle,20,10);
    %h = PlotMeanData(RunData(I),'r--+');
    h = PlotMeanData(RunData(I),'r-+','MeanRollRate45');
    hold on

    I = GetConfigIndicies(RunData,'RollingRig_Free',aileronAngle,20,0);
    %h = PlotMeanData(RunData(I),'g--+');
    h = PlotMeanData(RunData(I),'g-+','MeanRollRate45');

    I = GetConfigIndicies(RunData,'RollingRig_Free',aileronAngle,20,-10);
    %h = PlotMeanData(RunData(I),'b--+');
    h = PlotMeanData(RunData(I),'b-+','MeanRollRate45');
    grid minor
end


function h = PlotSymmetricConfigComparison(RunData,aileronAngle,lineStyle,Channel)
    if ~exist('Channel','var')
        Channel = 'MeanRollRate90';
    end
    if ~exist('lineStyle','var')
        lineStyle = '-';
    end
    xOffset = -2.4;
    I = GetConfigIndicies(RunData,'RollingRig_Fixed',aileronAngle,[],0);
    h = PlotMeanData(RunData(I),[lineStyle],Channel,xOffset);
    h.Color = [1,0,0];
    hold on

    I = GetConfigIndicies(RunData,'RollingRig_Removed',aileronAngle,[],0);
    h = PlotMeanData(RunData(I),[lineStyle],Channel);
    h.Color = [0,0,0];

    I = GetConfigIndicies(RunData,'RollingRig_Free',aileronAngle,10,0);
    h = PlotMeanData(RunData(I),[lineStyle,''],Channel);
    h.Color = [0,0,1];

    I = GetConfigIndicies(RunData,'RollingRig_Free',aileronAngle,20,0);
    h = PlotMeanData(RunData(I),[lineStyle,''],Channel);
    h.Color = [0,0.8,0.8];

    I = GetConfigIndicies(RunData,'RollingRig_Free',aileronAngle,30,0);
    h = PlotMeanData(RunData(I),[lineStyle,''],Channel);
    h.Color = [0,0.8,0];
    
    grid minor
end

function h = PlotMeanData(RunData,color,Channel,xOffset)
    if ~exist('xOffset','var')
        xOffset = 0;
    end
    [unique_Vs,rr,std_rr] = GetMeanData(RunData,Channel);
    unique_Vs = unique_Vs + xOffset;
    h = errorbar(unique_Vs,rr,std_rr,color);
end

function [unique_Vs,rr,std_rr] = GetMeanData(RunData,Channel)
    if ~exist('Channel','var')
        Channel = 'MeanRollRate90';
    end
    unique_Vs = unique([RunData.Velocity])';
    rr = zeros(length(unique_Vs),1);
    std_rr = rr;
    for i =1:length(unique_Vs)
        ind = [RunData.Velocity] == unique_Vs(i);
        rr(i) = abs(mean([RunData(ind).(Channel)]));
        std_rr(i) = abs(std([RunData(ind).(Channel)]));
    end
end


function I = GetConfigIndicies(RunData,config,aileronAngle,flare,camber)
    I = strcmp(string({RunData.MassConfig}),config);
    if ~isempty(aileronAngle)
        for i = 1:length(aileronAngle)
            I = I & [RunData.AileronAngle] == aileronAngle(i);
        end
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

