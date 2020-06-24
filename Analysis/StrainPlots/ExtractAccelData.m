function [y,t] = ExtractAccelData(run,localDir)
%EXTRACTDATA Summary of this function goes here
%   Detailed explanation goes here
% get one of each velocity as an example


m = load([localDir,run.Folder,'/',run.Filename]);   
% encoder
enc_cal = m.d.daq.encoder.calibration;
enc = enc_cal.slope*m.d.daq.encoder.v + enc_cal.constant;

%strain gauge
strain_cal = m.d.daq.strain.calibration;
strain = strain_cal*m.d.daq.strain.v;

iAccel = 1:11;
% Accelerometer Data
for j = 1:length(iAccel)
    x = m.d.daq.accelerometer.calibration(iAccel(j))*m.d.daq.accelerometer.v(:,iAccel(j));
    v(:,j) = x;
end

y = [enc,strain,v];
t = m.d.daq.t;
end

