function [y,t] = ExtractData(localDir,run,dr,platform)
%EXTRACTDATA Summary of this function goes here
%   Detailed explanation goes here
% get one of each velocity as an example

if ~exist('platform','var')
    sep = '\';
elseif strcmp('Mac',platform)
    sep = '/';
else
    sep = '\';
end


m = load([localDir,run.Folder,sep,run.Filename]);   
% encoder
enc_cal = m.d.daq.encoder.calibration;
enc = enc_cal.slope*m.d.daq.encoder.v + enc_cal.constant;
enc = decimate(enc,dr);

%strain gauge
strain_cal = m.d.daq.strain.calibration;
strain = strain_cal*m.d.daq.strain.v;
strain = decimate(strain,dr);

y = [enc,strain];
t = decimate(m.d.daq.t,dr);
end

