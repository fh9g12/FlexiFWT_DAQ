function out = runTestBackground(obj,duration)
%RUNTEST Summary of this function goes here
%   Detailed explanation goes here
obj.BackgroundDataReady = false;
if ~exist('out','var')
    out = struct();
end
% obj.ScansAvailableFcn = @(obj,evt)store_data(obj,evt,out);
obj.flush;
obj.start("Duration",duration);
end

% function store_data(obj,evt,out)
%     [scanData,timestamps] = read(obj,obj.ScansAvailableFcnCount,"OutputFormat","Matrix");
%     obj.BackgroundData = obj.scanData2struct(scanData,timestamps,out);
%     obj.BackgroundDataReady = true;
% end
