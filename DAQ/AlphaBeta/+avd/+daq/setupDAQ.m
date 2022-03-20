function aq = setupDAQ(props)
%SETUPDAQ a function to setup the DAQ objects for a AVDASI Hammer Test
%   Authors: Fintan Healy, Lucian Constantin
%   Email:  fintan.healy@bristol.ac.uk
%   Date:   15/09/2021
    p = inputParser;
    p.addRequired('p',@(x)isa(x,'avd.Properties'))
    p.parse(props);
    
    
    daqreset;
    aq = daq('ni'); % create session
    aq.Rate = props.Fs;
    
    avd.daq.event.Handler([],'Init',true)
    aq.ScansAvailableFcn = @(src,varargin) avd.daq.event.Handler(src);
    
    for i = 1:length(props.Channels)
        ch = aq.addinput(props.Channels(i).DeviceID,...
            props.Channels(i).Idx,...
            props.Channels(i).MeasurementType);
        ch.Name = props.Channels(i).Name;
        ch.Sensitivity = props.Channels(i).Sensitivity;
    end    
end

