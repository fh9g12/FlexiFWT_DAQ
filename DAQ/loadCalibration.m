function [C] = loadCalibration()
%% Folding Wingtip WTT DAQ - Load cell Calibration
% Created: R.C.M. Cheung
% Contact: r.c.m.cheung@bristol.ac.uk
% Date: 11 NOV 2019

% calibration matrix
C = [0,0,0,0,0,0,0,0,0,0,0,0;
    0,0,0,0,0,0,0,0,0,0,0,0;
    0,0.190131513462057,0,0,0,0,0,0,-0.371407339533839/2,0,0,0;
    0,-0.128942581834449,0,-0.00375821104584579,0,0,0,0,0.0510558886104422/2,0,0,0;
    0,0,0,0,0,0,0,0,0,0,0,0;
    0,0,0,0,0,0,0,0,0,0,0,0];
G = 4095/20.0; % convert gain
C = C*G; % forces
end