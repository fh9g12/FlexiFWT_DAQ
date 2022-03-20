function GetImpact(src,varargin)
%GETIMPACT event function to handle new DAQ data and save a 'hammer impact'
% to file if the right conditions are met
%   Authors: Fintan Healy, Lucian Constantin
%   Email:  fintan.healy@bristol.ac.uk
%   Date:   15/09/2021

    p = inputParser;
    p.addRequired('Filename');
    p.addRequired('props',@(x)isa(x,'avd.Properties')); % properties
    p.addRequired('idx');
    p.addParameter('Init',false);
    p.addParameter('figID',1);
    p.addParameter('Info','');  
    p.addParameter('FR',[0 500]);
    p.parse(varargin{:})
    % This function detects the peaks in force (taps) and sets the stopping
    % criteria for the experiment (10s after the last tap was recorded)
    persistent data t pltobj FreqRange
    global CurrentEvnt
    
    if p.Results.Init
       clear data t pltobj
       pltobj = matlab.graphics.chart.primitive.Line.empty;
       figure(p.Results.figID);clf;
       FreqRange = p.Results.FR;
       return 
    end
    
    % if figure has been closed stop the data processing
    if ~ishandle(p.Results.figID)
        CurrentEvnt = @avd.daq.event.DoNothing;
        src.stop;
    end
    
    try
        %get new data and add to structure (rollover if too long)
        [new_data, new_t, ~] = read(src, src.ScansAvailableFcnCount, "OutputFormat", "Matrix");
        
        % update data buffers
        props = p.Results.props;
        data = [data;new_data];
        t = [t;new_t];
        Fs = round(src.Rate);
        bufferLength = Fs * (props.PreTrigger + props.PostTrigger + 1);
        if length(t)>bufferLength
            data = data(end-bufferLength+1:end,:);
            t = t(end-bufferLength+1:end,1);
        end
        
        % if buffer is full start looking for peaks
        if length(t) == bufferLength
            % ensure data exists that is bigger than min threshold
            if max(data(:,1))>props.Hammer_MinThreshold
                [~,LOCS] = findpeaks(data(:,1),...
                    'MinPeakHeight',props.Hammer_MinThreshold,...
                    'MinPeakDistance',2048);
                % only a valid signal if there is one peak the is within
                % the threshold with enough time either side of it
                if length(LOCS) == 1
                    t0 = t(LOCS);
                    if data(LOCS) < props.Hammer_MaxThreshold && ...
                            t(end) - t0 >= props.PostTrigger && ...
                            t0 - t(1) >= props.PreTrigger
                        % partition data to correct size
                        idx = round(LOCS + Fs.*[-props.PreTrigger,props.PostTrigger]);
                        data = data(idx(1):idx(2),:);
                        t = t(idx(1):idx(2))-t(idx(1));
                        
                        % create data structure
                        RunData = struct;
                        RunData.t = t;
                        RunData.ch = data;
                        RunData.ChannelInfo = props.Channels;
                        RunData.Fs = src.Rate;
                        RunData.Point = props.pos_num(p.Results.idx);
                        RunData.Info = p.Results.Info;
                        RunData.Position = props.coords(p.Results.idx,1:2);

                        save(p.Results.Filename,'RunData');
                        fprintf('... Impact recorded in file %s...\n',p.Results.Filename);
                        CurrentEvnt = @avd.daq.event.DoNothing;
                        src.stop;
                    end
                end
            end
        end
        
        %% plot the buffer (each channel on a seperate row)
        figure(p.Results.figID); 
        if isempty(pltobj)
            pltobj = matlab.graphics.chart.primitive.Line.empty;
            for i = 1:size(data,2)
                idx = (i-1)*2+1;
                subplot(size(data,2),2,idx)
                pltobj(idx) = plot(t, data(:,i),'k-');
                title(src.Channels(i).Name)
                ylabel(src.Channels(i).Range.Units)
                xlabel('time [s]')

                idx = (i-1)*2+2;
                subplot(size(data,2),2,idx)
                L = length(data(:,i));
                f1 = 1/(t(2)-t(1))*(0:(floor(L/2)))/L; % frequency values
                Y = fft(data(:,i));
                P2 = abs(Y/L);
                P1 = P2(1:floor(L/2)+1);

                pltobj(idx) = plot(f1, log(P1),'k-');
                title(src.Channels(i).Name)
                ylabel(src.Channels(i).Range.Units)
                xlabel('Frequency [Hz]')
            end
        else
            for i = 1:size(data,2)
                idx = (i-1)*2+1;
                subplot(size(data,2),2,idx)
                pltobj(idx).XData = t;
                pltobj(idx).YData = data(:,i);

                idx = (i-1)*2+2;
                subplot(size(data,2),2,idx)
                L = length(data(:,i));
                f1 = 1/(t(2)-t(1))*(0:floor(L/2))/L; % frequency values
                Y = fft(data(:,i));
                P2 = abs(Y/L);
                P1 = P2(1:floor(L/2)+1);
                pltobj(idx).XData = f1;
                pltobj(idx).YData = log(P1);
                ylabel(src.Channels(i).Range.Units)
                xlabel('Frequency [Hz]')
            end
        end
        for i = 1:size(data,2)
            idx = (i-1)*2+1;
            subplot(size(data,2),2,idx)
            xlim([min(t),max(t)])
            idx = (i-1)*2+2;
            subplot(size(data,2),2,idx)
            xlim(FreqRange)
        end
    catch err
        disp(err)
        CurrentEvnt = @avd.daq.event.DoNothing;
        src.stop; 
    end
end

