clear all;
close all;
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
%indicies = indicies & string({MetaData.MassConfig}) == 'mEmpty';
indicies = indicies & ~[MetaData.Locked];

RunData = MetaData(indicies);


figure(2)
subplot(2,1,1)
hold off
subplot(2,1,2)
hold off
masses = {'mQtr'};
masses = {'mEmpty'};
masses = {'mQtr_inner'};
masses = {'mQtr_inner','mEmpty'};
lines = ["o-","+-",".-"];


for m_ind = 1:length(masses)
    massData = RunData(string({RunData.MassConfig}) == masses{m_ind});
    unique_aoa = unique([massData.AoA]);
    for i = 1:length(unique_aoa)
        aoaData = massData([massData.AoA]==unique_aoa(i));
        f=zeros(1,length(aoaData));
        d=zeros(1,length(aoaData));
        for j = 1:length(aoaData)
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
        if i ==1
           set(gca,'ColorOrderIndex',1)
        end
        plot(unique_v,fv,lines(m_ind),'DisplayName',sprintf('%.1f AoA, %s case',unique_aoa(i),masses{m_ind}))
        hold on
        subplot(2,1,2)
        if i ==1
           set(gca,'ColorOrderIndex',1)
        end
        plot(unique_v,-1*dv,lines(m_ind),'DisplayName',sprintf('%.1f AoA, %s case',unique_aoa(i),masses{m_ind}))
        hold on
    end
end


subplot(2,1,1)
xlabel('Velocity [m/s]')
ylabel('Frequency [Hz]')
title(sprintf('Frequency and damping of the first bending mode as a function of speed and AoA for mass case %s',masses{m_ind}))
xlim([14,35])
ylim([1.5,3])
legend
grid minor
subplot(2,1,2)
xlabel('Velocity [m/s]')
ylabel('Damping Ratio')
xlim([14,35])
ylim([0,0.8])
legend
grid minor

