function [] = saveData(d,save_sw)
%% Folding Wingtip WTT DAQ - Save data
% Created: R.C.M. Cheung
% Contact: r.c.m.cheung@bristol.ac.uk
% Date: 11 NOV 2019

if(save_sw)
    % create filename string
    if(d.gust.oneMinusCosine)
        gName = 'Gust';
    elseif(d.gust.sine)
        gName = 'conGust';
    elseif(d.gust.analogue)
        gName = 'aGust';
    elseif(d.gust.random)
        gName = 'rGust';
    else
        gName = '';
    end
    if(d.tab.sine)
        tName = 'conTab';
    elseif(d.tab.chirp)
        tName = 'chirpTab';
    elseif(d.tab.analogue)
        tName = 'Tab';
    else
        tName = '';
    end
    fName = d.cfg.testType;
    if(~isempty(gName))
        fName = [fName,'_',gName];
    end
    if(~isempty(tName))
        fName = [fName,'_',tName];
    end
    if(d.cfg.locked)
        fName = [fName,'_locked'];
    end
    if(d.cfg.datum)
        fName = [fName,'_datum'];
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
    if(d.cfg.runCount>1)
         fName = [fName,'_Run',num2str(d.cfg.runCount)];
    end
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