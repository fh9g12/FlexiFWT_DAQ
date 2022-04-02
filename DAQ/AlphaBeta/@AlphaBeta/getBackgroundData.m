function out = getBackgroundData(obj,out)
%GETBACKGROUNDDATA Summary of this function goes here
%   Detailed explanation goes here
while obj.Running
    pause(0.1);
end
[scanData,timestamps] = read(obj,obj.NumScansAvailable,"OutputFormat","Matrix");
out = obj.scanData2struct(scanData,timestamps,out);
end

