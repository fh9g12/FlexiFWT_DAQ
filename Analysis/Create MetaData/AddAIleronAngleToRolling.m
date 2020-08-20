
% Update MetaData
load('MetaData.mat')

%runs = length(MetaData);
localDir = '../../data/';

ind = [MetaData.FlareAngle] == 0;

ind = ind & contains(string({MetaData.Job}),'RollingRig');

RunData = MetaData(ind);


for i = 1:length(RunData)
    % If here incorrect mass set
    data = load([localDir,RunData(i).Folder,'/',RunData(i).Filename]);
    d = data.d;
    d.cfg.FlareAngle = 20;
    %d.cfg.AileronAngle = 20;
    parsave([localDir,RunData(i).Folder,'/',RunData(i).Filename],d)
end



function parsave(fname, d)
save(fname, 'd')
end