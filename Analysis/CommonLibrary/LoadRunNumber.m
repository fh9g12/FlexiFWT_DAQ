function [d] = LoadRunNumber(runNumber,localDir,dataFolder)
%LOADRUNNUMBER Summary of this function goes here
%   Detailed explanation goes here

%runs = length(MetaData);
if ~exist('localDir','var')
    localDir = '../../';
end
if ~exist('dataFolder','var')
    dataFolder = 'data/';
end
load(fullfile(localDir,'MetaData_old.mat'),'MetaData')

ind = [MetaData.RunNumber] == runNumber;
%ind = [MetaData.Velocity]>-1;% & string({MetaData.RunType}) == 'Datum';

RunData = MetaData(ind);


for i = 1:length(RunData)
    % If here incorrect mass set
    d = load(fullfile(localDir,dataFolder,RunData(i).Folder,RunData(i).Filename));
    %d.cfg.RunType = 'Steady';
    %parsave([localDir,RunData(i).Folder,'/',RunData(i).Filename],d)
end
end
