function [enc_deg_filt,t] = LoadEncoderData(RunNumber,dataDir,filt)
%LOADENCODERDATA Summary of this function goes here
%   Detailed explanation goes here

if ~exist('filt','var')
    filt = true;
end

addpath('../../CommonLibrary')
runData = LoadRunNumber(RunNumber,dataDir);

datumData = LoadRunNumber(runData.cfg.ZeroRun,dataDir);

datum_enc_v = mean(datumData.daq.encoder.v(100:end-100));
%datum_enc_deg = (datum_enc_v - 0.025) / 4.975 * 360;
%enc_const = datumData.cfg.velocity-datum_enc_deg;

datum_enc_deg = (datum_enc_v) * 72.8;
enc_const = datumData.cfg.RollAngle-datum_enc_deg;

enc_v = runData.daq.encoder.v;

%turn into degrees and remove jumps
enc_deg = enc_v * 72.8;

for i=1:length(enc_deg)-1
    if abs(enc_deg(i+1)-enc_deg(i))>180
        val = enc_deg(i+1)-enc_deg(i);
        sign = val/abs(val);
        enc_deg(i+1:end) = enc_deg(i+1:end) - 360*sign;
    end
end

if filt
    fs = runData.daq.rate;
    order = fs;
    cutoff = 10;
    shape = [1 1 0 0];
    frex = [0, cutoff, cutoff+5,fs/2]/(fs/2);

    filtkern = firls(order,frex,shape);
    enc_deg_filt = filtfilt(filtkern,1,enc_deg) + enc_const;
else
    enc_deg_filt = enc_deg + enc_const;
end
t = runData.daq.t;
end

