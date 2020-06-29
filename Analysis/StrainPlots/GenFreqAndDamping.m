clear all;
restoredefaultpath;
addpath('../CommonLibrary')
addpath('../CommonLibrary/ERA')

% set global parameters
localDir = '../../data/';  % the directory containing the 'data' folder

% Open the Meta-Data file
load([localDir,'../MetaData.mat']);     % the Metadata filepath   


indicies = true([1,length(MetaData)]);
indicies = indicies & string({MetaData.Job}) == 'StepResponse';
indicies = indicies & string({MetaData.RunType}) == 'StepRelease';
%indicies = indicies & string({MetaData.MassConfig}) == 'mQtr';
indicies = indicies & string({MetaData.MassConfig}) == 'mEmpty';
indicies = indicies & ~[MetaData.Locked];

RunData = MetaData(indicies);


figure(2)
subplot(2,1,1)
hold off
subplot(2,1,2)
hold off

unique_aoa = unique([RunData.AoA]);
    for i = 1:length(unique_aoa)
    aoaData = RunData([RunData.AoA]==unique_aoa(i));
    f=zeros(1,length(aoaData));
    d=zeros(1,length(aoaData));
    parfor j = 1:length(aoaData)
        [f(j),d(j)] = GetFreqAndDamp(aoaData(j),localDir); 
    end
    d = real(d);
    unique_v = unique([aoaData.Velocity]);
    fv=zeros(1,length(unique_v));
    dv=zeros(1,length(unique_v));
    
    for j = 1:length(unique_v)
        ind = [aoaData.Velocity] == unique_v(j);
        fv(j) = mean(f(ind));
        dv(j) = mean(d(ind));
    end
    
    subplot(2,1,1)
    plot(unique_v,fv,'DisplayName',num2str(unique_aoa(i)))
    hold on
    subplot(2,1,2)
    plot(unique_v,dv,'DisplayName',num2str(unique_aoa(i)))
    hold on
end

subplot(2,1,1)
legend
grid minor
subplot(2,1,2)
legend
grid minor

