close all;clc;fclose all;clear all;restoredefaultpath;
addpath('./gust_vane_7x5'); % Add Gust Vane Code Library
%% Folding Wingtip WTT DAQ Script
% Created: R.C.M. Cheung
% Contact: r.c.m.cheung@bristol.ac.uk
% Date: 24 NOV 2019
%% Save data?
swSave = 1;
dataDir = '..\data\Impulse Response Tests\10DEC2019\mQtr_UnLocked_Impulse1'; % output directory
%% Subcase
subCase = 1; % datum = 1, steady-state = 2; final datum = 4;
%% Test Set
massCase = 2; % Empty => 1; 1/4 => 2; Half => 3; 3/4 => 4; Full => 5
testAoA = 5; % deg
dynamicPressure = 0.0;
hingeLocked = 0; % (0/1)
rho = 1.225;
testVelocity = sqrt(dynamicPressure*2/rho); % m/s
testDuration = 15.0; % sec
%% Init meta data container
d = initData();
%% Select Subcases
switch(subCase)
    case(1) % datum
        d.cfg = setMeta(d.cfg,'datum',1);
        d.cfg = setMeta(d.cfg,'runCount',1);
        d.cfg = setMeta(d.cfg,'velocity',0.0);
        d.gust = setMeta(d.gust,'frequency',0.0,'amplitudeDeg',0.0);
        loopArray = 1;
        d.cfg = setMeta(d.cfg,'postGustPauseDuration',testDuration+1.0);
    case(2) % steady-state
        d.cfg = setMeta(d.cfg,'datum',0);
        d.cfg = setMeta(d.cfg,'runCount',1);
        d.cfg = setMeta(d.cfg,'dynamicPressure',dynamicPressure);
        d.cfg = setMeta(d.cfg,'velocity',testVelocity);
        d.gust = setMeta(d.gust,'frequency',0.0,'amplitudeDeg',0.0);
        d.cfg = setMeta(d.cfg,'postGustPauseDuration',testDuration+1.0);
        loopArray = 1;
    case(4) % final datum
        d.cfg = setMeta(d.cfg,'datum',1);
        d.cfg = setMeta(d.cfg,'runCount',2);
        d.cfg = setMeta(d.cfg,'velocity',0.0);
        d.gust = setMeta(d.gust,'frequency',0.0,'amplitudeDeg',0.0);
        loopArray = 2;
        d.cfg = setMeta(d.cfg,'postGustPauseDuration',testDuration+1.0);
end
% WT configuration
d.cfg = setMeta(d.cfg,'aoa',testAoA);
% hinge configuration
d.cfg = setMeta(d.cfg,'locked',hingeLocked);
% mass case
[d,testType] = massDistro(d,massCase);
% additional test description
d.cfg = setMeta(d.cfg,'testType',testType);
% timing
d.cfg = setMeta(d.cfg,'measurementPauseDuration',1.0, ...
    'preGustPauseDuration',1.0);
% DAQ rate
d.daq = setMeta(d.daq,'rate',1700.0); % nearest to 1706.667 Hz(calculated from 1/5.859375e-04)
% Files
d.cfg = setMeta(d.cfg,'dataDirectory',dataDir);
%% Init Test
[s,d,lh,lh2] = initTest(d);
swNewTest = 1;
runLoop = 0;
count = 10;
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
    
    %% Run Test
    runTest(s,d);
    %% Load data from tmp DAQ file
    d = loadData(s,d);
    %% Plots
    genPlots(d);
    if(subCase~=2)
        %% Save data
        saveData(d,swSave);
        runLoop = 1;
    else
        %% Prompts
        reportEncoder(d);
        prompt = 'Save data? Choose (0 or 1)\n';
        runLoop = input(prompt);
        if(runLoop)
            disp('Up Run Number')
            d.cfg = setMeta(d.cfg,'runCount',count);
            count = count + 1;            
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