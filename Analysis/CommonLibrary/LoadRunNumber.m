function [d] = LoadRunNumber(runNumber)
%LOADRUNNUMBER Summary of this function goes here
%   Detailed explanation goes here

% Update MetaData
load('../../MetaData.mat')

%runs = length(MetaData);
localDir = '../../data/';


ind = [MetaData.RunNumber] == runNumber;
%ind = [MetaData.Velocity]>-1;% & string({MetaData.RunType}) == 'Datum';

RunData = MetaData(ind);


for i = 1:length(RunData)
    % If here incorrect mass set
    data = load([localDir,RunData(i).Folder,'/',RunData(i).Filename]);
    d = data.d;
    %d.cfg.RunType = 'Steady';
    %parsave([localDir,RunData(i).Folder,'/',RunData(i).Filename],d)
end
end
