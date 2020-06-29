function [C] = accCalibration()
%% Folding Wingtip WTT DAQ - Accelerometer Calibration
% Created: R.C.M. Cheung
% Contact: r.c.m.cheung@bristol.ac.uk
% Date: 11 NOV 2019

% sign convention: x +ve downstream; y +ve starboard; z -ve gravity

% wing accelerometers - channels 1-4
% M352C65 LW252616
% [x=0.25c, y=0.295] C=98.6 => wing's -ve z
% PCB 356A32
% [x=0.11c, y=0.820]x C=99.6 => wing's -ve y
% [x=0.11c, y=0.820]y C=97.6 => wing's +ve z
% [x=0.11c, y=0.820]z C=98.2 => wing's -ve x

% wing-tip accelerometers - channels 5-7
% Endevco 65L-100
% [x=0.11c, y=1.337]x C=105.3 => wing's +ve y
% [x=0.11c, y=1.337]y C=102.7 => wing's -ve z
% [x=0.11c, y=1.337]z C=105.8 => wing's -ve x
% M352C65 LW253480
% C=99.9

% tunnel mount accelerometers - channels 8-9
% SN26256
% Root Mount C=98.5 => wing's -ve x
% SN26252
% Root Mount C=101.1 => wing's -ve z
% SN25997
% C=98.9
% *** NOT FITTED ***

% z-direction accelerometers - channels 10-11
% 352C65 LW243795
% [x=0.62c, y=0.295] C=101.1 => wing's +ve z
% M352C65 LW253479
% [x=0.62c, y=0.820] C=98.7 => wing's -ve z

% *Endevco 65L at WT, cable coding: white-x, green-y, red-z

C = [-98.6, ...
    -99.6,97.6,-98.2, ...
    105.3,-102.7,-105.8, ...
    99.9,-98.5,-101.1, ...
    101.1,-98.7];
C = C*1e-3/100e-3; % due to assumed sensitivity of 100mv/g applied at the time of DAQ
end