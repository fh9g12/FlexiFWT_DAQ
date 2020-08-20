function [enc_deg_filt,t] = LoadEncoderData(RunNumber)
%LOADENCODERDATA Summary of this function goes here
%   Detailed explanation goes here
addpath('../CommonLibrary')
runData = LoadRunNumber(RunNumber);

datumData = LoadRunNumber(runData.cfg.ZeroRun);

datum_enc_v = mean(datumData.daq.encoder.v(100:end-100));
datum_enc_deg = (datum_enc_v - 0.018) / 4.96 * 360;
enc_const = datumData.cfg.velocity-datum_enc_deg;

enc_v = runData.daq.encoder.v;

%turn into degrees and remove jumps
enc_deg = ((enc_v - 0.018) / 4.96 * 360);
enc_deg(1:100)=[];
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

