clear all
T = readtable('/Users/fintan/Git/FlexiFWT_DAQ/Analysis/RollingRigV3/ModelComparisonV2/HingeData.csv');
Hingedata = struct();
Hingedata.Flare = T.Flare;
Hingedata.sigma = T.sigma;
Hingedata.tau = T.t;

T = readtable('/Users/fintan/Git/FlexiFWT_DAQ/Analysis/RollingRigV3/ModelComparisonV2/SpanData.csv');
SpanData = struct();
SpanData.Flare = T.Flare;
SpanData.Span = T.s;
SpanData.tau = T.t;

colors = linspecer(2,'qualative');

enviroments = ["sim"];
configs = ["free10","free30"];


fig_handle = figure(1);
fig_handle.Position = [1774,497,801,245];
clf
sp = subplot(1,2,2);
flares = [10,30];

for i = 1:length(flares)
   config = ConfigMeta.CreateMeta(configs(i));
   ind = Hingedata.Flare == config.Flare;
   h = plot(Hingedata.sigma(ind),Hingedata.tau(ind) );
   h.LineWidth = 2;
   h.Color = colors(i,:);
   h.DisplayName = config.Label;
   hold on
end

h = plot([0,0.5],[-0.43313,-0.43313],'-.');
h.Color = [0.3 0.3 0.3];
h.DisplayName = 'Fixed Case';
h.LineWidth = 2;
h = plot([0,0.5],[-0.155,-0.155],'--');
h.Color = [0.3 0.3 0.3];
h.DisplayName = 'Removed Case';
h.LineWidth = 2;
xlim([0.1,0.5])
legend('location','southeast')
ylabel('Required Aileron Torque [Nm]')
xlabel('Sigma')
sp.FontSize = 13;
grid

sp = subplot(1,2,1);
for i = 1:length(flares)
   config = ConfigMeta.CreateMeta(configs(i));
   ind = SpanData.Flare == config.Flare;
   h = plot(SpanData.Span(ind),SpanData.tau(ind) );
   h.LineWidth = 2;
   h.Color = colors(i,:);
   h.DisplayName = config.Label;
   hold on
end

h = plot([0.8,1.5],[-0.155,-0.155],'--');
h.Color = [0.3 0.3 0.3];
h.LineWidth = 2;
h.DisplayName = 'Removed Case';
xlim([0.8,1.5])
ylabel('Required Aileron Torque [Nm]')
xlabel('Span [m]')
sp.FontSize = 13;

legend('location','northwest')
grid
filename = '/Users/fintan/Desktop/Figures/fwt_geom.eps';
exportgraphics(fig_handle,filename,'BackgroundColor','none','ContentType','vector')

