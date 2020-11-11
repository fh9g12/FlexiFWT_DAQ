clear all;
%close all;
addsandbox

SimData = load_fixed_data('FixedData.csv');
% SimData = [SimData , load_fixed_data('RemovedData.csv')];
SimData = [SimData , load_fixed_data('FreeData.csv')];
SimData = SimData(strcmp(string({SimData.LiftDist}),'Roll60'));



load('../RunData_500.mat')
[RunData.Source] = deal('WT');
[RunData.T] = deal(0.12);
RunData = RunData(strcmp(string({RunData.RunType}),'Release_GoPro'));


RunData = concat_structs(RunData,SimData);

% create V channel
for i = 1:length(RunData)
    RunData(i).V = round(RunData(i).Velocity/5)*5;
end

% remove funky runs
runs = [1428,1446];
for i = 1:length(runs)
    I = find([RunData.RunNumber] == runs(i),1);
    if ~isempty(I)
        RunData(I) = [];
    end
end

% get binned roll rate with roll
RunData = get_roll_rate_with_roll(RunData,'stepSize',5,'upperLimit',180);

configs=[...
    ConfigMeta.CreateMeta('free10').set_enviroment('WT','-').set_T(0.12).set_Label('10 Degrees Flare'),...
    ConfigMeta.CreateMeta('free30').set_enviroment('WT','-').set_T(0.12).set_Label('30 Degrees Flare'),...
    ConfigMeta.CreateMeta('free10').set_enviroment('sim','-.').set_T(0.12).set_Label('10 Degrees Flare'),...
    ConfigMeta.CreateMeta('free30').set_enviroment('sim','-.').set_T(0.12).set_Label('30 Degrees Flare')...
    ];
configs=configs([1,3]);
fig_handle = figure(2);
fig_handle.Position =[1809,432,1278,353];
clf

velocities = [20];
aileron_input = [7];
range = [-10,30];
offsets = [0,0,0,0];
x_lim = [0,3];
colors = linspecer(12,'qualitative');

for a_i = 1:length(aileron_input)
for v_i = 1:length(velocities)
for i =1:length(configs)
%     if ~strcmp(configs{i}{1},'WT')
%         continue
%     end
    f = configs(i).create_filter();
    f{end+1} = {'AileronAngle',aileron_input(a_i)};
    f{end+1} = {'V',velocities(v_i)};
    filtData = filter_struct(RunData,f);
    if length(filtData)<1
        continue
    end
    t = 0:0.001:10;
    filtData = filtData(1);
    data_roll = zeros(length(t),3,length(filtData));
    data_angles = zeros(length(t),2,length(filtData));
    means = zeros(length(filtData),1);
    for j = 1:length(filtData)
        p = filtData(j).ts_data(:,1);
        angles_tmp = filtData.ts_data(:,3:4);
        t_tmp = filtData(j).t(1:end);
        mean_rr = mean(filtData(j).RollRateWithRoll);
        period = t_tmp(2)-t_tmp(1);
        fs = 1/period;        
        dp = get_sgolay_gradients(p,[0,1,2],period,5,floor((fs/5)/2)*2+1);
        if strcmp(configs(i).Enviroment,'WT')
            angles_tmp = lowpass(angles_tmp,1,500);
            t_trig = calc_trigger_time(t_tmp,dp(:,2)./mean(dp(end-500:end,2)));
            t_tmp = t_tmp-t_trig+offsets(i);
        else
            t_tmp = filtData(end).t(1:end)+offsets(i);
        end
        data_roll(:,:,j) = interp1(t_tmp,dp,t,'linear');  
        data_angles(:,:,j) = interp1(t_tmp,angles_tmp,t,'linear');
        means(j) = mean(filtData(j).RollRateWithRoll);
    end
    data_roll = mean(data_roll,3);
    
    if strcmp(configs(i).Enviroment,'WT')
        subplot(1,3,1)
    else
        subplot(1,3,2)
    end
    hold on
    roll = zeros(size(data_roll(:,1)));
    roll(data_roll(:,1)<0) = mod(data_roll(data_roll(:,1)<0,1),-360);
    roll(data_roll(:,1)>=0) = mod(data_roll(data_roll(:,1)>=0,1),360);
    
    
    I = abs(data_roll(:,1))<360;
    h = plot((t(I)),data_angles(I,1),'-');
    h.Color = colors(1,:);
    h.DisplayName = 'Right fold angle during first second';
    h.LineWidth = 3;
    
    h = plot((t(I)),data_angles(I,2),'-');
    h.Color = colors(5,:);
    h.LineWidth = 1;
    h.DisplayName = 'Left fold angle during first second';
    
    yyaxis right
    rr = data_roll(I,2);
    norm_rr = abs(rr/mean(means));    
    h = plot((t(I)),norm_rr,'-');
    h.Color = colors(4,:)*0.7;
    h.LineWidth = 2;
    h.DisplayName = 'Roll Rate during first second';
    hold on
    
    bins = -360:5:0;
    I = abs(data_roll(:,1))>360;
    mean_angle = bin_data(roll(I,1),data_angles(I,1),bins');
    yyaxis left
    h = plot(t(~I),interp1(bins,mean_angle,mod(roll(~I,1),-360)),'-.');
    h.Color = colors(1,:);
    h.Color(4) = 0.4;
    h.LineWidth=3;
    h.DisplayName = sprintf('%s\n%s','Average value in the steady','roll region for the same roll angle');
    
    mean_angle = bin_data(roll(I,1),data_angles(I,2),bins');
    h = plot(t(~I),interp1(bins,mean_angle,mod(roll(~I,1),-360)),'-.');
    h.Color = colors(5,:);
    h.Color(4) = 0.4;
    h.LineWidth=3;
    h.Annotation.LegendInformation.IconDisplayStyle = 'off';
    
    yyaxis right
    mean_roll = bin_data(roll(I,1),data_roll(I,2),bins');
    mean_roll = mean_roll/mean(mean_roll);
    h = plot(t(~I),interp1(bins,mean_roll,mod(roll(~I,1),-360)),'-.');
    h.Color = colors(4,:)*0.7;
    h.Color(4) = 0.4;
    h.LineWidth=3;
    h.Annotation.LegendInformation.IconDisplayStyle = 'off';
    
end

for s = 1:2
    sp = subplot(1,3,s);
    sp.FontSize = 15;
    xlim([0,1])
    yyaxis left;
    ylim([-20,60])
    ylabel('Fold Angle [deg]')
    yyaxis right;
    ylim([0,1.3])
    ylabel('Roll Rate [$deg\,s^{-1}$]')
    yticks([0.25,0.5,0.75,1])
    yticklabels(["$\frac{1}{4}p_s$","$\frac{1}{2}p_s$","$\frac{3}{4}p_s$","$p_s$"])
    xlabel('Time [s]')
    xticks([0,0.2,0.4,0.6,0.8,1])
    sp.YAxis(2).Color = colors(4,:)*0.7;
end
sp = subplot(1,3,1);
title('Experimental')
sp = subplot(1,3,2);
title('Simulated')
l=legend();
l.FontSize = 15;
l.Position = [0.641529399650944,0.397119776047661,0.213713166859228,0.264353311771036];
end
end

filename = '/Users/fintan/Desktop/Figures/accel_fwt_10.png';
exportgraphics(fig_handle,filename,'BackgroundColor','none','ContentType','vector')
