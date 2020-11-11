clear all;
%close all;
addsandbox;

SimData = load_fixed_data('FixedData.csv');
SimData = SimData(strcmp(string({SimData.LiftDist}),'Roll60'));
SimData = [SimData , load_fixed_data('FreeData.csv')];
[SimData.RunType] = deal('Release_GoPro');
% sort left reight being wrong way around
for i = 1:length(SimData)
    SimData(i).ts_data(:,3:4)=SimData(i).ts_data(:,[4,3]);
end

load('../RunData.mat')
[RunData.Source] = deal('WT');
[RunData.LiftDist] = deal('Roll60');
[RunData.T] = deal(0.12);
RunData = concat_structs(RunData,SimData);

% remove funky runs
runs = [1428,1446];
for i = 1:length(runs)
    I = find([RunData.RunNumber] == runs(i),1);
    if ~isempty(I)
        RunData(I) = [];
    end
end
RunData = RunData(strcmp(string({RunData.RunType}),'Release_GoPro'));
% get binned roll rate with roll
RunData = get_roll_rate_with_roll(RunData,'stepSize',15,'upperLimit',360);
RunData = get_angles_with_roll(RunData,'stepSize',15,'upperLimit',360);

%create Configs
configs = [...
    ConfigMeta.CreateMeta('free10').set_T(0.12).set_enviroment('sim','--'),...
    ConfigMeta.CreateMeta('free30').set_T(0.12).set_enviroment('sim','--'),...
    ConfigMeta.CreateMeta('free10').set_T(0.12).set_enviroment('WT','-'),...
    ConfigMeta.CreateMeta('free30').set_T(0.12).set_enviroment('WT','-'),...
    ];

for i = 1:length(RunData)
    RunData(i).V = round(RunData(i).Velocity/5)*5;
end

AileronAngles = [14];
velocities = [15,20,25,30];

%% plot normailised with roll rate
f_handle = figure(3);
f_handle.Position = [20 20 1200 400];
clf;
for i = 1:length(velocities)
    sp = subplot(1,length(velocities),i);
    for j = 1:length(configs)
        ind = mod(j-1,5)+1;
        % Build Filter
        f = configs(j).create_filter();
        f{end+1} = {'AileronAngle',AileronAngles(1)};
        f{end+1} = {'V',velocities(i)};         
        filtData = filter_struct(RunData,f);
        
        bins = filtData(1).RollBins_Angles;
        [left_data,right_data] = deal(zeros(length(bins),length(filtData)));
        
        %plot left 
        for k = 1:length(filtData)
            %right data
            if strcmp(configs(j).Enviroment,'WT')
                left_data(:,k) = -(filtData(k).AnglesWithRoll(:,3));
                right_data(:,k) = flip_folds(filtData(k).AnglesWithRoll(:,2));    
            else
                left_data(:,k) = -(filtData(k).AnglesWithRoll(:,2));
                right_data(:,k) = flip_folds(filtData(k).AnglesWithRoll(:,3)); 
            end
        end
        h = plot(bins,nanmean(left_data,2),configs(j).LineSpec);
        h.Color = configs(j).Color;
        if strcmp(configs(j).Enviroment,'WT')
            h.DisplayName = configs(j).Label;
        else
            h.Annotation.LegendInformation.IconDisplayStyle = 'off';
        end
        h.LineWidth = 2;
        hold on
        if strcmp(configs(j).Enviroment,'WT')
            h = plot(bins,nanmean(right_data,2),configs(j).LineSpec);
            h.Color = configs(j).Color;
            h.LineStyle = ':';
            h.Annotation.LegendInformation.IconDisplayStyle = 'off';
            h.LineWidth = 2;
        end
    end
    h = plot(NaN,NaN,'-');
    h.DisplayName = 'Right Wingtip';
    h.Color = [0.1 0.1 0.1];
    h = plot(NaN,NaN,':');
    h.DisplayName = 'Left Wingtip';
    h.Color = [0.1 0.1 0.1];
    h = plot(NaN,NaN,'--');
    h.DisplayName = 'Simulated Results';
    h.Color = [0.1 0.1 0.1];
    ylim([-75,40])
    xlim([0,360])
    title(['Velocity ',num2str(velocities(i)), ' [$ms^{-1}$]'])
    xlabel('Roll Angle [deg]')
    ylabel('Fold Angle [deg]')
    grid minor
    if i == length(velocities)
        l = legend('location','north');
        l.FontSize = 13;
    end
    sp.FontSize = 13;
end



clear RunData
filename = '/Users/fintan/Desktop/Figures/fold_angle_with_roll_delta_vel.png';
exportgraphics(f_handle,filename,'BackgroundColor','white')

function angles = flip_folds(angles)
    tmp = angles;
    val = floor(length(tmp)/2);
    if mod(length(tmp),2)==0
        angles(1:val) = tmp(val+1:end);
        angles(val+1:end) = tmp(1:val);
    else
        angles(1:val) = tmp(val+2:end);
        angles(val+2:end) = tmp(1:val);
        angles(val+1) = tmp(val+1);
    end
end