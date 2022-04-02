close all;clc;fclose all;clear all
%% Required Input Data
base_data_dir = '..\data\'; % folder to store data in

ModelCase = 2; % Fixed => 0; Free => 1; Removed => 2
d = struct();
d.cfg.AoA = 0;
d.cfg.SideSlip = 0;
d.cfg.FlareAngle = 0;
d.cfg.WingtipTwistAngle = 0;
d.cfg.AileronAngle = 0;
d.cfg.Locked = false; % (0/1)
d.cfg.rho = 1.225;
d.cfg.testDuration = 3; % sec
d.cfg.measurementPauseDuration = 0.25;
d.cfg.ZeroRun = nan;  % Nan for first datum and the run number of first datum for the rest
d.cfg.Job = 'AlphaBeta';

d.cfg.Rate = 1000;
d.cfg.dataDirectory = fullfile(base_data_dir,date());
d.cfg.LCO = false;
d.cfg.rho = 1.225;

d.cfg.CalibrationMomentArm = 0;
d.cfg.RunType = 'AlphaBetaCalibration';
d.cfg.CalibrationMass = 0;
d.cfg.CalibrationAngle = 0;
d.cfg.dynamicPressure = 0;
d.cfg.velocity = 0;
subCase = 2; % LeftStrainGauge = 1, RightStrainGauge = 2, LeftEncoder = 3, RightEncoder = 4;

switch(subCase)
    case 1
        d.cfg.TestType = 'LeftStrainGauge';
    case 2
        d.cfg.TestType = 'RightStrainGauge';
    case 3
        d.cfg.TestType = 'LeftEncoder';
    case 4
        d.cfg.TestType = 'RightEncoder';
end

%% create daq object
daq_obj = AlphaBeta(d.cfg.Rate);
%% Select Subcases
d = SetRunTypeMetaData(d,subCase);

runLoop = logical(testscript_input('Start Testing? Choose (0 or 1)\n'));
while runLoop
    
    fprintf('\nPause for Next Measurement... \n');
    pause(d.cfg.measurementPauseDuration); % Pause between cases
    fprintf('Starting Next Measurement...\n\n');
    %% set the start time
    d.cfg.datetime = datetime();
    
    %% Run Test
    res = daq_obj.runTest(seconds(d.cfg.testDuration),d);
    %% Load data from tmp DAQ file
    %% Plots
    figure(2);clf;
    daq_obj.genPlot(res);
    drawnow;
    % for datum runs end after one measurement
    runLoop = testscript_input('Save data? Choose (0 or 1)\n');    
    if(subCase==1 || subCase ==4)
        if runLoop
            % set roll anlge of Datum
            res.cfg.AoA = testscript_input('AoA (Deg)?\n');
            res.cfg.SideSlip = testscript_input('SideSlip (Deg)?\n');
            % enter comments
            res.cfg.Comment = input('Enter a Comment\n','s');
            %% Save data
            daq_obj.saveData(res);          
        end       
        runLoop = false;
    % for other run types continue the test
    else
        %% Prompts
        if(runLoop)
            if subCase <=2
                res.cfg.CalibrationMass = testscript_input('Calibration Mass (kg)?\n');
                res.cfg.CalibrationMomentArm = testscript_input('Calibration Moment Arm (Nm)?\n');
            else
                res.cfg.CalibrationAngle = testscript_input('Calibration Angle (Deg)?\n');
            end
                        
            %% enter comments
            res.cfg.Comment = input('Enter a Comment\n','s');
            
            %% Save data
            daq_obj.saveData(res);
        end   
        runLoop = testscript_input('Continue Testing? Choose (0 or 1)\n');
    end
    
end
%% Finish Test
