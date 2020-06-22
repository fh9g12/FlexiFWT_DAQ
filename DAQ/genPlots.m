function [] = genPlots(d)
    figure(1)
    subplot(4,1,1)
    plot(d.daq.t,d.daq.strain.v)
    xlabel('Time, s')
    ylabel('Strain Ch, v')
    subplot(4,1,2)
    plot(d.daq.t,d.daq.encoder.v)
    xlabel('Time, s')
    ylabel('Encoder Ch, v')
    subplot(4,1,3)
    plot(d.daq.t,d.daq.sync.v)
    xlabel('Time, s')
    ylabel('Sync Ch, v')
    subplot(4,1,4)
    plot(d.daq.t,d.daq.gust.v)
    xlabel('Time, s')
    ylabel('Gust Ch, v')
    
    figure(2)
    sz = size(d.daq.accelerometer.v,2);
    for ii = 1:sz
        subplot(sz,1,ii)
        plot(d.daq.t,d.daq.accelerometer.v(:,ii))
        xlabel('Time, s')
        ylabel([strrep(d.daq.accelerometer.Name{ii},'_','\_'),', v'])
%         title([d.daq.accelerometer.Name{ii}]);
    end
    subplot(sz,1,1)
    title('Accelerometer Ch')
end