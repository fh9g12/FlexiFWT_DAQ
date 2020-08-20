clear all;
%close all;
restoredefaultpath;
addpath('../CommonLibrary')
addpath('../CommonLibrary/ERA')

% set global parameters
localDir = '../../data/';  % the directory containing the 'data' folder

% Open the Meta-Data file
load([localDir,'../MetaData.mat']);     % the Metadata filepath

indicies = true([1,length(MetaData)]);
indicies = indicies & contains(string({MetaData.Job}),'RollingRigv');
indicies = indicies & ~contains(string({MetaData.Folder}),'29-Jul-2020'); % bad day of testing
indicies = indicies & [MetaData.RunNumber]~=1073; % weird speed
indicies = indicies & (strcmp(string({MetaData.RunType}),'Release')|strcmp(string({MetaData.RunType}),'Steady'));
%indicies = indicies & [MetaData.LCO];

RunData = MetaData(indicies);

runData = LoadRunNumber(RunData(6).RunNumber);

enc_deg = LoadEncoderData(RunData(6).RunNumber);


for i = 1:length(RunData)
    enc_deg = LoadEncoderData(RunData(i).RunNumber);
    RunData(i).MeanRollRate = nanmean(diff(enc_deg(end-1700*5:end)));
end


rigs = unique(string({RunData.Job}));
Models = unique(string({RunData.MassConfig}));
Models = Models([1,2,4]);

lines = ["-s","--o","-.*"];
colors = ["r","g","b","k","c"];
figure(2)
clf
for i = 1:length(rigs)
    rigIndex = string({RunData.Job}) == rigs(i);
    for j = 1:length(Models)
        modelIndex = string({RunData.MassConfig}) == Models(j);
        index = rigIndex & modelIndex;
        tempData = RunData(index);
        unique_V = unique([tempData.Velocity]);
        dat = [];
        for k =1:length(unique_V)
            vData = tempData([tempData.Velocity] == unique_V(k));
            dat = [dat;unique_V(k),mean([vData.MeanRollRate]),std([vData.MeanRollRate])];           
        end
        pf = polyfit(dat(:,1),dat(:,2)*1700,1);           
        plot(dat(:,1),polyval(pf,dat(:,1)),colors(i)+lines(j))
        hold on
    end
end
grid minor
xlabel('Velocity [m/s]')
ylabel('Avergae Roll Rate [Deg/s]')