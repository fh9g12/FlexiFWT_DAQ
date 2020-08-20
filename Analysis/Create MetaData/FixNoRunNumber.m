% Update MetaData
load('MetaData.mat')

%runs = length(MetaData);
localDir = '../../data/';

ind = [MetaData.RunNumber]<-10;% & string({MetaData.RunType}) == 'Datum';

RunData = MetaData(ind);


for i = 1:length(RunData)
    % load file
    data = load([localDir,RunData(i).Folder,'/',RunData(i).Filename]);
    d = data.d;
    
    % remove file type
    fileAndType = strsplit(RunData(i).Filename,'.');
    filename = fileAndType{1};
    
    if contains(filename,'_Run')
        ss = strsplit(filename,'_Run');
        filename = ss{1};
    end
    
    d.cfg.RunNumber = RunData(i).RunNumber+1788;
    filename = [filename,'_Run',num2str(d.cfg.RunNumber),'.mat'];
    
    % If here incorrect mass set
    parsave([localDir,RunData(i).Folder,'/',filename],d)
end



function parsave(fname, d)
save(fname, 'd')
end