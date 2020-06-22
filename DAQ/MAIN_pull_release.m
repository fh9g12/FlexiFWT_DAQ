close all;clc;fclose all;clear all;restoredefaultpath;
addpath('./gust_vane_7x5'); % Add Gust Vane Code Library
%% Folding Wingtip WTT DAQ Script
% Created: R.C.M. Cheung
% Contact: r.c.m.cheung@bristol.ac.uk
% Date: 22 JUN 2020


%% Required Input Data
base_data_dir = '..\data\'; % folder to store data in
subCase = 4; % datum = 1, step-Release = 2, steady-Release = 3, final datum = 4;
massCase = 2; % Empty => 1; 1/4 => 2; Half => 3; 3/4 => 4; Full => 5, Qtr_inner =>6
testAoA = 10; % deg
hingeLocked = 0; % (0/1)
rho = 1.225;
testDuration = 10.0; % sec
zeroRunNum = NaN;
%% Init meta data container
d = initData();
%% Select Subcases
d = SetRunTypeMetaData(d,subCase,testDuration);

% WT configuration
d.cfg = setMeta(d.cfg,'aoa',testAoA);
% hinge configuration
d.cfg = setMeta(d.cfg,'locked',hingeLocked);
d.cfg = setMeta(d.cfg,'ZeroRun',zeroRunNum);
% mass case
[d,testType] = massDistro(d,massCase);
% additional test description
d.cfg = setMeta(d.cfg,'testType',testType);
% timing
d.cfg = setMeta(d.cfg,'measurementPauseDuration',5.0, ...
    'preGustPauseDuration',1.0);
% DAQ rate
d.daq = setMeta(d.daq,'rate',1700.0); % nearest to 1706.667 Hz(calculated from 1/5.859375e-04)
% Files
d.cfg = setMeta(d.cfg,'dataDirectory',[base_data_dir,d.cfg.testType,'\AoA',fileNumStr(testAoA),'\']);
%% Init Test
[s,d,lh,lh2] = initTest(d);
swNewTest = 1;

prompt = 'Start Testing? Choose (0 or 1)\n';
yN = input(prompt);
runLoop = not(yN);
while(runLoop<1)
    %% Queue output data
    if(swNewTest)
        setOutput(s,d,1); % first pass
        swNewTest = 0;
    else
        setOutput(s,d,0);
        fprintf('\nPause for Next Measurement... \n\n');
        pause(d.cfg.measurementPauseDuration); % Pause between cases
    end
    %% set the start time
    d.cfg.datetime = datetime();
    
    %% Run Test
    runTest(s,d);
    %% Load data from tmp DAQ file
    d = loadData(s,d);
    %% Plots
    genPlots(d);
    % for datum runs end after one measurement
    if(subCase==1 || subCase ==4)
        %% Save data
        saveData(d,swSave);
        runLoop = 1;
    % for other run types continue the test
    else
        %% Prompts
        reportEncoder(d);
        prompt = 'Save data? Choose (0 or 1)\n';
        runLoop = input(prompt);
        if(runLoop) 
            prompt = 'Wind Tunnel Dynamic Pressure (Pa)?\n';
            dynamicPressure = input(prompt);
            d.cfg = setMeta(d.cfg,'dynamicPressure',dynamicPressure);
            rho = 1.225;
            testVelocity = sqrt(dynamicPressure*2/rho); % m/s
            d.cfg = setMeta(d.cfg,'velocity',testVelocity);
            %% Save data
            saveData(d,swSave);
        end
        prompt = 'Continue Testing? Choose (0 or 1)\n';
        yN = input(prompt);
        runLoop = not(yN);
    end
end
%% Finish Test
endTest(s,d,lh,lh2);