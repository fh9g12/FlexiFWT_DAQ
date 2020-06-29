%%get a list of all .mat files within a directory

matFiles = struct([]);

localDir = dir('../../data/**/*.mat');

parfor i = 1:length(localDir)
    %clearvars -except localDir matFiles RunNumber i
    d = load([localDir(i).folder,'/',localDir(i).name]);
    while isfield(d,'d')
        % no run Number field so create one
        d = d.d;         
    end
    if ~isempty(d)
        if isfield(d,'cfg')
        % if here this is a valid .mat file
        if ~isfield(d.cfg,'runNumber')
            % no run Number field so create one
            d.cfg.runNumber = i;          
        end
        if ~isfield(d.cfg,'RunType')
            % no run Number field so create one
            d.cfg.RunType = '';          
        end
        if ~isfield(d.cfg,'ZeroRun')
            % no run Number field so create one
            d.cfg.ZeroRun = -1;          
        end
        if ~isfield(d.cfg,'Job')
            % no run Number field so create one
            d.cfg.Job = '';          
        end
        if ~isfield(d.cfg,'Comment')
            % no run Number field so create one
            d.cfg.Comment = '';          
        end

        if ~isfield(d.cfg,'datetime')
            % no run Number field so create one
            folders = strsplit(localDir(i).folder,'/');
            index = find(contains(folders,'2020'));
            if ~isempty(index)
              d.cfg.datetime = [folders{index},' 00:00:00'];
            end  
        end         
        end

        % save the new file
        % parsave([localDir(i).folder,'\',localDir(i).name],d)

        % Populate the Meta Data structure
        matFiles(i).RunNumber = i;
        matFiles(i).RunType = d.cfg.RunType;
        matFiles(i).Locked = logical(d.cfg.locked);
        matFiles(i).AoA = d.cfg.aoa;
        matFiles(i).Velocity = d.cfg.velocity;
        matFiles(i).MassConfig = d.cfg.testType;
        matFiles(i).ZeroRun = d.cfg.ZeroRun;
        matFiles(i).SteadyStateRun = [];
        matFiles(i).FinalZeroRun = [];
        matFiles(i).Comment = d.cfg.Comment;
        matFiles(i).Job = d.cfg.Job;
        matFiles(i).Datetime = d.cfg.datetime;
        
        %% get folder and file name
        folders = strsplit(localDir(i).folder,'\');
        len = length(folders);
        j=1;
        while j<len
          if strcmp(folders(j),'data')
              break
          else
              j=j+1;
          end
        end

        %remove first two paths C:\LocalData
        folders(1:j)=[];

        % add to the MetaData 
        matFiles(i).Filename = localDir(i).name;
        matFiles(i).Folder = [strjoin(folders,'/'),'/'];  
    end
end

MetaData = matFiles;
save('MetaData.mat','MetaData')



function parsave(fname, d)
save(fname, 'd')
end




