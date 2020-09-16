clear all;
%close all;
restoredefaultpath;
addpath('../CommonLibrary')

% set global parameters
localDir = '../../data/';  % the directory containing the 'data' folder


MeanRunData = GetV2Runs(localDir);

MeanRunData = GetMeanRollRates(MeanRunData,5,90);
MeanRunData = GetMeanRollRates(MeanRunData,5,45);
MeanRunData = GetMeanRollRates(MeanRunData,5,45,0);

save('MeanRollData.mat','MeanRunData');