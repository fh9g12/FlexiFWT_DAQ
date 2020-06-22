function [] = reportGustSettings(d)
if(d.cfg.genGust)
    if(d.gust.sine==1)
        fprintf('Continuous Gust\n');
        fprintf(' Frequency:        %4.1f Hz\n',d.gust.frequency);
        fprintf(' Vane Angle: 0.0 ->%4.1f deg\n',d.gust.amplitudeDeg);
        fprintf(' Duration:         %4.1f sec\n',d.gust.duration);
        fprintf('\n');
    elseif(d.gust.oneMinusCosine==1)
        fprintf('1-Cosine Gust\n');
        fprintf(' Frequency:  %4.1f Hz\n',d.gust.frequency);
        fprintf(' Vane Angle: 0.0 ->%4.1f deg\n',d.gust.amplitudeDeg);
        fprintf('\n');
    elseif(d.gust.random==1)
        fprintf('Random Gust\n');
        fprintf(' Vane Angle: ±%4.1f deg\n',d.gust.amplitudeDeg);
        fprintf(' Duration:    %4.1f sec\n',d.gust.duration);
        fprintf('\n');
    end
end
end