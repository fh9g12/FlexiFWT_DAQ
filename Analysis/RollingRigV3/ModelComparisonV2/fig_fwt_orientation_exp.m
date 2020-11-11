clear all;
%close all;
addsandbox
SimData = load_fixed_data('FixedData.csv');
SimData = [SimData , load_fixed_data('FreeData.csv')];
[SimData.RunType] = deal('Release_GoPro');

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
RunData = get_roll_rate_with_roll(RunData,'stepSize',5,'upperLimit',360);
RunData = get_angles_with_roll(RunData,'stepSize',5,'upperLimit',360);

for i = 1:length(RunData)
    RunData(i).V = round(RunData(i).Velocity/5)*5;
end

% define configs
config = ConfigMeta.CreateMeta('free10')...
    .set_T(0.12).set_enviroment('WT','-');

loc = [2.5,50,133,170,297];
label = ["A","B","C","D","E"];

AileronAngle = 14;
velocity = 20;

%% plot normailised with roll rate
f_handle = figure(3);
f_handle.Position = [20 20 1200 400];
clf;
sp = subplot(1,3,[1,2]);
% Build Filter
f = config.create_filter();  
f{end+1} = {'AileronAngle',AileronAngle};
f{end+1} = {'V',velocity};
filtData = filter_struct(RunData,f);

bins = filtData(1).RollBins_Angles;
[left_data,right_data,right_std,v] = deal(zeros(length(bins),length(filtData)));

%plot left 
for k = 1:length(filtData)
    %right data
    if strcmp(config.Enviroment,'WT')
        right_data(:,k) = -flip_folds(filtData(k).AnglesWithRoll(:,2));
        right_std(:,k) = -flip_folds(filtData(k).AnglesStdWithRoll(:,2));
        v = filtData.RollRateWithRoll;
    else
        right_data(:,k) = -flip_folds(filtData(k).AnglesWithRoll(:,3));
        right_std(:,k) = -flip_folds(filtData(k).AnglesStdWithRoll(:,3));
        v = filtData.RollRateWithRoll;
    end
end
yyaxis left
fold_angles = nanmean(right_data,2);
fold_std = nanmean(right_std,2);
hold on
h = plot(bins,fold_angles,'-'); 
h.LineWidth =2;       
h.DisplayName = 'Right Fold Angle';

h = fill([bins;flipud(bins)],...
    [(fold_angles+fold_std);flipud(fold_angles-fold_std)],'b');
h.FaceAlpha = 0.2;
h.LineStyle = 'none';
h.DisplayName = 'Standard deviation';

var_from_mean = nanmean(right_data,2) - nanmean(right_data,'all');

yyaxis right
h = plot(bins,to_orn(bins-nanmean(right_data,2)),'-');
h.LineWidth =2;
h.Annotation.LegendInformation.IconDisplayStyle = 'off';
h = plot([0,360],[0,0],'--');
h.LineWidth = 2;
h.Annotation.LegendInformation.IconDisplayStyle = 'off';

for l_i = 1:length(loc)
    h = plot([loc(l_i),loc(l_i)],[-100,100],':');
    h.LineWidth = 2;
    h.Color = [0.7 0.7 0.7];
    h.Annotation.LegendInformation.IconDisplayStyle = 'off';
    t = text(loc(l_i),95,label(l_i));
    t.FontSize = 13;
end
xlim([0,360])
xticks(0:45:360)
xticklabels(0:-45:-360)
xlabel('Roll Angle [deg]')
yyaxis left
ylim([-50,60])
ylabel('Fold Angle [deg]')
yyaxis right
ylim([-90,90])
ylabel('Orientation [deg]')
grid minor
sp.FontSize = 13;
legend('location','northeast')

subplot(1,3,3)
for l_i = 1:length(loc)
    fold = interp1(bins,nanmean(right_data,2),loc(l_i));
    h = plot_wing(-loc(l_i),fold,1,'sigma',0.3,...
        'Label',label(l_i),'legend',l_i == 1);
    hold on
end
xlim([-1.2,1.2])
axis equal
set(gca,'xtick',[])
set(gca,'ytick',[])
legend()



filename = '/Users/fintan/Desktop/Figures/fwt_orientation_exp.png';
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

function angles = to_orn(angles)
angles(angles>90 & angles<=270) = 180 - angles(angles>90 & angles<=270);
angles(angles>270) = angles(angles>270) - 360;
end