%% During a job a set of test were complete at 8.8 degrees instead of 10 
%% degrees. This script edits the MetaData then saves it to a new file


% Update MetaData
load('MetaData.mat')

%runs = length(MetaData);
localDir = '../../data/';

ind = [MetaData.RunNumber]>=90 & [MetaData.RunNumber]<=112;
RunData = MetaData(ind);


for i = 1:length(RunData)
    % If here incorrect mass set
    data = load([localDir,RunData(i).Folder,'/',RunData(i).Filename]);
    d = data.d;
    d.cfg.datetime = 'Release_GoPro';
    parsave([localDir,RunData(i).Folder,'/',RunData(i).Filename],d)
end



function parsave(fname, d)
save(fname, 'd')
end