clear all;
close all;
addsandbox;

SimData = load_fixed_data('FixedData.csv');
% SimData = [SimData , load_fixed_data('RemovedData.csv')];
SimData = [SimData , load_fixed_data('FreeData.csv')];

load('../RunData.mat')


[RunData.Source] = deal('WT');
[RunData.LiftDist] = deal('Roll60');
[RunData.T] = deal(0.12);

RunData = concat_structs(RunData,SimData);

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

I =  ~cellfun(@isempty,{RunData.GoProNumber});
VidData = RunData(I);
VidData = get_angles_with_roll(VidData,'stepSize',5,'upperLimit',360);

configs = [...
    ConfigMeta.CreateMeta('free10').set_T(0.12).set_enviroment('WT','-'),...
    ConfigMeta.CreateMeta('free30').set_T(0.12).set_enviroment('WT','-')...
    ];

sim_data = readtable('CoastData_level_sintan.csv');

ind =1;
f_handle = figure(1);
f_handle.Position = [200 200 650 450];
clf
hold on
velocities = [15,20,25,30];
dists = ["Roll60","AoA5","Level"];
style = ["-","--","-.",":",":"];
dist_names = ["Roll Rate 60 $deg\,s^{-1}$, Velocity 22.5 $m\,s^{-1}$",...
    "AoA 5 $deg$, Velocity 22.5 $m\,s^{-1}$",...
    "Constant $2\pi$",...
    "Constant $2\pi$, Tapered on Wingtip",...
    "Level"];
for i = 1:length(velocities)
    for j = 1:length(configs)
        f = configs(j).create_filter();
        f{end+1} = {'AileronAngle',[7,14,21]};
        f{end+1} = {'V',velocities(i)};
        vData = filter_struct(VidData,f);
        
        [left_fold_angle,right_fold_angle] = deal([]);
    %     vData = VidData([VidData.Velocity]==velocities(i));
        if ~isempty(vData)
            for k = 1:length(vData)
                if length(vData(k).t)>500
                    right_fold_angle = [right_fold_angle;mean(vData(k).ts_data(10:30,3))];
                    left_fold_angle = [left_fold_angle;mean(vData(k).ts_data(10:30,4))];    
                end        
            end      
            h = plot(velocities(i),mean(right_fold_angle,'all'),'o');
            h.MarkerFaceColor = configs(j).Color;
            h.MarkerEdgeColor = [0 0 0];
            if i == 1
                h.DisplayName = ['Experimental Data: Right Wingtip, ',configs(j).Label];
            else
                h.Annotation.LegendInformation.IconDisplayStyle = 'off';
            end
            hold on
            h = plot(velocities(i),mean(left_fold_angle,'all'),'d');
            h.MarkerFaceColor = configs(j).Color;
            h.MarkerEdgeColor = [0 0 0];
            if i == 1
                h.DisplayName = ['Experimental Data: Left Wingtip, ',configs(j).Label];
            else
                h.Annotation.LegendInformation.IconDisplayStyle = 'off';
            end
        end
    end
end

for j = 1:length(configs)
    figure(1)
%     tmp_ind = sim_data.RollRate == 0;
    tmp_ind = round(sim_data.Flare) == configs(j).Flare;
    tmp_ind = tmp_ind & sim_data.Camber == configs(j).Camber;
    for d = [1,2,length(dists)]
        dist_ind = tmp_ind & strcmp(sim_data.LiftDist,dists(d));
        sim_v = unique(sim_data.V);
        sim_ca = zeros(length(sim_v),1);
        for r = 1:length(sim_v)
            roll_ind = sim_data.V == sim_v(r);
%             roll_ind = roll_ind & sim_data.Roll == 0;
            sim_ca(r) = nanmean(sim_data.CoastAngle(dist_ind & roll_ind));
        end
        h = plot(sim_v,abs(sim_ca),style(d));
        h.Color = configs(j).Color;
        h.Annotation.LegendInformation.IconDisplayStyle = 'off';
        h.LineWidth = 1.5;
        if j == length(configs)
            h = plot(NaN,NaN,style(d));
            h.Color = [0.1 0.1 0.1];
            h.DisplayName = ['Simulated Lift Distribution: ',char(dist_names(d))];
        end
    end
end
ylim([0,45])
grid minor
legend
xlabel('Velocity [$ms^{-1}$]')
ylabel('Coast Angle [$deg$]')

f_handle.Children(2).FontSize = 13;
filename = '/Users/fintan/Desktop/Figures/coast_angles.eps';
exportgraphics(f_handle,filename,'BackgroundColor','none','ContentType','vector')

% title('Simulated and Experimantal coast angle in the steady level condition')
clear RunData
