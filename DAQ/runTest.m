function [] = runTest(s,d)
%% Folding Wingtip WTT DAQ - Run Test
% Created: R.C.M. Cheung
% Contact: r.c.m.cheung@bristol.ac.uk
% Date: 25 NOV 2019
%% Set up Gust Vanes
if(d.cfg.genGust)
    if(d.gust.amplitudeDeg>0)
        if(d.gust.random)
            setGustVanesRandom(d.GustVane.TOP_DRIVE,d.GustVane.BOT_DRIVE, ...
                d.GustVane.MODE,d.gust.duration,d.gust.amplitudeDeg);
        elseif(d.gust.frequency>0)
            setGustVanes(d.GustVane.TOP_DRIVE,d.GustVane.BOT_DRIVE, ...
                d.GustVane.MODE,d.gust.frequency,d.gust.amplitudeDeg);
        end
    end
end
%% Measure
% fprintf('Case: Gust FRQ = %3.1f Hz\n',d.gust.frequency);
reportGustSettings(d);
fprintf('Begin Measurement... \n');

% [NI.data,NI.timeStamps,NI.triggerTime] = s.startForeground;
s.startBackground();

if(d.cfg.genGust)
    if(d.gust.amplitudeDeg>0)
        if((d.gust.random)||(d.gust.frequency>0))
            pause(d.cfg.preGustPauseDuration);
            fprintf('Start Gust Excitation... \n');
            runGustVanes(d.GustVane.TOP_DRIVE,d.GustVane.BOT_DRIVE,d.gust.duration);
        end
    end
end
s.wait();
fprintf('DONE!\n');
end