clear all;
close all;
restoredefaultpath;
addpath('../CommonLibrary')
addpath('../CommonLibrary/ERA')

% set global parameters
localDir = '../../data/';  % the directory containing the 'data' folder

% Open the Meta-Data file
load([localDir,'../MetaData.mat']);     % the Metadata filepath

d = LoadRunNumber(1004);

figure(1)
subplot(2,1,1)
plot(d.daq.t,d.daq.strain.v)
xlabel('time [s]')
ylabel('Strain Gauge Voltage [V]')
title('variation in the stain gauge voltage from a steady release, AoA 2.5 deg, V 28.6 m/s, tab 0 -> -15 degrees')
grid minor

subplot(2,1,2)
plot(d.daq.t,d.daq.encoder.calibration.slope.*d.daq.encoder.v+d.daq.encoder.calibration.constant)
xlabel('time [s]')
ylabel('Fold Angle [Deg]')
title('variation in the fold angle from a steady release, AoA 2.5 deg, V 28.6 m/s, tab 0 -> -15 degrees')
grid minor

