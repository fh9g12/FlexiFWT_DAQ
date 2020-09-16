clear all;
%close all;
restoredefaultpath;
addpath('../CommonLibrary')

% set global parameters
localDir = '../../data/';  % the directory containing the 'data' folder

load('MeanRollData.mat')
RunData = MeanRunData;

configs = {...
    {'RollingRig_Fixed',[],[],[1 0 0],-1,'Fixed',1}...
    ,{'RollingRig_Removed',[],[],[0 0 0],-1,'Removed',0.725}...
    ,{'RollingRig_Removed',[],[],[0,0,1],-0.381,'Removed Scaled to 1m',1}...
    ,{'RollingRig_Free',10,0, [0 1 0],-1,'Free, 10 Degrees Flare',1}...
    ,{'RollingRig_Free',20,0, [0 1 1],-1,'Free, 20 Degrees Flare',1}...
    ,{'RollingRig_Free',30,0, [0 1 1],-1,'Free, 30 Degrees Flare',1}...
    ,{'RollingRig_Free',20,10, [0 0 1],-1,'Free, camber 10, Flare 20 Degrees',1}...
    ,{'RollingRig_Free',20,-10, [1 0 1],-1,'Free, camber -10, Flare 20 Degrees',1}...
    };

for i = 1:length(RunData)
   RunData(i).EqAileronAngle = RunData(i).AileronAngle; 
end



velocities = [20];
for i = [1,2]%length(configs)
    for j = 1:length(velocities)    
        I_all = GetConfigIndicies(RunData,configs{i}{1},velocities(j),[21,14,7,-7,-14,21],configs{i}{2},0);       
        I = GetConfigIndicies(RunData,configs{i}{1},velocities(j),[7,-7],configs{i}{2},0);
        [unique_x,rr,std_rr] = GetMeanData(RunData(I),'AileronAngle','MeanRollRatepm90');
        p = polyfit(unique_x,rr,1);
        offset = p(2)/p(1);
        for l = find(I_all)
            RunData(l).EqAileronAngle = RunData(l).AileronAngle + offset;
        end
    end
end

figure(10)
clf
for i = 1:length(velocities)
    subplot(1,4,i)
    for j = [1,2,3,4,5,6]%length(configs)
        I = GetConfigIndicies(RunData,configs{j}{1},velocities(i),[7,14,21],configs{j}{2},0);       
        [unique_x,rr,std_rr] = GetMeanData(RunData(I),'EqAileronAngle','MeanRollRatepm45');
        rr = rr*configs{j}{5};
        errorbar(unique_x,rr,std_rr,'color',configs{j}{4})
        hold on
    end
    xlabel('Aileron Angle [Deg]')
    ylabel('Mean Roll Rate [Deg/s]')
    title(['Flow Velocity ',num2str(velocities(i)),' [m/s]'])
%     for j = 1:length(configs)
%         I = GetConfigIndicies(RunData,configs{j}{1},velocities(i),[21,14,7]*-1,configs{j}{2},0);       
%         [unique_x,rr,std_rr] = GetMeanData(RunData(I),'EqAileronAngle','MeanRollRate45');
%         errorbar(abs(unique_x),abs(rr),std_rr,'--','color',configs{j}{3})
%         hold on
%     end
    grid minor
    legend(string(cellfun(@(x)x{6},configs,'UniformOutput',false)))
end

figure(11)
clf
for i = 1:length(velocities)
    subplot(1,4,i)
    for j = [1,2,5,7,8]%length(configs)
        I = GetConfigIndicies(RunData,configs{j}{1},velocities(i),[7,14,21],configs{j}{2},configs{j}{3});       
        [unique_x,rr,std_rr] = GetMeanData(RunData(I),'EqAileronAngle','MeanRollRate45');
        rr = rr*configs{j}{5};
        errorbar(unique_x,rr,std_rr,'color',configs{j}{4})
        hold on
    end
    xlabel('Aileron Angle [Deg]')
    ylabel('Mean Roll Rate [Deg/s]')
    title(['Flow Velocity ',num2str(velocities(i)),' [m/s]'])
%     for j = 1:length(configs)
%         I = GetConfigIndicies(RunData,configs{j}{1},velocities(i),[21,14,7]*-1,configs{j}{2},0);       
%         [unique_x,rr,std_rr] = GetMeanData(RunData(I),'EqAileronAngle','MeanRollRate45');
%         errorbar(abs(unique_x),abs(rr),std_rr,'--','color',configs{j}{3})
%         hold on
%     end
    grid minor
    legend(string(cellfun(@(x)x{6},configs([1,2,5,7,8]),'UniformOutput',false)))
