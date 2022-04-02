close all;clc;fclose all;clear all
%% Required Input Data
base_data_dir = '..\data\'; % folder to store data in


d = struct();
d.cfg.rho = 1.225;
d.cfg.testDuration = 3; % sec
d.cfg.measurementPauseDuration = 0.1;


d.cfg.ModelName = 'AlphaBeta';
d.cfg.FlareAngle = nan;
d.cfg.WingtipTwistAngle = 0;
d.cfg.AileronAngle = 0;
d.cfg.Locked = true; % (0/1)
d.cfg.isRightWing = true;
d.cfg.isLeftWing = true;

% d.cfg.Job = 'AlphaBetaSweep';
% d.cfg.TestType = 'SteadySweep';
% d.cfg.TestType = 'WingtipFreqVramp';
% d.cfg.TestType = 'WingtipFreqSte0adySweep';
d.cfg.TestType = 'GVT';
% d.cfg.TestType = 'BiStable';
% d.cfg.TestType = 'HysteresisLoop';
% d.cfg.TestType = 'Vramp';
% d.cfg.TestType = 'AoAramp';
d.cfg.Rate = 200;
d.cfg.dataDirectory = fullfile(base_data_dir,date());

%% create daq object
daq_obj = AlphaBeta(d.cfg.Rate);

d.cfg.atm_pressure = testscript_input('Pressure (mbar)?\n') * 1e2;
last_ate_num = 0;
last_zero_num = 0;

if ~logical(testscript_input_empty('Have you updated Model config?',true))
    return
end

while true
    subCase  = testscript_input('Choose Subcase:\n - datum = 1\n - steady = 2\n - Dynamic = 3\n - final datum = 4\n - Calibration = 5\n');
    switch(subCase)
        case 1
            d.cfg.RunType = 'Datum';
            d.cfg.ZeroRun = nan;
        case 2
            d.cfg.RunType = 'Steady';
        case 3
            d.cfg.RunType = 'Dynamic';
        case 4
            d.cfg.RunType = 'FinalDatum';
        case 5
            d.cfg.RunType = 'Calibration';
    end
    d.cfg.datum = subCase == 1 || subCase == 4;
    if subCase ~= 1
        d.cfg.ZeroRun = testscript_input_empty('Zero Run Number?',last_zero_num);
        last_zero_num = d.cfg.ZeroRun;
    end
    d.cfg.testDuration = testscript_input('Test Duration (s)?\n');

    if ~logical(testscript_input_empty('Start Testing?',true))
        return
    end
    while true
        fprintf('Starting Next Measurement...\n');
        %% set the start time
        d.cfg.datetime = datetime();
        %% Run Test
        res = daq_obj.runTest(seconds(d.cfg.testDuration),d);
        %% Plots
        figure(2);clf;
        daq_obj.genPlot(res);
        drawnow;
        % for datum runs end after one measurement
        if logical(testscript_input_empty('Save Data?',true))
            res.cfg.AteNum = testscript_input_empty('ATE Sample Number?',last_ate_num+1);
            last_ate_num = res.cfg.AteNum;
            res.cfg.Comment = input('Enter a Comment\n','s');
            daq_obj.saveData(res);
            if d.cfg.datum
                break;
            end
        end
        if ~logical(testscript_input_empty('Continue Testing?',true))
            break
        end
    end
    if ~logical(testscript_input_empty('Change Subcase?',true))
        break
    end
end
%% Finish Test



