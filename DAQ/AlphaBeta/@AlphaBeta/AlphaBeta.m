classdef AlphaBeta < daq.interfaces.DataAcquisition
    %ALPHABETA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        BackgroundData = struct();
        BackgroundDataReady = false;
    end
    
    methods
        function obj = AlphaBeta(sampleRate)
            %ALPHABETA Construct an instance of this class
            %   Detailed explanation goes here
            daqreset;
            obj = obj@daq.interfaces.DataAcquisition('ni');
            obj.addChannels();
            obj.Rate = sampleRate;
            disp(obj.Channels);
        end
%         function delete(obj)
%             if obj.Running
%                 obj.stop();
%             end
%             obj.flush();
%         end
    end
end

