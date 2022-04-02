function out = runTest(obj,duration,out)
%RUNTEST Summary of this function goes here
%   Detailed explanation goes here
[scanData,timestamps] = obj.read(duration,"OutputFormat","Matrix");
if ~exist('out','var')
    out = struct();
end
out = obj.scanData2struct(scanData,timestamps,out);
end

