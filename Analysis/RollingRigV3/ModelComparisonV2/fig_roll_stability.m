clear all
addsandbox

colors = linspecer(6,'qualitative');

op = OperatingPoint();
op.semi_span = 0.5;
op.sigma = 0.272;
op.roll_rate = 0;
op.V = 15;
op.flare = 10;
op.c = 0.067;
op.m = 0.05;
op.l = 0.068;


increment = 0.001;

op = op.load_dist('/Users/fintan/Git/FwtModels/Workbooks/15_Rolling Rig V3/LiftDistribution_aoa_0_rr_60_span_100.csv');

y=increment:increment:op.semi_span;

roll = -180:5:180;
vs = [15,25,35];
fig_handle = figure(1);
fig_handle.Position = [2185,340,961,352];
colors = linspecer(12,'qualitative');
colors = colors([1,3,7,8],:);
styles = ["-","--","-.",":"];
clf;

torque = zeros(length(roll),2,length(vs));
angles = zeros(length(roll),2,length(vs));

for v_i = 1:length(vs)
    op.V = vs(v_i);
    for i = 1:length(roll)
        op.roll_angle = roll(i);
        angles(i,1,v_i) = fminsearch(@(x)op.hinge_moment(y,x).^2,0);
        torque(i,1,v_i) = op.hinge_force(y,angles(i,1,v_i))*op.hinge_pos();
        op.roll_angle = roll(i)+180;
        angles(i,2,v_i) = fminsearch(@(x)op.hinge_moment(y,x).^2,0);
        torque(i,2,v_i) = op.hinge_force(y,angles(i,2,v_i))*op.hinge_pos();
    end
end


for v_i = 1:length(vs)
    figure(1)
    subplot(1,5,[1:3]);
    h = plot(roll,sum(torque(:,:,v_i),2));
    h.Color = colors(v_i,:);
    h.LineWidth = 2.5;
    h.LineStyle = styles(v_i);
    h.DisplayName = ['Velocity $',num2str(vs(v_i)),'\,m\,s^{-1}$'];
    hold on
end

diagram_roll = [0,40,65,90];
labels = ["A","B","C","D"];
for i = 1:length(diagram_roll)
    subplot(1,5,1:3);
    h=plot([diagram_roll(i),diagram_roll(i)],[-1,1],'--');
    h.Color = [0.3,0.3,0.3];
    h.Annotation.LegendInformation.IconDisplayStyle ='off';
    t = text(diagram_roll(i)-1.3,0.128,labels(i));
    t.FontSize = 13;
    hold on
    subplot(1,5,4:5);
    ind = find(roll==diagram_roll(i),1);
    plot_wing(diagram_roll(i),angles(ind,1),1,0.3,labels(i),0);
    hold on
    if i == 1
        leg = 1;
    else 
        leg = 0;
    end
    plot_wing(diagram_roll(i)+180,angles(ind,2),1,0.3,labels(i),leg);
end

%% make plots pretty
sp = subplot(1,5,1:3);
sp.FontSize = 13;
ylim([-0.12,0.12])
xlim([-90,90])
l = legend('location','northwest');
l.FontSize = 13;
xlabel('Roll Angle [deg]')
ylabel('Total wingtip torque [$Nm$]')

sp = subplot(1,5,4:5);
sp.FontSize = 13;
xlim([-1.2,1.2])
axis equal
l = legend('location','southeast');
l.FontSize = 13;
xticks([])
yticks([])

filename = '/Users/fintan/Desktop/Figures/roll_stabilty.eps';
exportgraphics(fig_handle,filename,'BackgroundColor','none','ContentType','vector')




function h = plot_wing(roll,fold,s,sigma,lab,leg)
    x = [0,s*(1-sigma)*cosd(roll),s*(1-sigma)*cosd(roll)+s*sigma*cosd(roll-fold)];
    y = [0,s*(1-sigma)*sind(roll),s*(1-sigma)*sind(roll)+s*sigma*sind(roll-fold)];
    
    
    fwt_x = @(x)s*x*sigma*cosd(roll-fold);
    fwt_y = @(x)s*x*sigma*sind(roll-fold);
    f_x = @(x)s*(1-sigma)*cosd(roll)+fwt_x(x);
    f_y = @(x)s*(1-sigma)*sind(roll)+fwt_y(x);
    x_text = f_x(1.3);
    y_text = f_y(1.3);    

    h = plot(x(2),y(2),'o');
    h.MarkerFaceColor = [0 0 0];
    h.MarkerSize = 6;
    h.Annotation.LegendInformation.IconDisplayStyle = 'off';
    hold on   
    
    g_mag = 0.2;
    g = sum([-g_mag,0].*[fwt_x(1),fwt_y(1)]./norm([fwt_x(1),fwt_y(1)])); 
    lift = -g;
    
    q = quiver(f_x(0.5),f_y(0.5),0,-g_mag,'color',[0.8 0.2 0.2]);
    q.AutoScale = 'off';
    q.MaxHeadSize = 0.5;
    q.LineWidth = 1;
    q.LineStyle = '-';   
    if leg
        q.DisplayName = 'Gravitational Force';
    else
        q.Annotation.LegendInformation.IconDisplayStyle = 'off';
    end
    
    lift_vec = [lift*cosd(roll-fold+90),lift*sind(roll-fold+90)];
    
    q = quiver(f_x(0.5),f_y(0.5),lift_vec(1),lift_vec(2),'b');
    q.AutoScale = 'off';
    q.MaxHeadSize = 0.5;
    q.LineWidth = 3;
    q.LineStyle = '-';   
    if leg
        q.DisplayName = 'Lift Force';
    else
        q.Annotation.LegendInformation.IconDisplayStyle = 'off';
    end
    
    h = plot(x,y,'k-');
    h.LineWidth = 1;
    h.Annotation.LegendInformation.IconDisplayStyle = 'off';
    
    if cosd(roll)<0
        x_text = f_x(1.4);
        y_text = f_y(1.4);
    else
        x_text = f_x(1.3);
        y_text = f_y(1.3);
    end
    t = text(x_text,y_text,lab);
    t.FontSize = 13;
end