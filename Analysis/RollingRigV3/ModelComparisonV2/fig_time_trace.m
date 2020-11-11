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
fig_handle = figure(2);
fig_handle.Position =[1809,244,1375,541];
clf
velocities = [20];
aileron_input = [14];

offsets = [0.07,0.07,0.07,0.07,...
            0.1,0.1,0.1,0.1];

for a_i = 1:length(aileron_input)
for v_i = 1:length(velocities)
for i =1:length(configs)
%     if ~strcmp(configs{i}{1},'WT')
%         continue
%     end
    f = configs{i}.create_filter();
    f{end+1} = {'AileronAngle',aileron_input(a_i)};
    f{end+1} = {'V',velocities(v_i)};
    filtData = filter_struct(RunData,f);
    if length(filtData)<1
        continue
    end
    t = 0:0.001:10;
    x_lim = [0,3];
    ind = zeros(1,length(filtData));
    ind(1) = 1;
    data = zeros(length(t),3,length(filtData));
    means = zeros(length(filtData),1);
    for j = 1:length(filtData)
        p = filtData(j).ts_data(:,1);
        t_tmp = filtData(j).t(1:end);
        mean_rr = mean(filtData(j).RollRateWithRoll);
        period = t_tmp(2)-t_tmp(1);
        fs = 1/period;        
        dp = get_sgolay_gradients(p,[0,1,2],period,5,floor((fs/5)/2)*2+1);
        if strcmp(configs{i}.Enviroment,'WT')
            t_trig = calc_trigger_time(t_tmp,dp(:,2)./mean(dp(end-500:end,2)));
            t_tmp = t_tmp-t_trig+offsets(i);
        else
            t_tmp = filtData(end).t(1:end)+offsets(i);
        end
        data(:,:,j) = interp1(t_tmp,dp,t,'linear');  
        means(j) = mean(filtData(j).RollRateWithRoll);
    end
    data = mean(data,3);
    subplot(3,1,[1,2])
    h = plot(t,configs{i}.Scaling(t,data(:,1)).*abs(data(:,2)));
    h.Color = configs{i}.Color;
    h.LineWidth = 2;
    h.LineStyle = configs{i}.LineSpec;
    if strcmp(configs{i}.Enviroment,'WT')
        h.DisplayName = configs{i}.Label;
    else
        h.Annotation.LegendInformation.IconDisplayStyle = 'off';
    end
    hold on
    
    subplot(3,1,3)
    h = plot(t,configs{i}.Scaling(t,data(:,1)).*abs(data(:,3)));
    h.Color = configs{i}.Color;
    h.LineWidth = 2;
    h.LineStyle = configs{i}.LineSpec;
    if strcmp(configs{i}.Enviroment,'WT')
        h.DisplayName = configs{i}.Label;
    else
        h.Annotation.LegendInformation.IconDisplayStyle = 'off';
    end
    hold on
    
end
sp = subplot(3,1,1:2);
grid minor
xlabel('Time [s]')
ylabel('p [$deg\,s^{-1}$]')
xlim(x_lim)
sp.FontSize = 13;

h = plot(NaN,NaN,'-');
h.DisplayName = 'Experimental';
h.Color = [0.1 0.1 0.1];
h = plot(NaN,NaN,'-.');
h.DisplayName = 'Simulated';
h.Color = [0.1 0.1 0.1];
l = legend('location','southeast');
l.FontSize = 13;

sp = subplot(3,1,3);
sp.FontSize = 13;
grid minor
xlabel('Time [s]')
ylabel('$\dot{p}$ [$deg\,s^{-1}$]')
xlim(x_lim)
% title(['Velocity: ',num2str(velocities(v_i)),' [m/s]'])

end
end

filename = '/Users/fintan/Desktop/Figures/time_trace.png';
exportgraphics(fig_handle,filename,'BackgroundColor','white')
