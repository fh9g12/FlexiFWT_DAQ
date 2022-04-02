close all;clc;fclose all;clear all
%% Required Input Data
base_data_dir = '..\data\'; % folder to store data in

d = struct();
d.cfg.rho = 1.225;
d.cfg.testDuration = 3; % sec
d.cfg.measurementPauseDuration = 0.1;
d.cfg.gustPauseDuration = 0.1;

d.cfg.ModelName = 'AlphaBeta';
d.cfg.FlareAngle = nan;
d.cfg.WingtipTwistAngle = 0;
d.cfg.AileronAngle = 0;
d.cfg.Locked = true; % (0/1)


d.cfg.Job = 'AlphaBetaGust';
d.cfg.TestType = 'GustFamily';

d.cfg.Rate = 100;
d.cfg.dataDirectory = fullfile(base_data_dir,date());


%% create daq object
daq_obj = AlphaBeta(d.cfg.Rate);
vanes = [GustVane('192.168.1.101',502),GustVane('192.168.1.102',502)];


%% setup gust
res = runOneMinusCosine(d,daq_obj,vanes,10,5,false);
figure(1);subplot(1,2,1);plot(res.t,res.daq.gust_vane_angle.val);
pause(3);
res = runRandomGust(d,daq_obj,vanes,10,1);
figure(1);subplot(1,2,2);plot(res.t,res.daq.gust_vane_angle.val);