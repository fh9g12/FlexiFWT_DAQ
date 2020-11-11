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

%% Plot Data
f_handle = figure(1);
f_handle.Position = [20 20 1120 320];
clf;
AileronAngles = [7,14,21];
velocities = [15,20,25,30];
results = struct();
count = 1;
for i = 1:length(AileronAngles)
    subplot(1,length(AileronAngles),i)
    for j = 1:length(configs)        
        [mean_angle_left,mean_angle_right] = deal(zeros(length(velocities),1)*NaN);
        for v_i = 1:length(velocities)
            % Update Filter
            f = configs(j).create_filter();  
            f{end+1} = {'AileronAngle',AileronAngles(i)};
            f{end+1} = {'V',velocities(v_i)};
            filtData = filter_struct(RunData,f);
            if length(filtData)>0
                [left_data,right_data] = deal(zeros(length(filtData),1)*NaN);
                for k = 1:length(filtData)
                    left_data(i) = mean(filtData(k).AnglesWithRoll(:,3));
                    right_data(i) = mean(filtData(k).AnglesWithRoll(:,2));
                end
                mean_angle_left(v_i) = nanmean(left_data);
                mean_angle_right(v_i) = nanmean(right_data);
            else
                disp(['Failed to find runs for velocity ',num2str(velocities(v_i)),...
                    ', aileron angle ',num2str(AileronAngles(i)),...
                    ', source ',configs(j).Enviroment])
            end
        end
        
        h = plot(velocities,mean_angle_left,configs(j).LineSpec);
        h.Color = configs(j).Color;
        h.MarkerSize = 10;
        if strcmp(configs(j).Enviroment,'WT')
            h.DisplayName = [num2str(configs(j).Flare),' Degrees Flare'];
        else
            h.Annotation.LegendInformation.IconDisplayStyle = 'off';
        end
        h.LineWidth = 2;
        hold on
        if strcmp(configs(j).Enviroment,'WT')
            h = plot(velocities,-mean_angle_right,configs(j).LineSpec);
            h.LineStyle = ':';
            h.Color = configs(j).Color;
            h.MarkerSize = 10;
            h.Annotation.LegendInformation.IconDisplayStyle = 'off';
            h.LineWidth = 2;
        end
        
    end
    grid
    title(['Aileron Angle: ',num2str(AileronAngles(i)),' deg'])
    xlabel('Velocity [$ms^{-1}$]')
    ylabel('Mean Fold Angle [deg]')
    grid minor
    if i == length(AileronAngles)
        h = plot (0,-20,'-');
        h.DisplayName = 'Left Fold Angle - Experimental';
        h.Color = [0.2, 0.2, 0.2];
        
        h = plot (0,-20,':');
        h.DisplayName = 'Right Fold Angle  - Experimental';
        h.Color = [0.2, 0.2, 0.2];
        
        h = plot (0,-20,'--');
        h.DisplayName = 'Simulation';
        h.Color = [0.2, 0.2, 0.2];
        
        l = legend('location','northwest');
        l.FontSize = 13;
    end
    ylim([0,30])
    xlim([15,30])
end

clear RunData
filename = '/Users/fintan/Desktop/Figures/mean_fold_angle.png';
exportgraphics(f_handle,filename,'BackgroundColor','white')