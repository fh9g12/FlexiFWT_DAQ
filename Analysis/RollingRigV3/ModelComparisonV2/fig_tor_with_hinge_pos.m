clear all
restoredefaultpath;
addpath('../../CommonLibrary')
addpath('../')

colors = linspecer(6,'qualitative');

op = OperatingPoint();
op.semi_span = 0.5;
op.sigma = 0.272;
op.roll_rate = 120;
op.V = 15;
op.flare = 30;
op.c = 0.067;
op.m = 0.05;
op.l = 0.068;

increment = 0.001;

op = op.load_dist('/Users/fintan/Git/FwtModels/Workbooks/15_Rolling Rig V3/LiftDistribution_aoa_0_rr_60_span_100.csv');
y=increment:increment:op.semi_span;

f = figure(1);

sigmas = 0:0.01:0.5;
torques = zeros(2,length(sigmas));
flares = [10,20,30];

for f_i = 1:length(flares)
    for i = 1:length(sigmas)
        op.sigma = sigmas(i);
        op.flare = flares(f_i);
        op.m = 0.05/0.272*op.sigma;
        op.l = 0.068/0.272*op.sigma;
        zero_moment_angle = fminsearch(@(x)op.hinge_moment(y,x).^2,0);
        torques(f_i,i) = op.fwt_roll_damping(y,zero_moment_angle);
    end
end

f = figure(1);
f.Position = [100 100 740 440];
clf;


plot(sigmas,torques)
hold on
legend(["10","20","30"])
% filename = '/Users/fintan/Desktop/Figures/aoa_versus_span.png';
% exportgraphics(f,filename,'BackgroundColor','white')




function x = clip(x,max)
    x(x>max) = max;
end
