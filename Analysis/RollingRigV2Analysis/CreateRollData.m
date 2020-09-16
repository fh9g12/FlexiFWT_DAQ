clear all;
%close all;
restoredefaultpath;
addpath('../CommonLibrary')

% set global parameters
localDir = '../../data/';  % the directory containing the 'data' folder


RunData = GetV2Runs(localDir);

RollData = GetEncoderData(RunData);
save('RollData.mat','RollData')