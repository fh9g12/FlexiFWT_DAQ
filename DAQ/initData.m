function [d] = initData()
%% Folding Wingtip WTT DAQ - Init Data
% Created: R.C.M. Cheung
% Contact: r.c.m.cheung@bristol.ac.uk
% Date: 11 NOV 2019

% cfg
d.cfg.locked = 0;
d.cfg.aoa = 0.0;
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

% inertia position
d.inertia.position_0.mass = 0;
d.inertia.position_0.xOffset = 0;
d.inertia.position_0.remarks = '';

d.inertia.position_1.mass = 0;
d.inertia.position_1.xOffset = 0;
d.inertia.position_1.remarks = '';

d.inertia.position_2.mass = 0;
d.inertia.position_2.xOffset = 0;
d.inertia.position_2.remarks = '';

d.inertia.position_3.mass = 0;
d.inertia.position_3.xOffset = 0;
d.inertia.position_3.remarks = '';

d.inertia.position_4.mass = 0;
d.inertia.position_4.xOffset = 0;
d.inertia.position_4.remarks = '';

d.inertia.position_5.mass = 0;
d.inertia.position_5.xOffset = 0;
d.inertia.position_5.remarks = '';

d.inertia.position_6.mass = 0;
d.inertia.position_6.xOffset = 0;
d.inertia.position_6.remarks = '';

d.inertia.position_7.mass = 0;
d.inertia.position_7.xOffset = 0;
d.inertia.position_7.remarks = '';

d.inertia.position_8.mass = 0;
d.inertia.position_8.xOffset = 0;
d.inertia.position_8.remarks = '';

d.inertia.position_9.mass = 0;
d.inertia.position_9.xOffset = 0;
d.inertia.position_9.remarks = '';

d.inertia.position_10.mass = 0;
d.inertia.position_10.xOffset = 0;
d.inertia.position_10.remarks = '';

% tab
d.tab.amplitudeDeg = 0.0;
d.tab.frequency = 0.0;
d.tab.sine = 0;
d.tab.chirp = 0;
d.tab.frequencyEnd = 0;
d.tab.analogue = 0;
d.tab.duration = 0.0;
d.tab.delay = 0.0;
d.tab.timeOffset = 0.0;
d.tab.trimDeg = 0.0;
d.tab.command = [];

% daq - calibration
d.daq.accelerometer.calibration = accCalibration();
d.daq.loadcell.calibration = loadCalibration();
[d.daq.encoder.calibration.slope,d.daq.encoder.calibration.constant] ...
    = encoderCalibration();
[d.daq.strain.calibrationBMT,d.daq.strain.calibration] ...
    = strainCalibration();
d.daq.servo.calibrationTabDeg = servoCalibration();

% % daq - data
d.daq.triggerTime  = 0;
d.daq.date = '';
d.daq.rate = 0.0;
d.daq.t = [];
d.daq.sync.v = [];
d.daq.accelerometer.v = [];
d.daq.loadcell.v = [];
d.daq.encoder.v = [];
d.daq.strain.v = [];
d.daq.servo.v = [];
d.daq.gust.v = [];

% % cam
% d.cam = camDATA;

end