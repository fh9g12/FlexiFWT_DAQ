function saveBgData(src,event)
%% Folding Wingtip WTT DAQ - Save Background Data
% Created: R.C.M. Cheung
% Contact: r.c.m.cheung@bristol.ac.uk
% Date: 11 NOV 2019

NI.triggerTime = event.TriggerTime;
NI.data = event.Data;
NI.timeStamps = event.TimeStamps;
save('tmp.mat','NI');
end