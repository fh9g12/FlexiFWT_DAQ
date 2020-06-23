function d = SetRunTypeMetaData(d,subCase,testDuration)
%SETRUNTYPEMETADATA Summary of this function goes here
%   Detailed explanation goes here
switch(subCase)
    case(1) % datum
        d.cfg = setMeta(d.cfg,'datum',1);
        d.cfg = setMeta(d.cfg,'RunType','Datum');
        d.cfg = setMeta(d.cfg,'runCount',1);
        d.cfg = setMeta(d.cfg,'velocity',0.0);        
    case(2) % steady-state
        d.cfg = setMeta(d.cfg,'datum',0);
        d.cfg = setMeta(d.cfg,'RunType','StepRelease');
        d.cfg = setMeta(d.cfg,'runCount',1);
    case(3) % steady-state
        d.cfg = setMeta(d.cfg,'datum',0);
        d.cfg = setMeta(d.cfg,'RunType','SteadyRelease');
        d.cfg = setMeta(d.cfg,'runCount',1);
    case(4) % final datum
        d.cfg = setMeta(d.cfg,'datum',1);
        d.cfg = setMeta(d.cfg,'RunType','Datum');
        d.cfg = setMeta(d.cfg,'runCount',2);
        d.cfg = setMeta(d.cfg,'velocity',0.0);
end
d.gust = setMeta(d.gust,'frequency',0.0,'amplitudeDeg',0.0);
d.cfg = setMeta(d.cfg,'postGustPauseDuration',testDuration+1.0);
end

