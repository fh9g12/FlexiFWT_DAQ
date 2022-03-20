function [d] = initData()
%% Folding Wingtip WTT DAQ - Init Data
% Created: R.C.M. Cheung
% Contact: r.c.m.cheung@bristol.ac.uk
% Date: 11 NOV 2019

% cfg
d.cfg.locked = 0;
d.cfg.aoa = 0.0;
d.cfg.sideslip = 0.0;
d.cfg.velocity = 0.0;
d.cfg.dynamicPressure = 0.0;
d.cfg.datum = 0;
d.cfg.sync = [];
d.cfg.preGustPauseDuration = 0.0;
d.cfg.postGustPauseDuration = 0.0;
d.cfg.padDuration = 0.0;
d.cfg.sampleDuration = 0.0;
d.cfg.measurementPauseDuration = 0.0;
d.cfg.dataDirectory = '';
d.cfg.testType = '';
d.cfg.runCount = 1;
d.cfg.genGust = 0;
d.cfg.RunType = '';
d.cfg.RunNumber = 0;
d.cfg.datetime = '';
d.cfg.ZeroRun = NaN;
d.cfg.Job = '';
d.cfg.Comment = '';
d.cfg.LCO = 0;
d.cfg.FlareAngle = 0;
d.cfg.RollAngle = 0;
d.cfg.AileronAngle = 0;
d.cfg.WingtipTwistAngle= 0;

% gust
d.gust.amplitudeDeg = 0.0;
d.gust.frequency = 0.0;
d.gust.sine = 0;
d.gust.oneMinusCosine = 0;
d.gust.random = 0;
d.gust.chirp = 0;
d.gust.frequencyEnd = 0.0;
d.gust.analogue = 0;
d.gust.duration = 0.0;
d.gust.timeOffset = 0.0;
d.gust.offsetDeg = 0.0;

% daq - calibration
[d.daq.encoder.calibration.slope,d.daq.encoder.calibration.constant] ...
    = encoderCalibration();
[d.daq.strain.calibrationBMT,d.daq.strain.calibration] ...
    = strainCalibration();

% % daq - data
d.daq.triggerTime  = 0;
d.daq.date = '';
d.daq.rate = 0.0;
d.daq.t = [];
d.daq.sync.v = [];
d.daq.encoder.v = [];
d.daq.strain.v = [];
d.daq.servo.v = [];
d.daq.gust.v = [];

% % cam
end