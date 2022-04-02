close all;clc;fclose all;clear all
%% Required Input Data
base_data_dir = '..\data\'; % folder to store data in


d = struct();
d.cfg.atm_pressure = nan; %(pascals  mbar*1e2)
d.cfg.rho = 1.225;
d.cfg.testDuration = 3; % sec
d.cfg.measurementPauseDuration = 0.25;

d.cfg.ModelName = 'AlphaBeta';
d.cfg.FlareAngle = 10;
d.cfg.WingtipTwistAngle = 0;
d.cfg.AileronAngle = -25;
d.cfg.Locked = false; % (0/1)

d.cfg.Job = 'AlphaBetaSweep';
d.cfg.TestType = 'GravEncoder';
% d.cfg.TestType = 'BiStable';
% d.cfg.TestType = 'HysteresisLoop';
% d.cfg.TestType = 'Vramp';
% d.cfg.TestType = 'AoAramp';
d.cfg.Rate = 100;
d.cfg.dataDirectory = fullfile(base_data_dir,date());

%% create daq object
daq_obj = AlphaBeta(d.cfg.Rate);

set_tunnel_conditions = true;
last_ate_num = 0;

res = testscript_input('Have you updated Model config? (0 or 1)');
if ~res
    return
end

while true       
    subCase  = testscript_input('Choose Subcase:\n - datum = 1\n - steady = 2\n - gust = 3\n - final datum = 4\n - Calibration = 5\n');
    switch(subCase)
        case 1
            d.cfg.RunType = 'Datum';
            d.cfg.ZeroRun = nan;
        case 2
            d.cfg.RunType = 'Steady';
        case 3
            d.cfg.RunType = 'Gust';
        case 4
            d.cfg.RunType = 'FinalDatum';
        case 5
            d.cfg.RunType = 'Calibration';
    end
    d.cfg.datum = subCase == 1 || subCase == 3;
    if subCase > 1
        d.cfg.ZeroRun = testscript_input('Zero Run?\n');
    end
    d.cfg.testDuration = testscript_input('Test Duration (s)?\n');
    runLoop = logical(testscript_input('Start Testing? Choose (0 or 1)\n'));
    if ~runLoop
        return
    end
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
        tmp = str2num(input('Save data? empty for yes, 0 for no\n','s'));
        if isempty(tmp)
            runLoop = true;
        else
            runLoop = tmp;
        end
        if runLoop && set_tunnel_conditions
            p = testscript_input('Pressure (mbar)?\n');
            res.cfg.atm_pressure = p * 1e2; %(pascals  mbar*1e2)
%             d.cfg.tempurtaure = testscript_input('Tempurature (Celcius)?\n');
            set_tunnel_conditions = false;
        end
        if(subCase==1 || subCase ==4)
            if runLoop
                % set roll anlge of Datum
%                 res.cfg.AoA = testscript_input('AoA (Deg)?\n');
%                 res.cfg.SideSlip = testscript_input('SideSlip (Deg)?\n');
%                 res.cfg.dynamicPressure = 0;
%                 res.cfg.velocity = 0;
                % enter comments
                tmp = str2num(input(sprintf('ATE Sample Number? (empty for %.0f)\n',last_ate_num+1),'s'));
                if isempty(tmp)
                    res.cfg.AteNum = last_ate_num+1;
                else
                    res.cfg.AteNum = tmp;
                end
                res.cfg.Comment = input('Enter a Comment\n','s');
                %% Save data
                daq_obj.saveData(res);
            end
            runLoop = false;
            % for other run types continue the test
        else
            %% Prompts
            if(runLoop)
%                 res.cfg.AoA = testscript_input('AoA (Deg)?\n');
%                 res.cfg.SideSlip = testscript_input('SideSlip (Deg)?\n');

                % Get Dynamic Pressure
%                 res.cfg.dynamicPressure = testscript_input('Wind Tunnel Dynamic Pressure (Pa)?\n');
%                 res.cfg.velocity = sqrt(res.cfg.dynamicPressure*2/d.cfg.rho); % m/s
                tmp = str2num(input(sprintf('ATE Sample Number? (empty for %.0f)\n',last_ate_num+1),'s'));
                if isempty(tmp)
                    res.cfg.AteNum = last_ate_num+1;
                else
                    res.cfg.AteNum = tmp;
                end
                last_ate_num = res.cfg.AteNum;

                %% enter comments
%                 tmp = str2num(input(sprintf('DownLoop? (empty for No)\n',last_ate_num+1),'s'));
%                 res.cfg.DownLoop = ~isempty(tmp);
                res.cfg.WingtipTwistAngle = testscript_input('Wingtip Twist?\n');
                res.cfg.Comment = input('Enter a Comment\n','s');
                res.cfg.Comment = '';

                %% Save data
                daq_obj.saveData(res);
            end
            tmp = str2num(input('Continue Testing? empty for yes, 0 for no, 2 to change tunnel conditions\n','s'));
            if isempty(tmp)
                runLoop = true;
            else
                runLoop = tmp;
                if runLoop == 2
                    set_tunnel_conditions = true;
                end
            end
        end
    end
    runLoop = testscript_input('Change subCase? Choose (0 or 1)\n');
    if ~runLoop
        break
    end
end
    %% Finish Test



