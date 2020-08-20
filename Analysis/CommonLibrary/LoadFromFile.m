function [d] = LoadFromFile(file)
%LOADRUNNUMBER Summary of this function goes here
%   Detailed explanation goes here
data = load(file);
d = data.d;
end

