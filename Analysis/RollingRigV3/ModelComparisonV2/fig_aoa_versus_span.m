clear all
addsandbox

colors = linspecer(6,'qualitative');

op = OperatingPoint();
op.semi_span = 0.5;
op.sigma = 0.272;
op.roll_rate = 60;
op.V = 15;
op.flare = 30;
op.c = 0.067;

increment = 0.001;

op = op.load_dist('/Users/fintan/Git/FwtModels/Workbooks/15_Rolling Rig V3/LiftDistribution_aoa_0_rr_60_span_100.csv');
op_removed = op.load_dist('/Users/fintan/Git/FwtModels/Workbooks/15_Rolling Rig V3/LiftDistribution_aoa_0_rr_60_span_73.csv');
op_removed.semi_span = 0.5*(1-0.272);
op_removed.sigma = 0;
y=increment:increment:op.semi_span;
y_removed = increment:increment:op_removed.semi_span;

fixed_aoa = op.spanwise_aoa(y,0);
fixed_lift = op.spanwise_lift(y,0);

removed_aoa = op_removed.spanwise_aoa(y_removed,0);
removed_lift = op_removed.spanwise_lift(y_removed,0);

zero_moment_angle = fminsearch(@(x)op.hinge_moment(y,x).^2,0);

fwt_aoa = op.spanwise_aoa(y,zero_moment_angle);
fwt_lift = op.spanwise_lift(y,zero_moment_angle);
fwt_inertial_lift = op.spanwise_lift(y,zero_moment_angle-0.5);
            
f = figure(1);
f.Position = [100 100 740 440];
clf;
sp = subplot(2,1,1);
hold on
h = plot(y,fixed_aoa);
h.LineWidth = 2;
h.Color = colors(1,:);
h.DisplayName = 'Fixed Case';

h = plot(y,fwt_aoa);
h.LineWidth = 2;
h.Color = colors(2,:);
h.DisplayName = 'Free Case';

h = plot(y(y >= op.hinge_pos()),fwt_aoa(y >= op.hinge_pos())-0.5,'-.');
h.LineWidth = 2;
h.Color = colors(2,:);
h.DisplayName = 'Free Case with Inertial Forces';

h = plot([0,op.semi_span],[0,0],'k--');
h.LineWidth = 2;
h.Annotation.LegendInformation.IconDisplayStyle = 'off';




%region 1 fill
y_1 = [y,op.semi_span,0];
aoa_1 = [fwt_aoa,0,0];
h = fill(y_1,aoa_1,'r');
h.FaceColor = colors(2,:);
h.FaceAlpha = 0.3;
h.LineStyle = 'none';
h.Annotation.LegendInformation.IconDisplayStyle = 'off';

l = legend('Location','southwest');
l.FontSize = 13;
xlabel('Span [m]')
ylabel('Induced AoA [deg]')
grid minor
sp.FontSize = 12;

a = annotation('textarrow',[0.3,0.4],[0.76,0.8],'String','Region 1 ');
a.FontSize = 14;
a = annotation('textarrow',[0.63,0.693],[0.89,0.875],'String','Region 2 ');
a.FontSize = 14;
a = annotation('textarrow',[0.8,0.85],[0.76,0.845],'String','Region 3 ');
a.FontSize = 14;


sp = subplot(2,1,2);

h = plot([0,op.semi_span],[0,0],'k--');
h.LineWidth = 2;
h.Annotation.LegendInformation.IconDisplayStyle = 'off';
hold on
h = plot(y,fixed_lift/increment);%.*y);
h.LineWidth = 2;
h.Color = colors(1,:);
h.DisplayName = 'Fixed Case';

h = plot(y,fwt_lift/increment);%.*clip(y,op.hinge_pos()));
h.LineWidth = 2;
h.Color = colors(2,:);
h.DisplayName = 'Free Case';

h = plot(y(y >= op.hinge_pos()),fwt_inertial_lift(y >= op.hinge_pos())/increment);%*op.hinge_pos());
h.LineWidth = 2;
h.LineStyle = '-.';
h.Color = colors(2,:);
h.DisplayName = 'Free Case with Inertial Forces';

h = plot(y_removed,removed_lift/increment);%.*y_removed);
h.LineWidth = 2;
h.Color = colors(3,:);
h.DisplayName = 'Removed Case';


%region 1 fill
y_1 = [y(y < op.hinge_pos()),fliplr(y_removed)];
area = [fwt_inertial_lift(y < op.hinge_pos()),fliplr(removed_lift)]/increment;
h = fill(y_1,area,'r');
h.FaceColor = colors(2,:);
h.FaceAlpha = 0.15;
h.LineStyle = 'none';
h.Annotation.LegendInformation.IconDisplayStyle = 'off';

a = annotation('textarrow',[0.3,0.4],[0.3,0.35],'String','Region 1a ');
a.FontSize = 14;

a = annotation('textarrow',[0.58,0.63],[0.225,0.26],'String','Region 1b ');
a.FontSize = 14;


l = legend('Location','southwest');
l.Orientation = 'horizontal';
l.FontSize = 14;
grid minor
sp.FontSize = 12;
ylim([-2,0.5])

xlabel('Span [m]')
ylabel('Lift per unit span [$Nm^{-1}$]')

filename = '/Users/fintan/Desktop/Figures/aoa_versus_span.png';
exportgraphics(f,filename,'BackgroundColor','white')




function x = clip(x,max)
    x(x>max) = max;
end
