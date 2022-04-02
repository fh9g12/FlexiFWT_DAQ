close all;clc;fclose all;clear all
%% Required Input Data
base_data_dir = '..\data\'; % folder to store data in

d = struct();
d.cfg.rho = 1.225;
d.cfg.testDuration = 3; % sec
d.cfg.measurementPauseDuration = 0.25;
d.cfg.gustPauseDuration = 0.25;
d.cfg.MinGustTestDuration = 2.25;
d.cfg.MaxGustTestDuration = 2.5;


% d.cfg.measurementPauseDuration = 5;
% d.cfg.gustPauseDuration = 0.25;
% d.cfg.MinGustTestDuration = 3;
% d.cfg.MaxGustTestDuration = 3;

d.cfg.ModelName = 'AlphaBeta';
d.cfg.FlareAngle = nan;
d.cfg.WingtipTwistAngle = 0;
d.cfg.AileronAngle = 0;
d.cfg.isRightWing = true;
d.cfg.isLeftWing = true;
d.cfg.Locked = true; % (0/1)
d.cfg.Removed = false; % (0/1)

d.cfg.Job = 'GustResponse';
d.cfg.TestType = 'GoProVideos';
% d.cfg.TestType = 'GustFamily';
% d.cfg.TestType = 'SteadySweep';
% d.cfg.TestType = 'EncoderVoltage';
% d.cfg.TestType = 'FlipWingtipWithGust';

d.cfg.Rate = 200;
d.cfg.dataDirectory = fullfile(base_data_dir,date());

% freqs = [0.5,1:15];
% amplitudes_1MC = [9,18];
% amplitudes_Random = [2.5,5];
% random_duration = 20;
% repeats = 2;
% Inverted = false;
% gust_pause_length = 2;

% %% WingSideStudy
% freqs = [5,10,15];
% amplitudes_1MC = [10,20];
% amplitudes_Random = [2.5,5];
% random_duration = 20;
% repeats = 3;
% Inverted = false;

%% MainTestBody
% freqs = linspace(2,15,8);
% amplitudes_1MC = [linspace(10,5,8);linspace(15,10,8);linspace(20,15,8)];
% amplitudes_Random = [2,4];
% random_duration = 20;
% oneMC_repeats = 3;
% Random_repeats = 1;

%% GoProVids
freqs = [5,10,15];
amplitudes_1MC = [20,15,15;10,7.5,7.5];
amplitudes_Random = [4];
random_duration = 20;
oneMC_repeats = 1;
Random_repeats = 1;
d.cfg.measurementPauseDuration = 0.1;
d.cfg.gustPauseDuration = 0.25;
d.cfg.MinGustTestDuration = 8;
d.cfg.MaxGustTestDuration = 8;

% freqs = [5,10,15];
% amplitudes_1MC = [20];
% amplitudes_Random = [2.5,5];
% random_duration = 10;
% repeats = 1;
% Inverted = false;


% d.cfg.gustPauseDuration
% freqs = [1,3,5];
% amplitudes_1MC = [10,20];
% amplitudes_Random = [2.5,5];
% random_duration = 5;
% repeats = 1;
% Inverted = false;
% gust_pause_length = 2;


%% create daq object
daq_obj = AlphaBeta(d.cfg.Rate);
vanes = [GustVane('192.168.1.101',502),GustVane('192.168.1.102',502)];

d.cfg.atm_pressure = testscript_input('Pressure (mbar)?\n') * 1e2;
last_ate_num = nan;
last_zero_num = 0;
last_tare_num = 0;
if ~logical(testscript_input_empty('Have you updated Model config?',true))
    return
end

