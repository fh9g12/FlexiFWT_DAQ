function d = SetRunTypeMetaData(d,subCase)
%SETRUNTYPEMETADATA Summary of this function goes here
%   Detailed explanation goes here
switch(subCase)
    case(1) % datum
        d.cfg.datum = 1;
        d.cfg.RunType = 'Datum';
        d.cfg.velocity =0;
    case(2) % steady-state
        d.cfg.datum = 0;
        d.cfg.RunType = 'Steady';
    case(3) % steady-state
        d.cfg.datum = 0;
        d.cfg.RunType = 'Gust';
    case(4) % final datum
        d.cfg.datum = 1;
        d.cfg.RunType = 'Datum';
        d.cfg.velocity =0;
end
end

