function [slope,const] = encoderCalibration()
%% Folding Wingtip WTT DAQ - Encoder Calibration
% Created: R.C.M. Cheung
% Contact: r.c.m.cheung@bristol.ac.uk
% Date: 11 NOV 2019

FA_V_ref = 3.3; % full range encoder voltage
FA_V_o = 1.65; % zero-fold encoder voltage
slope = 360.0/FA_V_ref;
const = -360.0*FA_V_o/FA_V_ref;
end