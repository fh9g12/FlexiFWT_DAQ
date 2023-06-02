clear all;
addsandbox

%% pre-amble

% load SimData
% SimData = load_SimData(["FixedData.csv","FreeData.csv"]);
% SimData = SimData(strcmp(string({SimData.LiftDist}),'Roll60'));

% Load WT RunData
load('../RunData_500.mat')
[RunData.Source] = deal('WT');
[RunData.T] = deal(0.12);
RunData = RunData(strcmp(string({RunData.RunType}),'Release'));
% remove funky runs
runs = [1428,1446];
for i = 1:length(runs)
    I = find([RunData.RunNumber] == runs(i),1);
    if ~isempty(I)
        RunData(I) = [];
    end
end

% Combine Data sources
% RunData = concat_structs(RunData,SimData);

% create V channel
for i = 1:length(RunData)
    RunData(i).V = round(RunData(i).Velocity);
end

RunData = get_roll_rate_with_roll(RunData,'stepSize',5,'upperLimit',360);

%create Configs
configs_tmp = [...
    ConfigMeta.CreateMeta('removed').set_T(0.12),...
    ConfigMeta.CreateMeta('fixed').set_T(0.12),...
    ConfigMeta.CreateMeta('free10').set_T(0.12),...
    ConfigMeta.CreateMeta('free30').set_T(0.12),...
    ];
configs ={};
% for i = 1:length(configs_tmp)
%     configs{end+1} = configs_tmp(i).set_enviroment('sim','--');
% end
for i = 1:length(configs_tmp)
    configs{end+1} = configs_tmp(i).set_enviroment('WT','-');
end

%% create the figures
f_handle = figure(2);
f_handle.Position = [20 20 1020 620];
clf;
AileronAngles = [7,14,21];
count = 1;
for i = 1:length(AileronAngles)
    subplot(2,length(AileronAngles),i)
    for j = 1:length(configs)
        % Build Filter
        f = configs{j}.create_filter();  
        f{end+1} = {'AileronAngle',[AileronAngles(i)]};
        f{end+1} = {'V',[15,20,25,30]};
        filtData = farg.struct.filter(RunData,f);

        % plot the data
        [h,x,y] = PlotMeanData(filtData,'V','getabs',true);
        h.Color = configs{j}.Color;
        h.LineStyle = configs{j}.LineSpec;
        if strcmp(configs{j}.Enviroment,'WT')
            h.DisplayName = configs{j}.Label;
        else
%             h.DisplayName = ['Simulation: ',configs{j}{7}];
            h.Annotation.LegendInformation.IconDisplayStyle = 'off';
        end
        h.LineWidth = 2;
        hold on
    end
    grid
    title(['Aileron Angle: ',num2str(AileronAngles(i)),' deg'])
    xlabel('Velocity [m/s]')
    ylabel('Mean Roll Rate [deg/s]')
    grid minor
    if i == 1
        h = plot (0,-20,'-');
        h.DisplayName = 'Experimental';
        h.Color = [0.2, 0.2, 0.2];
        
        h = plot (0,-20,'--');
        h.DisplayName = 'Simulation';
        h.Color = [0.2, 0.2, 0.2];
        
        legend('location','northwest')
    end
    ylim([0,500])
%     xlim([0,22])
end

%% Plot Normailised Data
for i = 1:length(AileronAngles)
    subplot(2,length(AileronAngles),i+length(AileronAngles))
    for j = 1:length(configs)
        % Build Filter
        f = configs{j}.create_filter();  
        f{end+1} = {'AileronAngle',[AileronAngles(i)]};
        f{end+1} = {'V',[15,20,25,30]};
        filtData = farg.struct.filter(RunData,f);
        % plot the data
        if j == 1
            [xd,yd,~] = GetMeanData(filtData,'V','getabs',true);
            yd = configs{j}.Scaling(xd,yd).*yd;
        end
        h = PlotMeanData(filtData,'V','getabs',true,...
                'ScaleFactor',@(x,y)1./interp1(xd,yd,x,'linear','extrap'));
        ylim([0.2,1.2])  
        h.Color = configs{j}.Color;
        h.LineStyle = configs{j}.LineSpec;
        h.DisplayName = configs{j}.Label;
        h.LineWidth = 2;
        hold on
    end
    grid
    title(['Aileron Angle: ',num2str(AileronAngles(i)),' deg'])
    xlabel('Velocity [m/s]')
    ylabel('Normalised Mean Roll Rate [eg/s]')
    grid minor
end


clear RunData
filename = '/Users/fintan/Desktop/Figures/mean_roll_rate.png';
% exportgraphics(f_handle,filename,'BackgroundColor','white')

function [h,unique_x,rr] = PlotMeanData(RunData,varargin)
    p = inputParser;
    p.addRequired('RunData',@isstruct);
    p.addRequired('Channel');
    p.addParameter('ScaleFactor',@(x,y)1);
    p.addParameter('lineOfBestFit',false);
    p.addParameter('getAbs',false);
    p.parse(RunData,varargin{:});
    
    [unique_x,rr,std_rr] = GetMeanData(RunData,varargin{:});
    rr = rr .* p.Results.ScaleFactor(unique_x,rr);
    std_rr = std_rr .* p.Results.ScaleFactor(unique_x,std_rr);
    h = errorbar((unique_x),((rr)),std_rr);
    hold on
    if p.Results.lineOfBestFit
        p = polyfit(unique_x,rr,3);
        disp(roots(p))
        h = plot(-14:14,polyval(p,-14:14),'-.k');
    end

end

function [unique_x,rr,std_rr] = GetMeanData(RunData,varargin)
    p = inputParser;
    p.KeepUnmatched=true;
    p.addRequired('RunData',@isstruct);
    p.addRequired('Channel');
    p.addParameter('getAbs',false);
    p.parse(RunData,varargin{:});
    
    
    unique_x = unique([RunData.(p.Results.Channel)])';
    rr = zeros(length(unique_x),1);
    std_rr = rr;
    vals = {};
    for i =1:length(unique_x)
        ind = [RunData.(p.Results.Channel)] == unique_x(i);
        tmpData = p.Results.RunData(ind);
        tmp_rr = zeros(1,length(tmpData));
        %tmp_rr_std = zeros(1,length(tmpData));
        for j = 1:length(tmpData)            
            % calc mean values
            vals = tmpData(j).RollRateWithRoll;
            ind = tmpData(j).RollBins<=80 | tmpData(j).RollBins>=280;
            val = mean(vals(:));
            if isnan(val)
                val = mean(diff(tmpData(j).ts_data(end-700:end,1)))*100;
            end
            tmp_rr(j) = val ;
        end
        %vals{i} = tmp_rr;
        if p.Results.getAbs
            tmp_rr = abs(tmp_rr);
        end
        rr(i) = mean(tmp_rr);
        std_rr(i) = std(tmp_rr);
    end
end
