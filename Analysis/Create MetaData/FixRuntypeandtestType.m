%% During a job a set of test were complete at 8.8 degrees instead of 10 
%% degrees. This script edits the MetaData then saves it to a new file


% Update MetaData
load('MetaData.mat')

%runs = length(MetaData);
localDir = '../../data/';

ind = strcmp(string({MetaData.Job}),'FlutterBiSection');

RunData = MetaData(ind);


for i = 1:length(RunData)
    % If here incorrect mass set
    data = load([localDir,RunData(i).Folder,'/',RunData(i).Filename]);
    d = data.d;
    d.cfg.RunType = d.cfg.testType;
    d.cfg.testType = 'servo_fwt';
    name_split = strsplit(RunData(i).Filename,'aoa');
    new_filename = strcat(d.cfg.testType,'_',d.cfg.RunType,'_aoa',name_split{2});
    parsave([localDir,RunData(i).Folder,'/',new_filename],d)
end


function parsave(fname, d)
save(fname, 'd')
end