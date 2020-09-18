function [enc_deg_filt,t] = LoadEncoderData(RunNumber,localDir)
%LOADENCODERDATA Summary of this function goes here
%   Detailed explanation goes here
addpath('../CommonLibrary')
if ~exist('localDir','var')
    localDir = '../../data/';
end

runData = LoadRunNumber(RunNumber,localDir);

datumData = LoadRunNumber(runData.cfg.ZeroRun,localDir);

datum_enc_v = mean(datumData.daq.encoder.v(100:end-100));
%datum_enc_deg = (datum_enc_v - 0.025) / 4.975 * 360;
%enc_const = datumData.cfg.velocity-datum_enc_deg;

datum_enc_deg = (datum_enc_v) * -72.8;
enc_const = datumData.cfg.RollAngle-datum_enc_deg;

enc_v = runData.daq.encoder.v;

%turn into degrees and remove jumps
%enc_deg = ((enc_v - 0.018) / 4.96 * 360);
enc_deg = enc_v * -72.8;
%enc_deg = enc_v * -73.1449 + 72.4704;

%enc_deg = ((enc_v) / 5 * 360);
%enc_deg(1:100)=[];
for i=1:length(enc_deg)-1
    if abs(enc_deg(i+1)-enc_deg(i))>180
        val = enc_deg(i+1)-enc_deg(i);
        sign = val/abs(val);
        enc_deg(i+1:end) = enc_deg(i+1:end) - 360*sign;
    end
end

enc_deg_filt = movmean(medfilt1(enc_deg,3,'omitnan','truncate'),[8 8],'omitnan');
enc_deg_filt = enc_deg_filt + enc_const;
t = runData.daq.t;
end

