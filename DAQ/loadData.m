function [d] = loadData(s,d)
%% Folding Wingtip WTT DAQ - Load data
% Created: R.C.M. Cheung
% Contact: r.c.m.cheung@bristol.ac.uk
% Date: 11 NOV 2019


acc_channels = 12;


sNames = {s.Channels.Name};
p = load('tmp.mat');
d.daq.triggerTime = p.NI.triggerTime;
d.daq.date = datetime;
d.daq.t = p.NI.timeStamps;
d.daq.accelerometer.v = p.NI.data(:,1:acc_channels);
nn = 1;
for ii = 1:acc_channels
    d.daq.accelerometer.Name{nn} = sNames{ii};
    nn = nn+1;
end
d.daq.strain.v = p.NI.data(:,acc_channels+1);
d.daq.encoder.v = p.NI.data(:,acc_channels+8);
d.daq.sync.v = p.NI.data(:,acc_channels+9);
d.daq.servo.v = p.NI.data(:,acc_channels+10);
% Pick calibration matrix elements that correspond to channels in use
IDX = [1,2,4,5,9];
C = loadCalibration();
d.daq.loadcell.calibration = C(:,IDX);
d.daq.loadcell.v = p.NI.data(:,acc_channels+2:acc_channels+6);
nn = 1;
for ii = acc_channels+2:acc_channels+6
    d.daq.loadcell.Name{nn} = sNames{ii};
    nn = nn+1;
end
% Analogue gust
% d.daq.gust.v = p.NI.data(:,22);
d.daq.gust.v = p.NI.data(:,acc_channels+11);
end