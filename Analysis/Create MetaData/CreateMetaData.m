%%get a list of all .mat files within a directory

matFiles = struct([]);

localDir = dir('../../data/**/*.mat');

for i = 1:length(localDir)
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
            d.cfg.ZeroRun = NaN;          
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
        matFiles(i).ZeroRun = [];
        matFiles(i).SteadyStateRun = [];
        matFiles(i).FinalZeroRun = [];
        matFiles(i).Comment = '';
        matFiles(i).Job = '';
        matFiles(i).Datetime = d.cfg.datetime;
        matFiles(i).FileLocation = [localDir(i).folder,'/',localDir(i).name];
    end
end


function parsave(fname, d)
save(fname, 'd')
end




