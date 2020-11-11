clear all;
%close all;
addsandbox

SimData = load_fixed_data('FixedData.csv');
% SimData = [SimData , load_fixed_data('RemovedData.csv')];
SimData = [SimData , load_fixed_data('FreeData.csv')];
SimData = SimData(strcmp(string({SimData.LiftDist}),'Roll60'));



load('../RunData_500.mat')
[RunData.Source] = deal('WT');
[RunData.T] = deal(0.12);
RunData = RunData(strcmp(string({RunData.RunType}),'Release'));


RunData = concat_structs(RunData,SimData);

% create V channel
for i = 1:length(RunData)
    RunData(i).V = round(RunData(i).Velocity/5)*5;
end

% remove funky runs
runs = [1428,1446];
for i = 1:length(runs)
    I = find([RunData.RunNumber] == runs(i),1);
    if ~isempty(I)
        RunData(I) = [];
    end
end

% get binned roll rate with roll
RunData = get_roll_rate_with_roll(RunData,'stepSize',5,'upperLimit',180);


fig_handle = figure(1);
fig_handle.Position =[1774,497,801,245];
clf;

enviroments = ["WT","sim"];
configs = ["removed","fixed","free10","free30"];
velocities = [15,20,25,30];
plot_areas = {[1,2],[4,5]};
titles = ["Experimental Rise Time [ms]", "Simulated Rise Time [ms]"];

for e_i = 1:length(enviroments)
    res = zeros(length(configs),length(velocities));
    labels = {};
    for c_i = 1:length(configs)
        config = ConfigMeta.CreateMeta(configs(c_i))...
            .set_enviroment(enviroments(e_i))...
            .set_T(0.12);
        labels{c_i} = config.Label;
        for v_i = 1:length(velocities)
            f = config.create_filter();
            f{end+1} = {'AileronAngle',[7,14,21]};
            f{end+1} = {'V',velocities(v_i)};
            filtData = filter_struct(RunData,f);
            res(c_i,v_i) = get_time_constant(filtData);
        end
    end
    res = round(res*1000);
    
    sp = subplot(1,5,plot_areas{e_i});
    delta = res;
    for i=1:size(delta,1)
       delta(i,:) = (delta(i,:)-res(1,:))./res(1,:)*100;
    end
    h=imagesc(delta);
    c = colorbar();
    caxis([-30,30])
    ylabel(c,'% variation from removed case')
    for c = 1:size(res,2)
        for r = 1:size(res,1)
            t = text(c,r,num2str(res(r,c)),'horizontalalignment','center',...
                'verticalalignment','middle');
            t.FontSize = 13;
            if abs(delta(r,c))>10
                t.Color = [1,1,1];
            end
        end
    end
    xticklabels(velocities)
    yticks(1:length(labels))
    yticklabels(labels)
%     h = heatmap(velocities,labels,res);
    sp.FontSize = 13;
    m_res = mean(res(:));
    std_res = std(res(:));    
    xlabel('Velocity [$ms^{-1}$]')
    title(titles(e_i));
end
colormap(flipud(rwb_map(256,25)))
% c_label = 'Rise Time [ms]';
% a1 = annotation('textarrow',[1,1]*0.96,[0.5,0.5],'string',c_label, ...
%       'HeadStyle','none','LineStyle','none','HorizontalAlignment','center','TextRotation',90,'FontSize',13);
% a2 = annotation('textarrow',[1,1]*0.52,[0.5,0.5],'string',c_label, ...
%       'HeadStyle','none','LineStyle','none','HorizontalAlignment','center','TextRotation',90,'FontSize',13);
% colormap('bone')
filename = '/Users/fintan/Desktop/Figures/time_constant_compare.eps';
exportgraphics(fig_handle,filename,'BackgroundColor','none','ContentType','vector')


function h = custom_heatmap(data)
    h=imagesc(data);
    colorbar();
end

function cm = rwb_map(segments,gray_size)
red_section = [ones(segments,1),linspace(0,1,segments)',linspace(0,1,segments)'];
blue_section = [linspace(0,1,segments)',linspace(0,1,segments)',ones(segments,1)];
cm = [red_section;flipud(blue_section)];
cm(segments-gray_size:segments+gray_size,:) = 0.9;
end

