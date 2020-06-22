function [] = endTest(s,d,lh,lh2)
%% Folding Wingtip WTT DAQ - End Test
% Created: R.C.M. Cheung
% Contact: r.c.m.cheung@bristol.ac.uk
% Date: 11 NOV 2019
%% Stop Gust Vanes
if(d.cfg.genGust)
    stopGustVanes(d.GustVane.TOP_DRIVE,d.GustVane.BOT_DRIVE);
end
%% Stop NI DAQ
stop(s);
delete(lh);
delete(lh2);
delete(s);
clear s
end