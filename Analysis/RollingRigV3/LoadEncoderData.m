function [enc_deg_filt_ds,t_ds] = LoadEncoderData(RunNumber,dataDir,sampleRate,filt,cutoff)
%LOADENCODERDATA Summary of this function goes here
%   Detailed explanation goes here

if ~exist('filt','var')
    filt = true;
end
if ~exist('cutoff','var')
    cutoff = 40;
end
if ~exist('sampleRate','var')
    sampleRate = 1700;
end
gain = 72.8;
runData = LoadRunNumber(RunNumber,dataDir);

datumData = LoadRunNumber(runData.cfg.ZeroRun,dataDir);

datum_enc_v = mean(datumData.daq.encoder.v(100:end-100));
%datum_enc_deg = (datum_enc_v - 0.025) / 4.975 * 360;
%enc_const = datumData.cfg.velocity-datum_enc_deg;

datum_enc_deg = (datum_enc_v) * gain;
enc_const = datumData.cfg.RollAngle-datum_enc_deg;

enc_v = runData.daq.encoder.v;

%turn into degrees and remove jumps
enc_deg = enc_v * gain;

for i=1:length(enc_deg)-1
    if abs(enc_deg(i+1)-enc_deg(i))>180
        val = enc_deg(i+1)-enc_deg(i);
        sign = val/abs(val);
        enc_deg(i+1:end) = enc_deg(i+1:end) - 360*sign;
    end
end

% e = TG_energy(enc_deg);
% ind = find(abs(abs(e)-abs(movmedian(e,101)))>1000);
% enc_deg(ind) = NaN;
% for i = 1:length(ind)
%     min_i = max(0,ind(i)-50);
%     max_i = min(length(enc_deg),ind(i)+50);
%     enc_deg(ind(i)) = nanmedian(enc_deg(min_i:max_i));
% end

if filt
    fs = runData.daq.rate;
    order = fs*2;
    shape = [1 1 0 0];
    frex = [0, cutoff, cutoff+5,fs/2]/(fs/2);

    filtkern = firls(order,frex,shape);
    enc_deg_filt = filtfilt(filtkern,1,enc_deg) + enc_const;
else
    enc_deg_filt = enc_deg + enc_const;
end

% downsample the data
t = runData.daq.t;

t_max = floor(t(end)*100)/100;
t_ds = (0:1/sampleRate:t_max)';
enc_deg_filt_ds = interp1(t,enc_deg_filt,t_ds);
end

function e = TG_energy(y)
    e = y(2:end-1).^2-y(1:end-2).*y(3:end);
end

