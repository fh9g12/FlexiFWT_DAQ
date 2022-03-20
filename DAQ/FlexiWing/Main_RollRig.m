close all;clc;fclose all;clear all;restoredefaultpath;
addpath('.\gust_vane_7x5'); % Add Gust Vane Code Library
%% Folding Wingtip WTT DAQ Script
% Created: R.C.M. Cheung
% Contact: r.c.m.cheung@bristol.ac.uk
% Date: 22 JUN 2020


%% Required Input Data
base_data_dir = '..\data\'; % folder to store data in
subCase = 2; % datum = 1, step-Release = 2, steady-Release = 3, final datum = 4;
ModelCase = 2; % Fixed => 0; Free => 1; Removed => 2; Left Fixed => 3; Right Fixed => 4
testAoA = 0; % deg
flareAngle = 0;
camberAngle = 0;
hingeLocked = 0; % (0/1)
rho = 1.225;
testDuration = 20; % sec
zeroRunNum = 1398;  % Nan for first datum and the run number of first datum for the rest
jobName = 'RollingRigv2_45';



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
d.cfg = setMeta(d.cfg,'FlareAngle',flareAngle);
d.cfg = setMeta(d.cfg,'CamberAngle',camberAngle);
% hinge configuration
d.cfg = setMeta(d.cfg,'locked',hingeLocked);
d.cfg = setMeta(d.cfg,'ZeroRun',zeroRunNum);
d.cfg = setMeta(d.cfg,'Job',jobName);

% additional test description
switch(ModelCase)
    case(0)
        d.cfg = setMeta(d.cfg,'testType','RollingRig_Fixed');
    case(1)
        d.cfg = setMeta(d.cfg,'testType','RollingRig_Free');
    case(2)
        d.cfg = setMeta(d.cfg,'testType','RollingRig_Removed');
    case(3)
        d.cfg = setMeta(d.cfg,'testType','RollingRig_LeftFixed');
    case(4)
        d.cfg = setMeta(d.cfg,'testType','RollingRig_RightFixed');
end

% timing
d.cfg = setMeta(d.cfg,'measurementPauseDuration',0.5, ...
    'preGustPauseDuration',0);
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
d.cfg = setMeta(d.cfg,'LCO',0);

%% Init Test
[s,d,lh,lh2] = initTest(d);
swNewTest = 1;

runLoop = testscript_input('Start Testing? Choose (0 or 1)\n');
while(runLoop==1) 
    
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
            % set roll anlge of Datum
            rollAngle = testscript_input('Roll Angle (Deg)?\n');                    
            d.cfg = setMeta(d.cfg,'RollAngle',rollAngle);
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
            % Get Type of Test (step or steady)
            testType_num = 8;
            while testType_num>7
                testType_num = testscript_input('Test Type? (0-Release 1-Steady 2-Release_Inverted 3-Release_GoPro 4-Release_Inverted_GoPro 5-Inverted_GoPro 6-GoPro):\n');
            end                
            switch testType_num
                case(0)
                    d.cfg = setMeta(d.cfg,'RunType','Release');
                case(1)
                    d.cfg = setMeta(d.cfg,'RunType','Steady');
                case(2)
                    d.cfg = setMeta(d.cfg,'RunType','Release_Inverted');
                case(3)
                    d.cfg = setMeta(d.cfg,'RunType','Release_GoPro');
                case(4)
                    d.cfg = setMeta(d.cfg,'RunType','Release_Inverted_GoPro');
                case(5)
                    d.cfg = setMeta(d.cfg,'RunType','Inverted_GoPro');
                case(6)
                    d.cfg = setMeta(d.cfg,'RunType','GoPro');
                case(7)
                    d.cfg = setMeta(d.cfg,'RunType','HandRelease');
            end
              
            % Get Dynamic Pressure
            dynamicPressure = testscript_input('Wind Tunnel Dynamic Pressure (Pa)?\n');                    
            d.cfg = setMeta(d.cfg,'dynamicPressure',dynamicPressure);
            rho = 1.225;
            testVelocity = sqrt(dynamicPressure*2/rho); % m/s
            d.cfg = setMeta(d.cfg,'velocity',testVelocity); 
            
            % Enter Aileron Angle
            
            aa = testscript_input('Aileron Angle (Deg)?\n');                    
            d.cfg = setMeta(d.cfg,'AileronAngle',aa);
                        
            %% enter comments
            prompt = 'Enter a Comment:\n';
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