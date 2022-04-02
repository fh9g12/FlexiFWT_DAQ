function [out] = scanData2struct(obj,scanData,timestamps,out)
%SACNDATA2STRUCT Summary of this function goes here
%   Detailed explanation goes here
if ~exist('out','var')
    out = struct();
end
out.t = timestamps;
for i = 1:size(scanData,2)
    out.daq.(obj.Channels(i).Name).raw = scanData(:,i);
end
out = obj.postProcessData(out);
end

