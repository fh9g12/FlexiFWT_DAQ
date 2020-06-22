function [runNumber] = GetNextRunNumber()
%GETNEXTRUNNUMBER Summary of this function goes here
%   Detailed explanation goes here
load('__runNumber__.mat','runNumber')
runNumber = runNumber+1;
save('__runNumber__.mat','runNumber')
end

