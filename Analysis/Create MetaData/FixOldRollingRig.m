
% Update MetaData
load('MetaData.mat')

%runs = length(MetaData);
localDir = '../../data/';

ind = [MetaData.RunNumber]>74 & [MetaData.RunNumber]<98;% & string({MetaData.RunType}) == 'Datum';

RunData = MetaData(ind);


for i = 1:length(RunData)
    % If here incorrect mass set
    data = load([localDir,RunData(i).Folder,'/',RunData(i).Filename]);
    d = data.d;
    
    d.cfg.Job = "RollingRigv1_0";
    d.cfg.aoa = 0;
        
    if RunData(i).RunNumber ~= 76
        d.cfg.ZeroRun = 76;
        d.cfg.RunType = "Steady";
    else
        d.cfg.ZeroRun = NaN;
        d.cfg.RunType = "Datum";
    end
    
    folders = string(strsplit(d.cfg.dataDirectory,'\'));
    switch folders(end)
        case "Removed"
            d.cfg.testType = 'RollingRig_Removed';        
        case "Free"
            d.cfg.testType = 'RollingRig_Free';
        case "Locked"
            d.cfg.testType = 'RollingRig_Fixed';   
        otherwise
            d.cfg.testType = 'RollingRig_Fixed';  
    end
    parsave([localDir,RunData(i).Folder,RunData(i).Filename],d)
end



function parsave(fname, d)
save(fname, 'd')
end