clear all;
clear all;
addsandbox

%% pre-amble

% load SimData
SimData = load_SimData(["FixedData.csv","FreeData.csv"]);
SimData = SimData(strcmp(string({SimData.LiftDist}),'Roll60'));

% Load WT RunData
load('../RunData_500.mat')
[RunData.Source] = deal('WT');
[RunData.T] = deal(0.12);
RunData = RunData(strcmp(string({RunData.RunType}),'Release'));
% remove funky runs
runs = [1428,1446];
for i = 1:length(runs)
    I = find([RunData.RunNumber] == runs(i),1);
    if ~isempty(I)
        RunData(I) = [];
    end
end

% Combine Data sources
RunData = concat_structs(RunData,SimData);

% create V channel
for i = 1:length(RunData)
    RunData(i).V = round(RunData(i).Velocity);
end

RunData = get_roll_rate_with_roll(RunData,'stepSize',5,'upperLimit',180);

%create Configs
configs_tmp = [...
    ConfigMeta.CreateMeta('removed').set_T(0.12),...
    ConfigMeta.CreateMeta('fixed').set_T(0.12)...
    ];
configs ={};
for i = 1:length(configs_tmp)
    configs{end+1} = configs_tmp(i).set_enviroment('sim','--');
end
for i = 1:length(configs_tmp)
    configs{end+1} = configs_tmp(i).set_enviroment('WT','-');
end

%% create the figures
AileronAngles = [7];
vs = [15,20,25,30];
f_handle = figure(1);
f_handle.Position = [20 20 1000 400];
set(0, 'DefaultTextInterpreter', 'latex')
set(0, 'defaultAxesTickLabelInterpreter','latex');
set(0, 'defaultLegendInterpreter','latex');
clf;
for i = 1:length(vs)
    subplot(1,length(vs),i)
    for j = 1:length(configs)
        % Build Filter
        f = configs{j}.create_filter();
        f{end+1} = {'AileronAngle',AileronAngles(1)};
        f{end+1} = {'V',vs(i)};    
        filtData = filter_struct(RunData,f);
        bins = filtData(1).RollBins;
        data = zeros(length(bins),length(filtData));
        for k = 1:length(filtData)
            data(:,k) = filtData(k).RollRateWithRoll;
        end
        mean_data = nanmean(data,2);
        [mean_data,bins] = shift_bins(mean_data,bins);
        
        h = plot(bins,(mean_data-mean(mean_data)));
        h.Color = configs{j}.Color;
        h.LineStyle = configs{j}.LineSpec;
        if strcmp(configs{j}.Enviroment,'WT')
            h.DisplayName = configs{j}.Label;
        else
            h.Annotation.LegendInformation.IconDisplayStyle = 'off';
        end
        h.LineWidth = 2;
        hold on
    end
    h = plot(NaN,NaN,'-');
    h.DisplayName = 'Experimental Results';
    h.Color = [0.1 0.1 0.1];
    h = plot(NaN,NaN,'--');
    h.DisplayName = 'Simulated Results';
    h.Color = [0.1 0.1 0.1];
    ylim([-35,35])
    xlim([-90,90])
    xticks([-90 -60 -30 0 30 60 90])
    xlabel('Roll Angle [deg]')
    ylabel('Variation from $\dot{p}_s$ [$deg\,s^{-1}$]','Interpreter','Latex','fontweight','bold')
    title(['Velocity ',num2str(vs(i)), ' $ms^{-1}$'])
    grid minor
    if i == length(vs)
        legend('location','southeast')
    end
end
clear RunData
filename = '/Users/fintan/Desktop/Figures/roll_rate_with_roll_abs_v.png';
exportgraphics(f_handle,filename,'BackgroundColor','white')

function [new_val,bins] = shift_bins(values,bins)
%SHIFT_BINS Summary of this function goes here
%   Detailed explanation goes here
n = length(bins);
if mod(n,2) == 0
    new_val = [values(n/2+1:end);values(1:n/2)];
    bins = [-flipud(bins(1:n/2));bins(1:n/2)];
else
    m = (n-1)/2 + 1;
    new_val = [values(m:end);values(1:m-1)];
    bins = [-flipud(bins(1:m));bins(1:m-1)];
end
end