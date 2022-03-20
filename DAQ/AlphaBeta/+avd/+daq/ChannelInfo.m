classdef ChannelInfo
    %CHANNELINFO Summary of this class goes here
    %   Detailed explanation goes here
    properties
        DeviceID
        Idx;
        MeasurementType;
        Name;
        Sensitivity;
    end
    
    methods
        function obj = ChannelInfo(DeviceID,Idx,MeasurementType,Name,Sensitivity)
            %CHANNELINFO Construct an instance of this class
            %   Detailed explanation goes here
            obj.DeviceID = DeviceID;
            obj.Idx = Idx;
            obj.MeasurementType = MeasurementType;
            obj.Name = Name;
            obj.Sensitivity = Sensitivity;
        end
    end
end

