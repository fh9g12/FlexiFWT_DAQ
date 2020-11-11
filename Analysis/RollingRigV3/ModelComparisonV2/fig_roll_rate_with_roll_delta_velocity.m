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

RunData = get_roll_rate_with_roll(RunData,'stepSize',5,'upperLimit',360);

%create Configs
configs_tmp = [...
    ConfigMeta.CreateMeta('removed').set_T(0.12),...
    ConfigMeta.CreateMeta('fixed').set_T(0.12),...
    ConfigMeta.CreateMeta('free10').set_T(0.12),...
    ConfigMeta.CreateMeta('free30').set_T(0.12),...
    ];
configs ={};
for i = 1:length(configs_tmp)
    configs{end+1} = configs_tmp(i).set_enviroment('sim','--');
end
for i = 1:length(configs_tmp)
    configs{end+1} = configs_tmp(i).set_enviroment('WT','-');
end

%% create the figures
AileronAngles = [14];
vs = [15,20,25,30];
f_handle = figure(1);
f_handle.Position = [20 20 1100 400];
clf;
for i = 1:length(vs)
    sp = subplot(1,length(vs),i);
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
                %[mean_data,bins] = shift_bins(mean_data,bins);
        if j == 1 || j == length(configs)/2+1
            baseline = mean_data-mean(mean_data);
        elseif j == 2 || j == length(configs)/2+2
            baseline = (baseline + mean_data-mean(mean_data))/2;
        else
            h = plot(bins,(mean_data-mean(mean_data)-baseline)/mean(mean_data)*100);
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
    end
    h = plot(NaN,NaN,'-');
    h.DisplayName = 'Experimental Results';
    h.Color = [0.1 0.1 0.1];
    h = plot(NaN,NaN,'--');
    h.DisplayName = 'Simulated Results';
    h.Color = [0.1 0.1 0.1];
    ylim([-30,30])
    xlim([0,180])
    xticks([-90 -60 -30 0 30 60 90]+90)
    xlabel('Roll Angle [deg]')
    ylabel('\% variation about $\dot{p_s}$','Interpreter','Latex','fontweight','bold')
    title(['Velocity ',num2str(vs(i)), ' $ms^{-1}$'])
    grid minor
    if i == length(vs)
        l = legend('location','southeast');
        l.FontSize = 12;
    end
    sp.FontSize = 13;
    
end
clear RunData
filename = '/Users/fintan/Desktop/Figures/roll_rate_with_roll_delta_vel.png';
exportgraphics(f_handle,filename,'BackgroundColor','white')