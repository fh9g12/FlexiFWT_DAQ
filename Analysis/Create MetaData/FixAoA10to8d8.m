%% During a job a set of test were complete at 8.8 degrees instead of 10 
%% degrees. This script edits the MetaData then saves it to a new file


% Update MetaData
load('MetaData.mat')

%runs = length(MetaData);
localDir = '../../data/';

ind = strcmp(string({MetaData.Folder}),'30-Jun-2020/servo_fwt/AoA10d0/');

RunData = MetaData(ind);


for i = 1:length(RunData)
    % If here incorrect mass set
    data = load([localDir,RunData(i).Folder,'/',RunData(i).Filename]);
    d = data.d;
    d.cfg.aoa = 8.8;   
    new_filename = strrep(RunData(i).Filename,'aoa10d0','aoa8d8');
    new_folder = strrep(RunData(i).Folder,'AoA10d0','AoA8d8');
    parsave([localDir,new_folder,'/',new_filename],d)
end



function parsave(fname, d)
save(fname, 'd')
end