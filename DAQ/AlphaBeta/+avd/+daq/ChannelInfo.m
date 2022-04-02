classdef ChannelInfo
    %CHANNELINFO Summary of this class goes here
    %   Detailed explanation goes here
    properties
        DeviceID
        ChannelID;
        MeasurementType;
        Name;
        Props;
    end
    
    methods
        function obj = ChannelInfo(DeviceID,Idx,MeasurementType,Name,Props)
            %CHANNELINFO Construct an instance of this class
            %   Detailed explanation goes here
            obj.DeviceID = DeviceID;
            obj.ChannelID = Idx;
            obj.MeasurementType = MeasurementType;
            obj.Name = Name;
            if exist('Props','var')
                obj.Props = Props;
            end
        end
    end
end

