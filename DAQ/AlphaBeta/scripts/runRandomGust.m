function res = runRandomGust(d,daq_obj,vanes,gust_duration,amplitude)
%RUNONEMINUSCOSINE Summary of this function goes here
%   Detailed explanation goes here
d.cfg.GustAmplitude = amplitude;

d.cfg.testDuration = gust_duration + d.cfg.gustPauseDuration;
vanes.setRandomGust(gust_duration,d.cfg.GustAmplitude);
GustTimer = vanes.getRunTimer(gust_duration);
% set the start time
fprintf('Starting Random Gust, Amplitude: %.1f m/s, Duration %.1f s...\n',amplitude,gust_duration);
d.cfg.datetime = datetime();

% Run Test
daq_obj.runTestBackground(seconds(d.cfg.testDuration));
pause(d.cfg.gustPauseDuration)
start(GustTimer)
wait(GustTimer)

% get Data
res = daq_obj.getBackgroundData(d);
end

