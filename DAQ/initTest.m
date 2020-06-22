function [s,d,lh,lh2] = initTest(d)
%% Folding Wingtip WTT DAQ - Init test
% Created: R.C.M. Cheung
% Contact: r.c.m.cheung@bristol.ac.uk
% Date: 11 NOV 2019
%% Timing
% Total period of sampling, sec
d.cfg.sampleDuration = d.cfg.preGustPauseDuration ...
    +d.gust.duration ...
    +d.cfg.postGustPauseDuration;
%% sync
d.cfg.sync = buildSyncSignal(d.daq.rate,d.cfg.sampleDuration);
% init DAQ
[s,~,lh,lh2] = daqInit(d.daq.rate);
% init Gust
if(d.gust.oneMinusCosine)
    d.GustVane.MODE = 3;
    d.cfg.genGust = 1;
elseif(d.gust.sine)
    d.GustVane.MODE = 2;
    d.cfg.genGust = 1;
elseif(d.gust.analogue)
    d.GustVane.MODE = 1;
    d.cfg.genGust = 1;
elseif(d.gust.chirp)
    d.GustVane.MODE = 4;
    d.cfg.genGust = 1;
elseif(d.gust.random)
    d.GustVane.MODE = 5;
    d.cfg.genGust = 1;
end
if(d.cfg.genGust)
    [d.GustVane.TOP_DRIVE,d.GustVane.BOT_DRIVE] = initGustVanesOnly();
end
end
