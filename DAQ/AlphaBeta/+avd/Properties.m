classdef Properties
%PROPERTIES a set of properties for the AVDASI Hammer Dynamic tests
%   Authors: Fintan Healy, Lucian Constantin
%   Email:  fintan.healy@bristol.ac.uk
%   Date:   15/09/2021   
    properties
        Channels = avd.daq.ChannelInfo.empty; % cell array with 4 items (DeviceID, ChannelIndex, Measurement Type, ChannelSensitivity) 
        Fs; % Sampling frequency
        Repeats; % Number of taps per experiment
        coords;     % an Nx2 array of position coordinates,
        root_coords;% an Nx2 array of root position coordinates (for plotting),
        pos_num;    % an array of position idicies (ith element corresponds to ith row in coords)
        PreTrigger; % number of seconds to record prior to an impact
        PostTrigger;% number of seconds to record post an impact
        DAQ_buffer  % number of seconds to store in the Buffer (and display on screen)
        Hammer_MinThreshold; % min threshold for hammer trigger
        Hammer_MaxThreshold; % max threshold for hammer trigger
        Info; % string of info to save in file
    end
    
    methods(Static)
        function obj = OneAccelImpactTesting(DeviceID)
            if ~exist('DeviceID','var')
                DeviceID = 'cDAQ1Mod1';
            end
            obj = avd.Properties();
            % Set channel sensitivities
            
            % Impact hammer: 11.2mV/N
            obj.Channels(1) = avd.daq.ChannelInfo(DeviceID,0,'Accelerometer','Hammer',11.2e-3);
%             % Acc 352A24: 97.9 mV/g
%             obj.Channels(2) = avd.daq.ChannelInfo(DeviceID,1,'Accelerometer','Accel',97.9e-3);
            
            % Acc C1304418: 9.52 mV/g
            obj.Channels(2) = avd.daq.ChannelInfo(DeviceID,1,'Accelerometer','Accel',9.52e-3);
            
            % Set number of taps for each point
            obj.Repeats = 3; 

            % Set sampling frequency
            obj.Fs = 2048; % [Hz]
            
            % set trigger Info
            obj.PreTrigger = 1; % [s]
            obj.PostTrigger = 5; % [s]
            obj.Hammer_MinThreshold = 1.5; % [g] min threshold for hammer trigger
            obj.Hammer_MaxThreshold = 20; % [g] max threshold for hammer trigger
            
            % Plot options
            obj.DAQ_buffer = 10; % [s]
        end
    end
end

