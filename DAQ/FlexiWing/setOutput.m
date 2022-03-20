function [] = setOutput(s,d,sw)
%% Folding Wingtip WTT DAQ - Set Output
% Created: R.C.M. Cheung
% Contact: r.c.m.cheung@bristol.ac.uk
% Date: 11 NOV 2019

if(d.tab.sine)
    [servoCmd,~] = genTabSignalSineContinuous( ...
        d.tab.amplitudeDeg,d.tab.frequency, ...
        d.cfg.preGustPauseDuration+d.tab.timeOffset+d.cfg.padDuration, ...
        d.tab.duration, ...
        d.cfg.sampleDuration,d.daq.rate,d.tab.trimDeg);
elseif(d.tab.chirp)
    [servoCmd,~] = genTabSignalChirp( ...
        d.tab.amplitude,d.tab.frequency,d.tab.frequencyEnd, ...
        d.cfg.preGustPauseDuration+d.tab.timeOffset+d.cfg.padDuration, ...
        d.tab.duration, ...
        d.cfg.sampleDuration,d.daq.rate,d.tab.trimDeg);
else
    servoCmd = 0;
end
servoCmd(end) = d.tab.trimDeg;
servoCmd(end:length(d.cfg.sync)) = d.tab.trimDeg;
servoCmd = servoCmd*(8/45); % convert to voltage, factor: 4096/360/64 => 8/45
servoCmd = min(max(servoCmd,-10.0),10.0); % clamp voltage between +/- 10V
%servoCmd(1:round(end/2)) = 0;
if(d.gust.analogue)
    [gustCmd,~] = genSignalSineContinuous( ...
        d.gust.amplitudeDeg,d.gust.frequency, ...
        d.cfg.preGustPauseDuration+d.gust.timeOffset, ...
        d.gust.duration, ...
        d.cfg.sampleDuration,d.daq.rate,d.gust.offsetDeg);    
    gustCmd = gustCmd*(10/27); % convert to voltage, factor: 10/27
    gustCmd = min(max(gustCmd,-10.0),10.0); % clamp voltage between +/- 10V
    queueOutputData(s,[d.cfg.sync,servoCmd',gustCmd]); % output data
else
    queueOutputData(s,[d.cfg.sync,servoCmd']); % output data
end
if(sw) % controlled by length of output signal
    s.NotifyWhenDataAvailableExceeds = size(d.cfg.sync,1);
end
end