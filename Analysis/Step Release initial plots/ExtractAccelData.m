restoredefaultpath;
addpath('..\CommonLibrary')
addpath('..\CommonLibrary\ERA')

% set global parameters
localDir = '../../data/';  % the directory containing the 'data' folder

% Open the Meta-Data file
load([localDir,'..\MetaData.mat']);     % the Metadata filepath   


massConfigs = {'mFull','m3Qtr','mHalf','mQtr','mEmpty'};

%% calculate the required runs
currentlockedState = false;
massCases = [2,4];

% create a set of indicies that covers all mass cases
indicies = true([1,length(MetaData)]);
indicies = indicies & string({MetaData.Job}) == 'ImpulseResponseStudy';
indicies = indicies & string({MetaData.TestType}) == 'steadyState';
indicies = indicies & string({MetaData.MassConfig}) == 'mQtr';
indicies = indicies & ~[MetaData.Locked];

%get all runs in the Impluse Test (unlocked)
RunsMeta = MetaData(indicies);

% get one of each velocity as an example
[speeds,b] = unique([RunsMeta.Velocity]);
SingleRunsMeta = RunsMeta(b);

iAccel = 1:11;
% iAccelRef = [2];
% iAccel = [5];

Data = struct();

y =[];
dr = 4;

for i= 1:length(SingleRunsMeta)
    m = load([localDir,SingleRunsMeta(i).Folder,'\',SingleRunsMeta(i).Filename]);    
    for jj = 1:length(iAccel)
        x = m.d.daq.accelerometer.calibration(iAccel(jj))*m.d.daq.accelerometer.v(:,iAccel(jj));
        v(:,jj) = decimate(x,dr);
    end
    Data.(sprintf('v%i',round(SingleRunsMeta(i).Velocity))).y = v;
    %y = [y,v];
end
save('StepResponseData.mat','Data');