while true
    subCase  = testscript_input(['Choose Subcase:\n - Datum = 1\n',...
        ' - 1MC = 2\n - 1MC Inverted = 3\n - Random = 4\n - Combined = 5\n - Final Datum = 6\n',...
        ' - Steady = 7\n - Quit = 8\n - Single Gust = 9\n']);
    switch(subCase)
        case 1
            d.cfg.RunType = 'Datum';
            d.cfg.ZeroRun = nan;
            d.cfg.datum = true;
        case 2
            d.cfg.RunType = '1MC';
        case 3
            d.cfg.RunType = '1MC_Inverted';
        case 4
            d.cfg.RunType = 'Random';
        case 5
            d.cfg.RunType = 'Combined';
        case 6
            d.cfg.RunType = 'FinalDatum';
            d.cfg.datum = true;
        case 7
            d.cfg.RunType = 'Steady';
        case 8
            break;
        case 9
            d.cfg.RunType = '1MC_single';
    end
    if subCase ~= 1
        d.cfg.ZeroRun = testscript_input_empty('Zero Run Number?',last_zero_num);
        last_zero_num = d.cfg.ZeroRun;
    end
    if ~logical(testscript_input_empty('Start Testing?',true))
        return
    end
    switch(d.cfg.RunType)
        case {'Datum','FinalDatum','Steady'}
            if strcmp(d.cfg.RunType,'Steady')
                d.cfg.testDuration = testscript_input('Test Duration?\n');
            else
                d.cfg.testDuration = 3;
            end
            while true
                res = get_steady_measurement(d,daq_obj);
                if logical(testscript_input_empty('Save Data?',true))
                    res.cfg.AteNum = testscript_input_empty('ATE Sample Number?',last_ate_num+1);
                    last_ate_num = res.cfg.AteNum;
                    res.cfg.Comment = input('Enter a Comment\n','s');
                    runNumber = daq_obj.saveData(res);
                    if strcmp(d.cfg.RunType,'Datum')
                        last_zero_num = runNumber;
                    end
                    if strcmp(d.cfg.RunType,'Steady')
                        if ~logical(testscript_input_empty('Take Another Measurement?',true))
                            break
                        end
                    else
                        break
                    end
                else
                    if ~logical(testscript_input_empty('Repeat?',true))
                        break
                    end
                end
            end
        case {'1MC','Random','Combined','1MC_Inverted'}
            runType = d.cfg.RunType;
            %% Initial Tare
            fprintf('Taking Tare measurement...\n');
            while true
                d.cfg.RunType = 'Tare';
                d.cfg.testDuration = 3;
                [~,repeat,last_ate_num,last_tare_num] = take_tare(d,daq_obj,last_ate_num,last_tare_num);
                stop_test = false;
                if ~repeat
                    break
                else
                    stop_test = ~logical(testscript_input_empty('Repeat?',true));
                    if stop_test
                        break
                    end
                end
            end
            if stop_test
                break
            end
            d.cfg.RunType = runType;
            d.cfg.TareRun = last_tare_num;
            %% Gust measurements
            fprintf('Taking Gust Measurments...\n');
            results = {};
            idx = 1;
            switch d.cfg.RunType
                case {'1MC','1MC_Inverted'}
                    inverted = strcmp(d.cfg.RunType,'1MC_Inverted');
                    for i = 1:length(freqs)
                        for j = 1:size(amplitudes_1MC,1)
                            for k = 1:oneMC_repeats
                                fprintf('Pausing For Next Measurement...\n');
                                pause(d.cfg.measurementPauseDuration)
                                results{idx} = runOneMinusCosine(d,daq_obj,vanes,freqs(i),amplitudes_1MC(j,i),inverted);
                                results{idx}.cfg.RunType = '1MC';
                                daq_obj.genPlot(results{idx});
                                idx = idx + 1;
                            end
                        end
                    end
                case 'Random'
                    for i = 1:length(amplitudes_Random)
                        for j = 1:Random_repeats
                            fprintf('Pausing For Next Measurement...\n');
                            pause(d.cfg.measurementPauseDuration)
                            results{idx} = runRandomGust(d,daq_obj,vanes,random_duration,amplitudes_Random(i));
                            results{idx}.cfg.RunType = 'Random';
                            daq_obj.genPlot(results{idx});
                            idx = idx + 1;
                        end
                    end
                case 'Combined'
                    %% 1MC gusts
                    for i = 1:length(freqs)
                        for j = 1:size(amplitudes_1MC,1)
                            for k = 1:oneMC_repeats
                                fprintf('Pausing For Next Measurement...\n');
                                pause(d.cfg.measurementPauseDuration)
                                results{idx} = runOneMinusCosine(d,daq_obj,vanes,freqs(i),amplitudes_1MC(j,i),false);
                                results{idx}.cfg.RunType = '1MC';
                                daq_obj.genPlot(results{idx});
                                idx = idx + 1;
                            end
                        end
                    end

                    %% random gusts
                    for i = 1:length(amplitudes_Random)
                        for j = 1:Random_repeats
                            fprintf('Pausing For Next Measurement...\n');
                            pause(d.cfg.measurementPauseDuration)
                            results{idx} = runRandomGust(d,daq_obj,vanes,random_duration,amplitudes_Random(i));
                            results{idx}.cfg.RunType = 'Random';
                            daq_obj.genPlot(results{idx});
                            idx = idx + 1;
                        end
                    end
            end
            %% Save data
            if logical(testscript_input_empty('Save Data?',true))
                Comment = input('Enter a Comment\n','s');
                for i = 1:length(results)
                    res = results{i};
                    res.cfg.AteNum = last_ate_num;
                    res.Comment = Comment;
                    daq_obj.saveData(res);
                end
            end
            %% Final tare
            fprintf('Taking Final Tare Measurement...\n');
            while true
                d.cfg.RunType = 'FinalTare';
                d.cfg.testDuration = 3;
                [~,repeat,last_ate_num,~] = take_tare(d,daq_obj,last_ate_num,last_tare_num);
                if ~repeat
                    break
                else
                    stop_test = ~logical(testscript_input_empty('Repeat?',true));
                    if stop_test
                        break
                    end
                end
            end
            d.cfg.RunType = runType;
        case '1MC_single'
            while true
                freq = testscript_input('Frequncy (Hz)?\n');
                A = testscript_input('Amplitude (deg)?\n');
                fprintf('Pausing For Next Measurement...\n');
                pause(d.cfg.measurementPauseDuration)
                res = runOneMinusCosine(d,daq_obj,vanes,freq,A,0);
                daq_obj.genPlot(res);
                if logical(testscript_input_empty('Save Data?',true))
                    Comment = input('Enter a Comment\n','s');
                    res.cfg.AteNum = testscript_input_empty('ATE Sample Number?',last_ate_num+1);
                    last_ate_num = res.cfg.AteNum;
                    res.Comment = Comment;
                    daq_obj.saveData(res);

                end
                if ~logical(testscript_input_empty('Repeat?',true))
                    break;
                end

            end
    end
end
%% test
% [~,repeat,last_ate_num,~] = take_tare(d,daq_obj,last_ate_num,last_tare_num);

%% functions
function [res,repeat,last_ate_num,last_tare_num] = take_tare(d,daq_obj,last_ate_num,last_tare_num)
res = get_steady_measurement(d,daq_obj,'');
repeat = false;
if logical(testscript_input_empty('Save Data?',true))
    res.cfg.AteNum = testscript_input_empty('ATE Sample Number?',last_ate_num+1);
    last_ate_num = res.cfg.AteNum;
    res.cfg.Comment = input('Enter a Comment\n','s');
    last_tare_num = daq_obj.saveData(res);
else
    if ~logical(testscript_input_empty('Repeat?',true))
        repeat = true;
    end
end
end

function res = get_steady_measurement(d,daq_obj,prompt)
if ~exist('prompt','var')
    prompt = 'Starting Next Measurement...\n';
end
fprintf(prompt);
d.cfg.datetime = datetime();
res = daq_obj.runTest(seconds(d.cfg.testDuration),d);
daq_obj.genPlot(res);
end

