function res = runOneMinusCosine(d,daq_obj,vanes,freq,amplitude,Inverted)
%RUNONEMINUSCOSINE Summary of this function goes here
%   Detailed explanation goes here
d.cfg.GustFreq = freq;
d.cfg.GustAmplitude = amplitude;
d.cfg.GustInverted = Inverted;
gustDuration = 1/d.cfg.GustFreq*5;
gustDuration = min(gustDuration,d.cfg.MaxGustTestDuration);
gustDuration = max(gustDuration,d.cfg.MinGustTestDuration);
d.cfg.testDuration = gustDuration + d.cfg.gustPauseDuration;
vanes.setOneMinusCosine(d.cfg.GustAmplitude,d.cfg.GustFreq,...
    d.cfg.GustInverted)
GustTimer = vanes.getRunTimer(1/d.cfg.GustFreq);
% set the start time
if Inverted
    sign = -1;
else 
    sign = 1;
end
fprintf('Starting 1MC Gust, Amp: %.1f m/s, Freq %.1f s...\n',amplitude*sign,freq);
d.cfg.datetime = datetime();

% Run Test
daq_obj.runTestBackground(seconds(d.cfg.testDuration));
pause(d.cfg.gustPauseDuration)
start(GustTimer)
wait(GustTimer)

% get Data
res = daq_obj.getBackgroundData(d);
end

