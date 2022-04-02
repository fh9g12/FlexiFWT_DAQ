function genPlot(obj,data,fig_obj)
%CONTINOUSPLOT event function to handle new DAQ data and contious print the
%latest 'N' seconds to the screen
%   Authors: Fintan Healy, Lucian Constantin
%   Email:  fintan.healy@bristol.ac.uk
%   Date:   15/09/2021
if ~exist('fig_obj','var')
    figure(2);clf;
else
    figure(fig_obj);
end
for i = 1:length(obj.Channels)
    subplot(length(obj.Channels),1,i);
    plot(data.t,data.daq.(obj.Channels(i).Name).val);
    xlabel('Time (s)');
    ylabel(obj.Channels(i).Name);
end
drawnow;
end