function tau = get_time_constant(runData)
    if length(runData)<1
        tau = NaN;
        return
    end
    taus = zeros(1,length(runData));
    for j = 1:length(runData)
        p = runData(j).ts_data(:,1);

        t_tmp = runData(j).t(1:end);
        period = t_tmp(2)-t_tmp(1);
        fs = 1/period;  

        if p(end)<0
            p = -p;
        end            

        dp = get_sgolay_gradients(p,[0,1,2],period,4,floor((fs/5)/2)*2+1);

        bins = 0:5:360;
        I = dp(:,1)>180 & dp(:,1)<180+360*2;
        mean_rr = bin_data(mod(dp(I,1),360),dp(I,2),bins');
        dp_mean = interp1(bins,mean_rr,mod(dp(:,1),360));

        [~,taus(j)] = calc_trigger_time(t_tmp,dp(:,2)./dp_mean);
    end
    tau = mean(taus);
end

function c = bwmap()
c = [0.900000000000000,0.944700000000000,0.974100000000000;0.885714285714286,0.936800000000000,0.970400000000000;0.871428571428571,0.928900000000000,0.966700000000000;0.857142857142857,0.921000000000000,0.963000000000000;0.842857142857143,0.913100000000000,0.959300000000000;0.828571428571429,0.905200000000000,0.955600000000000;0.814285714285714,0.897300000000000,0.951900000000000;0.800000000000000,0.889400000000000,0.948200000000000;0.785714285714286,0.881500000000000,0.944500000000000;0.771428571428572,0.873600000000000,0.940800000000000;0.757142857142857,0.865700000000000,0.937100000000000;0.742857142857143,0.857800000000000,0.933400000000000;0.728571428571429,0.849900000000000,0.929700000000000;0.714285714285714,0.842000000000000,0.926000000000000;0.700000000000000,0.834100000000000,0.922300000000000;0.685714285714286,0.826200000000000,0.918600000000000;0.671428571428572,0.818300000000000,0.914900000000000;0.657142857142857,0.810400000000000,0.911200000000000;0.642857142857143,0.802500000000000,0.907500000000000;0.628571428571429,0.794600000000000,0.903800000000000;0.614285714285714,0.786700000000000,0.900100000000000;0.600000000000000,0.778800000000000,0.896400000000000;0.585714285714286,0.770900000000000,0.892700000000000;0.571428571428571,0.763000000000000,0.889000000000000;0.557142857142857,0.755100000000000,0.885300000000000;0.542857142857143,0.747200000000000,0.881600000000000;0.528571428571429,0.739300000000000,0.877900000000000;0.514285714285714,0.731400000000000,0.874200000000000;0.500000000000000,0.723500000000000,0.870500000000000;0.485714285714286,0.715600000000000,0.866800000000000;0.471428571428571,0.707700000000000,0.863100000000000;0.457142857142857,0.699800000000000,0.859400000000000;0.442857142857143,0.691900000000000,0.855700000000000;0.428571428571429,0.684000000000000,0.852000000000000;0.414285714285714,0.676100000000000,0.848300000000000;0.400000000000000,0.668200000000000,0.844600000000000;0.385714285714286,0.660300000000000,0.840900000000000;0.371428571428571,0.652400000000000,0.837200000000000;0.357142857142857,0.644500000000000,0.833500000000000;0.342857142857143,0.636600000000000,0.829800000000000;0.328571428571429,0.628700000000000,0.826100000000000;0.314285714285714,0.620800000000000,0.822400000000000;0.300000000000000,0.612900000000000,0.818700000000000;0.285714285714286,0.605000000000000,0.815000000000000;0.271428571428571,0.597100000000000,0.811300000000000;0.257142857142857,0.589200000000000,0.807600000000000;0.242857142857143,0.581300000000000,0.803900000000000;0.228571428571429,0.573400000000000,0.800200000000000;0.214285714285714,0.565500000000000,0.796500000000000;0.200000000000000,0.557600000000000,0.792800000000000;0.185714285714286,0.549700000000000,0.789100000000000;0.171428571428571,0.541800000000000,0.785400000000000;0.157142857142857,0.533900000000000,0.781700000000000;0.142857142857143,0.526000000000000,0.778000000000000;0.128571428571429,0.518100000000000,0.774300000000000;0.114285714285714,0.510200000000000,0.770600000000000;0.100000000000000,0.502300000000000,0.766900000000000;0.0857142857142856,0.494400000000000,0.763200000000000;0.0714285714285714,0.486500000000000,0.759500000000000;0.0571428571428572,0.478600000000000,0.755800000000000;0.0428571428571429,0.470700000000000,0.752100000000000;0.0285714285714286,0.462800000000000,0.748400000000000;0.0142857142857142,0.454900000000000,0.744700000000000;0,0.447000000000000,0.741000000000000];
end
