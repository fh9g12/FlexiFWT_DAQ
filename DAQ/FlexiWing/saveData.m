function [] = saveData(d,save_sw)
%% Folding Wingtip WTT DAQ - Save data
% Created: R.C.M. Cheung
% Contact: r.c.m.cheung@bristol.ac.uk
% Date: 11 NOV 2019

if(save_sw)
    %get the next run number
    d.cfg.RunNumber = GetNextRunNumber();    
    % create filename string
    gName = d.cfg.RunType;
    fName = d.cfg.testType;
    
    if(~isempty(gName))
        fName = [fName,'_',gName];
    end
    if(d.cfg.locked)
        fName = [fName,'_locked'];
    end
    
    if(d.cfg.datum)
        gustString = '';
        tabString = ['_t',fileNumStr(d.tab.trimDeg)];
    else
        if(d.gust.oneMinusCosine || d.gust.sine)
            gustString = ['_a',fileNumStr(d.gust.amplitudeDeg), ...
                '_f',fileNumStr(d.gust.frequency)];
        elseif(d.gust.random)
            gustString = ['_a',fileNumStr(d.gust.amplitudeDeg)];            
        else
            gustString = '';
        end
        if(d.tab.sine || d.tab.chirp)
            tabString = ['_tf',fileNumStr(d.tab.frequency)];
            if(d.tab.chirp)
                tabString = [tabString, ...
                    '_f',fileNumStr(d.tab.frequencyEnd)];
            end
            tabString = [tabString, ...
                '_a',fileNumStr(d.tab.amplitudeDeg),...
                '_t',fileNumStr(d.tab.trimDeg)];
        else
            tabString = ['_t',fileNumStr(d.tab.trimDeg)];
        end
    end
    fName = [fName, ...
        '_aoa',fileNumStr(d.cfg.aoa), ...
        '_v',fileNumStr(d.cfg.velocity)];
    fName = [fName,gustString,tabString];
    if(strcmp(fName(1),'_'))
        fName = fName(2:end);
    end
    fName = [fName,'_Run',num2str(d.cfg.RunNumber)];
    fName = [fName,'.mat'];
        
    % save data
    [status,msg,~] = mkdir(d.cfg.dataDirectory);
    if(~status)
        disp(msg)
    end
    fprintf('Saving to file:\n%s\n',fName);
    save([d.cfg.dataDirectory,'\',fName],'d');
end
end