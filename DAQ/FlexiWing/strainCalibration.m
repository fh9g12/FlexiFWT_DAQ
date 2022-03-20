function [bmtC,epsC] = strainCalibration()
%% Folding Wingtip WTT DAQ - Strain Calibration
% Created: R.C.M. Cheung
% Contact: r.c.m.cheung@bristol.ac.uk
% Date: 11 NOV 2019

% strain to bending moment -> BMT = bmtC*epsVoltage;
bmtC = -1.025473398820473e+04; % direct calibration, JUL 2019
epsC = 1.0; % voltage scaling is 1.0, JUL 2019
end
