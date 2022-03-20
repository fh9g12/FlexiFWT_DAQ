function [slope,const] = encoderCalibration()
%% Folding Wingtip WTT DAQ - Encoder Calibration
% Created: R.C.M. Cheung
% Contact: r.c.m.cheung@bristol.ac.uk
% Date: 11 NOV 2019

FA_V_ref = 5.00; % full range encoder voltage
FA_V_o = 2.77; % zero-fold encoder voltage
slope = 180.0/FA_V_ref;
const = -180.0*FA_V_o/FA_V_ref;
end