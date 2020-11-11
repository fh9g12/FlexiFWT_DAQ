
colors = linspecer(5,'qualitative');
f = figure(1);
f.Position = [0,0,800,250]+100;
clf;
[y,cl] = get_dist('/Users/fintan/Git/FwtModels/Workbooks/15_Rolling Rig V3/LiftDistribution_aoa_0_rr_60_span_100.csv');
h = plot(y,cl,'-');
h.Color = colors(1,:);
h.LineWidth = 2;
h.DisplayName = 'Span 1 [m], AoA 0 [Deg], Roll Rate 60 [Deg/s]';
hold on

[y,cl] = get_dist('/Users/fintan/Git/FwtModels/Workbooks/15_Rolling Rig V3/LiftDistribution_aoa_5_rr_0_span_100.csv');
h = plot(y,cl,'-');
h.Color = colors(2,:);
h.LineWidth = 2;
h.DisplayName = 'Span 1 [m], AoA 5 [Deg], Roll Rate 0 [Deg/s]';

[y,cl] = get_dist('/Users/fintan/Git/FwtModels/Workbooks/15_Rolling Rig V3/LiftDistribution_level_fwt_angle_2.csv');
cl(isnan(cl)) = 0;
h = plot(y,cl,'-');
h.Color = colors(3,:);
h.LineWidth = 2;
h.DisplayName = 'Span 1 [m], AoA 5 [Deg], Roll Rate 0 [Deg/s], FWT Angle 2 [Deg]';

[y,cl] = get_dist('/Users/fintan/Git/FwtModels/Workbooks/15_Rolling Rig V3/LiftDistribution_aoa_5_rr_0_span_73.csv');
h = plot(y,cl,'-');
h.Color = colors(4,:);
h.LineWidth = 2;
h.DisplayName = 'Span 0.738 [m], AoA 5 [Deg], Roll Rate 0 [Deg/s]';

[y,cl] = get_dist('/Users/fintan/Git/FwtModels/Workbooks/15_Rolling Rig V3/LiftDistribution_aoa_0_rr_60_span_73.csv');
h = plot(y,cl,'-');
h.Color = colors(5,:);
h.LineWidth = 2;
h.DisplayName = 'Span 0.738 [m], AoA 0 [Deg], Roll Rate 60 [Deg/s]';


l = legend('Location','southwest');
l.FontSize = 12;
ylim([0,7])
xlabel('spanwise location [m]')
ylabel('Local Lift Coefficent')
grid minor
f.CurrentAxes.FontSize = 12;

filename = '/Users/fintan/Desktop/Figures/dist_comp.png';
exportgraphics(f,filename,'BackgroundColor','white')
function [y,cl] = get_dist(file)
T = readtable(file);
cl = T.C_l;
y = T.y;
end

