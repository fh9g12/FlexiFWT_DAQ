function ContinousPlot(src,varargin)
%CONTINOUSPLOT event function to handle new DAQ data and contious print the
%latest 'N' seconds to the screen
%   Authors: Fintan Healy, Lucian Constantin
%   Email:  fintan.healy@bristol.ac.uk
%   Date:   15/09/2021
p = inputParser;
p.addParameter('Init',false);
p.addParameter('figID',1);
p.addParameter('BufferSeconds',6);
p.addParameter('FR',[0 20]);
p.addParameter('FFT',false);
p.parse(varargin{:})

cols = double(p.Results.FFT) + 1;
persistent data timestamps pltobj FreqRange bufferlength
global CurrentEvnt

% if init initilise persistent objects
if p.Results.Init
    clear data timestamps pltobj
    pltobj = matlab.graphics.chart.primitive.Line.empty;
    figure(p.Results.figID);clf;
    FreqRange = p.Results.FR;
    return
end
%intilise data if empty
if ~ishandle(p.Results.figID)
    src.stop;
    CurrentEvnt = @avd.daq.event.DoNothing;

    RunData = struct;
    RunData.t = timestamps;
    RunData.data = data;
    RunData.Fs = src.Rate;

    save('test.mat','RunData');
end
try
    %% get new data and add to structure (rollover if too long)
    [new_data, new_timestamps, ~] = read(src, src.ScansAvailableFcnCount, "OutputFormat", "Matrix");

    % update data buffers
    data = [data;new_data];
    timestamps = [timestamps;new_timestamps];
    if length(timestamps)>round(src.Rate*p.Results.BufferSeconds)
        data = data(end-round(src.Rate*p.Results.BufferSeconds)+1:end,:);
        timestamps = timestamps(end-round(src.Rate*p.Results.BufferSeconds)+1:end,1);
    end

    %% plot the buffer (each channel on a seperate row)
    figure(p.Results.figID)
    if isempty(pltobj)
        pltobj = matlab.graphics.chart.primitive.Line.empty;
        for i = 1:size(data,2)
            if p.Results.FFT
                idx = (i-1)*2+1;
            else
                idx = i;
            end
            subplot(size(data,2),cols,idx)
            pltobj(idx) = plot(timestamps, data(:,i),'k-');
            title(src.Channels(i).Name)
            ylabel(src.Channels(i).Range.Units)
            xlabel('time [s]')

            if p.Results.FFT
                idx = (i-1)*2+2;
                subplot(size(data,2),cols,idx)
                L = length(data(:,i));
                f1 = 1/(timestamps(2)-timestamps(1))*(0:(floor(L/2)))/L; % frequency values
                Y = fft(data(:,i));
                P2 = abs(Y/L);
                P1 = P2(1:floor(L/2)+1);

                pltobj(idx) = plot(f1, log(P1),'k-');
                title(src.Channels(i).Name)
                ylabel(src.Channels(i).Range.Units)
                xlabel('Frequency [Hz]')
            end
        end
    else
        for i = 1:size(data,2)
            if p.Results.FFT
                idx = (i-1)*2+1;
            else
                idx = i;
            end
            subplot(size(data,2),cols,idx)
            pltobj(idx).XData = timestamps;
            pltobj(idx).YData = data(:,i);
%             tit = title(sprintf('%.4f',mean(data(:,i))*1e6));
            tit = title(sprintf('%.4f',mean(data(:,i))));
            tit.FontSize = 30;

            idx = (i-1)*2+2;
            if p.Results.FFT
                subplot(size(data,2),cols,idx)
                L = length(data(:,i));
                f1 = 1/(timestamps(2)-timestamps(1))*(0:floor(L/2))/L; % frequency values
                Y = fft(data(:,i));
                P2 = abs(Y/L);
                P1 = P2(1:floor(L/2)+1);
                pltobj(idx).XData = f1;
                pltobj(idx).YData = log(P1);
                ylabel(src.Channels(i).Range.Units)
                xlabel('Frequency [Hz]')
            end
        end
    end
    for i = 1:size(data,2)
        if p.Results.FFT
            idx = (i-1)*2+1;
        else
            idx = i;
        end
        subplot(size(data,2),cols,idx)
        xlim([min(timestamps),max(timestamps)])
        if p.Results.FFT
            idx = (i-1)*2+2;
            subplot(size(data,2),2,idx)
            xlim(FreqRange)
        end
    end
catch err
    disp(err)
    src.stop;
    CurrentEvnt = @avd.daq.event.DoNothing;
end
end

