clear all
addsandbox;

fig_handle = figure(2);
fig_handle.Position = [343,350,747,297];


clf;


colors = linspecer(1,'qualative');
x = [0,1,3];
y = [0,1,1];

h = plot(x,y,'r-');
h.LineWidth = 2;
h.Color = colors;
hold on
ylabel('Simulated Aileron Torque [$Nm$]')
xlabel('Time [$s$]')

xticks([0,1])
xticklabels(["0","$\tau_0$"])

yticks([0,1])
yticklabels({'0','$\tau_1V^2+\tau_2$'})

h = plot([0,1,1],[1,1,0],'--');
h.Color = [0.4 0.4 0.4];

ylim([0,1.2])
xlim([0,3])

fig_handle.Children(1).FontSize = 13;

filename = '/Users/fintan/Desktop/Figures/torque_diagram.eps';
exportgraphics(fig_handle,filename,'BackgroundColor','none','ContentType','vector')


