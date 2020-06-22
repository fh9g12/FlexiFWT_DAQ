function [outputData] = buildSyncSignal(SampleRate,SampleDuration)
%% Folding Wingtip WTT DAQ - Define sync line waveform
% Created: R.C.M. Cheung
% Contact: r.c.m.cheung@bristol.ac.uk
% Date: 11 NOV 2019

t = 0:1/SampleRate:SampleDuration;
f = 24.0; % frequency, Hertz
a = 1.0; % amplitude, volts
offset = 4.0; % offset, volts
w = 2*pi*f;
outputData = [offset+a*cos(w*t),0]'; % transpose to column per channel
end