classdef AlphaBeta
    %ALPHABETA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        d = daq.interfaces.DataAcquisition.empty; 
        SampleRate = 1000;
    end
    
    methods
        function obj = AlphaBeta(sampleRate)
            %ALPHABETA Construct an instance of this class
            %   Detailed explanation goes here
            obj.SampleRate = sampleRate;
            obj.d = obj.initDAQ();
            disp(obj.d);
        end
    end
end

