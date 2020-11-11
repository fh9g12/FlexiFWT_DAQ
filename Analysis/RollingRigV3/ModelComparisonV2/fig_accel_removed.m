clear all;
%close all;
addsandbox

% load SimData
SimData = load_SimData(["FixedData.csv","FreeData.csv"]);
SimData = SimData(strcmp(string({SimData.LiftDist}),'Roll60'));


% Load WT RunData
load('../RunData_500.mat')
[RunData.Source] = deal('WT');
[RunData.T] = deal(0);
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

%create Configs
configs = [...
    ConfigMeta.CreateMeta('removed').set_enviroment('WT','-').set_T(0).set_Label('Experimental'),...
    ConfigMeta.CreateMeta('removed').set_enviroment('sim','--').set_T(0.06).set_Label('Sim: $T = 0.06\,s$'),...
    ConfigMeta.CreateMeta('removed').set_enviroment('sim','-.').set_T(0.12).set_Label('Sim: $T = 0.12\,s$')...
    ];

%setup figure
f_handle = figure(1);
f_handle.Position = [100,100,1050,450];
clf
velocities = [15,20,25,30];
aileron_input = [14];

for a_i = 1:length(aileron_input)
for v_i = 1:length(velocities)
for i =1:length(configs)
    %create filter
    f = configs(i).create_filter();
    f{end+1} = {'AileronAngle',aileron_input(a_i)};
    f{end+1} = {'V',velocities(v_i)};
    filtData = filter_struct(RunData,f);
    if length(filtData)<1
        continue
    end
    sp = subplot(1,length(velocities),v_i);
    dp = [];   
    for f_i = 1:length(filtData)
        % for each run get the encoder data and derivatives
        if strcmp(configs(i).Enviroment,'WT')
            %p_tmp = LoadEncoderData(filtData(f_i).RunNumber,'/Volumes/Seagate Expansi/PhD Files/Data/WT data/',500,1,20);
            p_tmp = filtData(f_i).ts_data(:,1);
            if p_tmp(end)<0
                p_tmp = -p_tmp;
            end
            dp_tmp = get_sgolay_gradients(p_tmp,[1,2],1/500,5,121);
        else
            p_tmp = filtData(f_i).ts_data(:,1);
            if p_tmp(end)<0
                p_tmp = -p_tmp;
            end
            dp_tmp = get_sgolay_gradients(p_tmp,[1,2],1/500,5,121);
        end
        dp=[dp;dp_tmp]; 
    end
    interval = 4;
    p_dot = 0:interval:max(dp(:,1));
    p_ddot = zeros(1,length(p_dot));
    p_ddot_std = zeros(1,length(p_dot));
    for p_i = 1:length(p_dot)
        I = (dp(:,1)>p_dot(p_i)-interval/2) & (dp(:,1)<=p_dot(p_i)+interval/2);
        p_ddot(p_i) = nanmean(dp(I,2));
        p_ddot_std(p_i) = nanstd(dp(I,2));
    end
    norm_p_ddot = p_ddot/velocities(v_i)^2;
    I = ~isnan(norm_p_ddot) & norm_p_ddot>0.2;
    
    if strcmp(configs(i).Enviroment,'WT')
        h_fill = fill_std(p_dot(I),norm_p_ddot(I),p_ddot_std(I)/velocities(v_i)^2);
        h_fill.FaceColor = configs(i).Color;
        h_fill.FaceAlpha = 0.25;
        h_fill.LineStyle = 'none';
        h_fill.Annotation.LegendInformation.IconDisplayStyle = 'off';
    end
    hold on
    hline = plot(p_dot(I),norm_p_ddot(I));
    
    hline.Color = configs(i).Color;
    hline.LineWidth = 2;
    hline.LineStyle = configs(i).LineSpec;
    hline.DisplayName = configs(i).Label;

    sp.FontSize = 13;    
end
% grid minor
xlabel('$p$ [$deg\,s^{-1}$]')
ylabel('$\dot{p}V^{-2}$ [$deg\,m^{-1}s^{-1}$]')
title(['Velocity $',num2str(velocities(v_i)),'\,ms^{-1}$'])
ylim([0.25,3.5])
end
end

legend()
filename = '/Users/fintan/Desktop/Figures/acceleration_removed.eps';
exportgraphics(f_handle,filename,'BackgroundColor','none','ContentType','vector')

function e = TG_energy(y)
    e = y(2:end-1).^2-y(1:end-2).*y(3:end);
end
