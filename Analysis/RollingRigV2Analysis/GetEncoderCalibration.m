restoredefaultpath;
addpath('../CommonLibrary')

% set global parameters
localDir = '../../data/';  % the directory containing the 'data' folder

load([localDir,'../MetaData.mat'],'MetaData');     % the Metadata filepath

runs = 2033:2035;

angles = zeros(size(runs));
voltage = zeros(size(runs));


for i = 1:length(runs)
   d = LoadRunNumber(runs(i));
   angles(i) = d.cfg.RollAngle;
   voltage(i) = mean(d.daq.encoder.v);
end
figure(1)
clf;
plot(voltage,angles,'o')
xrange = 0:0.01:5;
p = polyfit(voltage,angles,1);
p(1) = -72.8;
p(2) = p(2) - 0.3559;
hold on
plot(xrange,polyval(p,xrange),'-')
ylabel('encoder Angle [Deg]')
xlabel('Encoder Voltage [Volts]')
grid minor


error = polyval(p,voltage)-angles;

