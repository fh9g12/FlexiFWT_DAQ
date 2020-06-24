function [x1] = decimate2(x,r)
%DECIMATE Summary of this function goes here
%   Detailed explanation goes here
ind = (0:floor(length(x)/r)-1)*r+1;
x1 = x(ind);
end

