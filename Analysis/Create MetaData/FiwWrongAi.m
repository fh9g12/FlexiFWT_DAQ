%% During a job a set of test were complete at 8.8 degrees instead of 10 
%% degrees. This script edits the MetaData then saves it to a new file


% Update MetaData
load('MetaData.mat')

%runs = length(MetaData);
localDir = '../../data/';

ind = contains(string({MetaData.Folder}),'17-Aug-2020');

RunData = MetaData(ind);


for i = 1:length(RunData)
    % If here incorrect mass set
    data = load([localDir,RunData(i).Folder,'/',RunData(i).Filename]);
    d = data.d;
    d.cfg.FlareAngle = 30;   
    parsave([localDir,RunData(i).Folder,'/',RunData(i).Filename],d)
end



function parsave(fname, d)
save(fname, 'd')
end