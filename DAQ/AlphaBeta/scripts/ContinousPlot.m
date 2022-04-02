ab = AlphaBeta(1000);
avd.daq.event.ContinousPlot([],'Init',true,'FR',[0 20]);
fig1 = figure(1);clf;
ab.ScansAvailableFcn = @(src,evnt) avd.daq.event.ContinousPlot(src,...
    'figID',fig1,'BufferSeconds',20);
ab.start('continuous');
while ab.Running
    pause(0.5);
end