end


figure(12)
clf
for i = 1:length(velocities)
    %subplot(1,4,i)
    for j = [1,2,4,5,6]%length(configs)
        I = GetConfigIndicies(RunData,configs{j}{1},velocities(i),[7,14,21],configs{j}{2},0);       
        [unique_x,rr,std_rr] = GetMeanData(RunData(I),'EqAileronAngle','MeanRollRatepm45');
        rr = (rr*configs{j}{5}).^-1;
        unique_x = deg2rad(unique_x).*velocities(i);
        plot(unique_x,rr,'+','color',configs{j}{4})
        hold on
    end
    xlabel('Aileron Angle [Deg]')
    ylabel('Mean Roll Rate [Deg/s]')
    title(['Flow Velocity ',num2str(velocities(i)),' [m/s]'])
%     for j = 1:length(configs)
%         I = GetConfigIndicies(RunData,configs{j}{1},velocities(i),[21,14,7]*-1,configs{j}{2},0);       
%         [unique_x,rr,std_rr] = GetMeanData(RunData(I),'EqAileronAngle','MeanRollRate45');
%         errorbar(abs(unique_x),abs(rr),std_rr,'--','color',configs{j}{3})
%         hold on
%     end
    grid minor
    legend(string(cellfun(@(x)x{6},configs,'UniformOutput',false)))
end
xlim([3,11])
ylim([0,0.025])




% for i = 1:length(aileronAngles)
%     subplot(1,4,i)
%     PlotSymmetricConfigComparison(RunData,aileronAngles(i),'-','MeanRollRate45');
%     grid
%     %PlotSymmetricConfigComparison(RunData,-aileronAngles(i),'--','MeanRollRate45');
%     title(['Velocity: ',num2str(aileronAngles(i)),' [m/s]'])
%     xlabel('Aileron Angle [Deg]')
%     ylabel('Mean Roll Rate [Deg/s]')
%     legend('Fixed','Removed')
%     grid minor
% end

function [unique_x,rr,std_rr] = GetMeanData(RunData,xChannel,Channel)
    if ~exist('Channel','var')
        Channel = 'MeanRollRate90';
    end
    if ~exist('xChannel','var')
        Channel = 'Velocity';
    end
    unique_x = unique([RunData.(xChannel)])';
    rr = zeros(length(unique_x),1);
    std_rr = rr;
    for i =1:length(unique_x)
        ind = [RunData.(xChannel)] == unique_x(i);
        rr(i) = (mean([RunData(ind).(Channel)]));
        std_rr(i) = (std([RunData(ind).(Channel)]));
    end
end

function h = PlotSymmetricConfigComparison(RunData,velocity,lineStyle,Channel)
    if ~exist('Channel','var')
        Channel = 'MeanRollRate90';
    end
    if ~exist('lineStyle','var')
        lineStyle = '-';
    end
    angles = [14,7,-7,-14];
    %I = GetConfigIndicies(RunData,'RollingRig_Fixed',velocity,angles,[],0);
    %h = PlotMeanData(RunData(I),[lineStyle],Channel,velocity);
    %h.Color = [1,0,0];
    %hold on

    %I = GetConfigIndicies(RunData,'RollingRig_Removed',velocity,angles,[],0);
    %h = PlotMeanData(RunData(I),[lineStyle],Channel,velocity);
    %h.Color = [0,0,0];
    
    I = GetConfigIndicies(RunData,'RollingRig_Free',velocity,angles,10,0);
    h = PlotMeanData(RunData(I),[lineStyle],Channel,velocity);
    hold on
    h.Color = [1,0,0];
    
    I = GetConfigIndicies(RunData,'RollingRig_Free',velocity,angles,20,0);
    h = PlotMeanData(RunData(I),[lineStyle],Channel,velocity);
    h.Color = [0,1,0];
    
    I = GetConfigIndicies(RunData,'RollingRig_Free',velocity,angles,30,0);
    h = PlotMeanData(RunData(I),[lineStyle],Channel,velocity);
    h.Color = [0,0,1];
    
    grid minor
end

function h = PlotMeanData(RunData,color,Channel,velocity)
    [unique_x,rr,std_rr] = GetMeanData(RunData,Channel);
    %h = errorbar(unique_Vs,rr,std_rr,color);
    h = plot(unique_x,rr,color);
    hold on
    p = polyfit(unique_x,rr,3);
    disp(roots(p))
    h = plot(-14:14,polyval(p,-14:14),'-.k');

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

