function RunData = GetEncoderData(RunData)
%GETMEANROLLRATES Summary of this function goes here
%   Detailed explanation goes here

addpath('../CommonLibrary')

parfor i =1:length(RunData)
    RunData(i).EncDeg = LoadEncoderData(RunData(i).RunNumber);
end

