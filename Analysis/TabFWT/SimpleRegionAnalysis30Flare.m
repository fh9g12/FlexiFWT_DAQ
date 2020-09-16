clear all;
restoredefaultpath;
addpath('../CommonLibrary')
addpath('../CommonLibrary/ERA')

% set global parameters
localDir = '../../data/';  % the directory containing the 'data' folder

% Open the Meta-Data file
load([localDir,'../MetaData.mat']);     % the Metadata filepath   


indicies = true([1,length(MetaData)]);
indicies = indicies & string({MetaData.Job}) == '30DegreeHinge';
indicies = indicies & (strcmp(string({MetaData.RunType}),'Steady')|strcmp(string({MetaData.RunType}),'StepInput'));
indicies = indicies & ~[MetaData.Locked];

RunData = MetaData(indicies);

unique_aoa = unique([RunData.AoA]);
count = length(unique_aoa);

figure(1)
for i = 1:length(unique_aoa)
    %get indicies of runs at this aoa
    ind = [RunData.AoA]==unique_aoa(i);
    aoa_data = RunData(ind);
    
    subplot(count,1,i)
    hold off
    
    % plot all points
    %plot([RunData(unstableInd).Velocity],[RunData(unstableInd).TabAngle],'+')
    %hold on
    
    %get indicies of runs that were unconditional unstable
    unstableInd = strcmp(string({aoa_data.RunType}),'Steady') & [aoa_data.LCO]==1;
    %plot([RunData(unstableInd).Velocity],[RunData(unstableInd).TabAngle],'ro')
    
    %get indicies of runs that were unconditional stable
    stableInd = strcmp(string({aoa_data.RunType}),'StepInput') & [aoa_data.LCO]==0;
    %plot([RunData(stableInd).Velocity],[RunData(stableInd).TabAngle],'go')
    
    scatter([aoa_data.Velocity],[aoa_data.TabAngle],50,'b','filled')
    hold on
    scatter([aoa_data(unstableInd).Velocity],[aoa_data(unstableInd).TabAngle],50,'r','filled')
    scatter([aoa_data(stableInd).Velocity],[aoa_data(stableInd).TabAngle],50,'g','filled')
    grid minor
    title(sprintf('AoA: %.2f',unique_aoa(i)))
    xlabel('Velocity [m/s]')
    xlim([18,34])
    ylabel('Tab Deflection [Deg]')
end
    
