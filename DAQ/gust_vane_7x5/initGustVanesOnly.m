function [TOP_DRIVE,BOT_DRIVE] = initGustVanesOnly()
%% Folding Wingtip WTT DAQ - Init Gust Vanes
% Created: R.C.M. Cheung
% Contact: r.c.m.cheung@bristol.ac.uk
% Date: 11 NOV 2019
% Open connections to both drives
TOP_DRIVE = OpenDrive('192.168.1.101',502);
BOT_DRIVE = OpenDrive('192.168.1.102',502);
pause(0.5);
end
