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

%create Configs
configs_tmp = [...
    ConfigMeta.CreateMeta('fixed').set_T(0.12),...
    ConfigMeta.CreateMeta('removed').set_T(0.12),...
    ConfigMeta.CreateMeta('free10').set_T(0.12),...
    ConfigMeta.CreateMeta('free30').set_T(0.12),...
    ];
configs ={};
for i = 1:length(configs_tmp)
    configs{end+1} = configs_tmp(i).set_enviroment('WT','-');
end
for i = 1:length(configs_tmp)
    configs{end+1} = configs_tmp(i).set_enviroment('sim','-.');
end

%% create the figures
f_handle = figure(2);
f_handle.Position = [100,100,1050,450];
clf
velocities = [15,20,25,30];
aileron_input = [14];

for a_i = 1:length(aileron_input)
for v_i = 1:length(velocities)
for i =1:length(configs)
    if strcmp(configs{i}.Enviroment,'WT')
        sp = subplot(2,length(velocities)+1,v_i);
    else
        sp = subplot(2,length(velocities)+1,length(velocities)+1+v_i);
    end
    %create filter
    f = configs{i}.create_filter();
    f{end+1} = {'AileronAngle',aileron_input(a_i)};
    f{end+1} = {'V',velocities(v_i)};
    filtData = filter_struct(RunData,f);
    if length(filtData)<1
        continue
    end
    dp = [];   
    for f_i = 1:length(filtData)
        % for each run get the encoder data and derivatives
        if strcmp(configs{i}.Enviroment,'WT')
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
    norm_p_ddot(p_dot>25 & norm_p_ddot<0.05) = 0;
    p_ddot_std(p_dot>25 & norm_p_ddot<0.05) = 0;
    I = ~isnan(norm_p_ddot);    
    if strcmp(configs{i}.Enviroment,'WT')
        h_fill = fill_std(p_dot(I),norm_p_ddot(I),p_ddot_std(I)/velocities(v_i)^2);
        h_fill.FaceColor = configs{i}.Color;
        h_fill.FaceAlpha = 0.25;
        h_fill.LineStyle = 'none';
        h_fill.Annotation.LegendInformation.IconDisplayStyle = 'off';
    end
    hold on
    hline = plot(p_dot(I),norm_p_ddot(I));
    
    hline.Color = configs{i}.Color;
    hline.LineWidth = 2;
    hline.LineStyle = configs{i}.LineSpec;
    hline.DisplayName = configs{i}.Label;

    sp.FontSize = 13;
end
end
end
for row = [1:2]
    for i = 1:length(velocities)
        subplot(2,length(velocities)+1,(length(velocities)+1)*(row-1)+i)
        grid minor
        xlabel('$p$ [$deg\,s^{-1}$]')
        ylabel('$\dot{p}V^{-2}$ [$deg\,m^{-1}s^{-1}$]')
        ylim([0,3])
        if row <= 1
            title(['Velocity $',num2str(velocities(i)),'\,ms^{-1}$'])
        end 
        if i == length(velocities) && row == 1
            h = plot(0,0,'-');
            h.Color = [0.4,0.4,0.4];
            h.DisplayName = 'Experimental';
            
            h = plot(0,0,'-.');
            h.Color = [0.4,0.4,0.4];
            h.DisplayName = 'Simulation';
            
            l = legend();
            l.Position = [0.76,0.41,0.15,0.2];
        end
    end  
end

filename = '/Users/fintan/Desktop/Figures/acceleration_compare.eps';
exportgraphics(f_handle,filename,'BackgroundColor','none','ContentType','vector')

function e = TG_energy(y)
    e = y(2:end-1).^2-y(1:end-2).*y(3:end);
end
