function RunData = GetV2Runs(localDir)
%GETV2RUNS Summary of this function goes here
%   Detailed explanation goes here

% Open the Meta-Data file
load(fullfile(localDir,'MetaData_old.mat'),'MetaData');     % the Metadata filepath

indicies = contains(string({MetaData.Job}),'RollingRigv2');
indicies = indicies & contains(string({MetaData.RunType}),'Release');

%% remove fixed config from 18th of August
bad_ind = contains(string({MetaData.Folder}),'18-Aug') & ...
    contains(string({MetaData.MassConfig}),'Fixed');
indicies = indicies & ~bad_ind;
RunData = MetaData(indicies);
end

