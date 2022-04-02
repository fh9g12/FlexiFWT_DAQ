function RunNumber = saveData(obj,d)
%% Folding Wingtip WTT DAQ - Save data
% Created: R.C.M. Cheung
% Contact: r.c.m.cheung@bristol.ac.uk
% Date: 11 NOV 2019

%get the next run number
RunNumber = GetNextRunNumber();
% RunNumber = 1;
d.cfg.RunNumber = RunNumber;
% create filename string
gName = d.cfg.RunType;
fName = d.cfg.TestType;

if(~isempty(gName))
    fName = [fName,'_',gName];
end
if(d.cfg.Locked)
    fName = [fName,'_locked'];
end
gustString = '';
tabString =  '';
fName = [fName,gustString,tabString];
if(strcmp(fName(1),'_'))
    fName = fName(2:end);
end
fName = [fName,'_Run',num2str(RunNumber),'.mat'];

% save data
[status,msg,~] = mkdir(d.cfg.dataDirectory);
if(~status)
    disp(msg)
end
fprintf('Saving to file:\n%s\n',fName);
save(fullfile(d.cfg.dataDirectory,fName),'d');
end