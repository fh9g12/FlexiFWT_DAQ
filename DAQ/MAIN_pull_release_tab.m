close all;clc;fclose all;clear all;restoredefaultpath;
addpath('.\gust_vane_7x5'); % Add Gust Vane Code Library
%% Folding Wingtip WTT DAQ Script
% Created: R.C.M. Cheung
% Contact: r.c.m.cheung@bristol.ac.uk
% Date: 22 JUN 2020


%% Required Input Data
base_data_dir = '..\data\'; % folder to store data in
subCase = 4; % datum = 1, step-Release = 2, steady-Release = 3, final datum = 4;
massCase = 7; % Empty => 1; 1/4 => 2; Half => 3; 3/4 => 4; Full => 5, Qtr_inner =>6
testAoA = -2.5; % deg
hingeLocked = 0; % (0/1)
rho = 1.225;
testDuration = 10.0; % sec
zeroRunNum = 516;  % NaN for first datum and the run number of first datum for the rest
jobName = 'FlutterBiSection';

% check input
if ~isnan(zeroRunNum) && subCase == 1
    error('Datum run must be NaN for a the first zero run')
end

if isnan(zeroRunNum) && subCase ~= 1
    error('Datum run be set for none first datum runs')
end

%% Init meta data container
d = initData();
%% Select Subcases
d = SetRunTypeMetaData(d,subCase,testDuration);

% WT configuration
d.cfg = setMeta(d.cfg,'aoa',testAoA);
% hinge configuration
d.cfg = setMeta(d.cfg,'locked',hingeLocked);
d.cfg = setMeta(d.cfg,'ZeroRun',zeroRunNum);
d.cfg = setMeta(d.cfg,'Job',jobName);
% mass case
[d,testType] = massDistro(d,massCase);
% additional test description
d.cfg = setMeta(d.cfg,'testType',testType);
% timing
d.cfg = setMeta(d.cfg,'measurementPauseDuration',3.0, ...
    'preGustPauseDuration',1.0);
% DAQ rate
d.daq = setMeta(d.daq,'rate',1700.0); % nearest to 1706.667 Hz(calculated from 1/5.859375e-04)
% Files
d.cfg = setMeta(d.cfg,'dataDirectory',[base_data_dir,date(),'\',d.cfg.testType,'\AoA',fileNumStr(testAoA),'\']);

%Set Tab Meta Data 
d.tab = setMeta(d.tab,'sine',1);
d.tab = setMeta(d.tab,'frequency',0);
d.tab = setMeta(d.tab,'amplitudeDeg',0);
d.tab = setMeta(d.tab,'trimDeg',0);
d.tab = setMeta(d.tab,'duration',1);

%% Init Test
[s,d,lh,lh2] = initTest(d);
swNewTest = 1;

% Reset Load Cells - use seriallist() to find correct ports
if subCase == 1
    instrreset()
    ports = [7,8];
    for j = 1:length(ports)
        sPort = serial(sprintf('COM%d',ports(j)),'BAUD',57600);
        fopen(sPort);
        fprintf('Reseting COM%d:\n',ports(j))
        fprintf(sPort,'S');
        fprintf('Recived: %s\n',convertCharsToStrings(char(fread(sPort,7))))
        fclose(sPort);     
    end
end

runLoop = testscript_input('Start Testing? Choose (0 or 1)\n');
while(runLoop==1)
    
    %% Set the tab angle
    prompt = sprintf('Tab Angle? (Current value: %d)\n',d.tab.trimDeg);
    tabAngle = testscript_input(prompt);
    tabAngle = min(max(-25,tabAngle),25);
    d.tab = setMeta(d.tab,'trimDeg',tabAngle);    
    
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
    reportEncoder(d);
    runLoop = testscript_input('Save data? Choose (0 or 1)\n');    
    if(subCase==1 || subCase ==4)
        if runLoop
            % enter comments
            prompt = 'Enter a Comment\n';
            d.cfg = setMeta(d.cfg,'Comment',input(prompt,'s')); 

            %% Save data
            saveData(d,true);          
        end       
        runLoop = 0;
    % for other run types continue the test
    else
        %% Prompts
        if(runLoop)
            % Get Dynamic Pressure
            dynamicPressure = testscript_input('Wind Tunnel Dynamic Pressure (Pa)?\n');                    
            d.cfg = setMeta(d.cfg,'dynamicPressure',dynamicPressure);
            rho = 1.225;
            testVelocity = sqrt(dynamicPressure*2/rho); % m/s
            d.cfg = setMeta(d.cfg,'velocity',testVelocity); 
                        
            %% enter comments
            prompt = 'Enter a Comment\n';
            d.cfg = setMeta(d.cfg,'Comment',input(prompt,'s'));
            
            %% Save data
            saveData(d,true);
        end
        prompt = 'Continue Testing? Choose (0 or 1)\n';
        runLoop = testscript_input('Continue Testing? Choose (0 or 1)\n');
    end
end
%% Finish Test
endTest(s,d,lh,lh2);