clear all;
restoredefaultpath;
addpath('../CommonLibrary')
addpath('../CommonLibrary/ERA')

% set global parameters
localDir = '../../data/';  % the directory containing the 'data' folder

% Open the Meta-Data file
load([localDir,'../MetaData.mat']);     % the Metadata filepath   


massConfigs = {'mQtr'};

%% calculate the required runs
currentlockedState = false;
massCases = [1];

% create a set of indicies that covers all mass cases
indicies = true([1,length(MetaData)]);
indicies = indicies & string({MetaData.Job}) == 'StepResponse';
indicies = indicies & string({MetaData.RunType}) == 'StepRelease';
indicies = indicies & string({MetaData.MassConfig}) == 'mQtr';
indicies = indicies & ~[MetaData.Locked];

%get all runs in the Impluse Test (unlocked)
RunsMeta = MetaData(indicies);

% get one of each velocity as an example
[speeds,b] = unique([RunsMeta.Velocity]);
SingleRunsMeta = RunsMeta(b);


dr = 4;
data = [];
for i = 1:length(SingleRunsMeta)
    [y,t] = ExtractData(localDir,SingleRunsMeta(i),dr,'Mac');
    %% filter signal
    dt = 1/(1700/dr);
    fmax = 4;
    [y,~] = filterSignal(y,dt,fmax);
    
    %%remove start + after 7 seconds
    ind = t >= 0.25 & t<7.25;
    t = t(ind)-0.25;
    y = y(ind,:);
    
    % take diffs
    v = diff(y);
    a = diff(y,2);
    
    % normalise accel
    for j=1:size(y,2)
        a(:,j) = a(:,j)/max(a(:,j));
    end
    
    % cut data to just before peak
    [~,ind] = max(a);
    ind=min(ind)-5;
    t=t(ind:end)-t(ind);
    y = y(ind:end,:);
    v = v(ind:end,:);
    a = a(ind:end,:);

    samplingRate = 1700/dr;
    
    f=[];
    
    % ERA using correlated input
    nCorrel = 200; % Number of correlations
    alpha = 50; % Hankel Matrix Num of Rows Multiplier
    [fSelected,dSelected] = runERACorrel(y,samplingRate,fmax,alpha,nCorrel);
    
    ind = findpeaks(a(:,1));
    f(1) = 1/(mean(ind(2:7)-ind(1:6))/samplingRate);
    
    ind = findpeaks(a(:,2));
    f(2) = 1/(mean(ind(2:7)-ind(1:6))/samplingRate);
    
    data=[data;SingleRunsMeta(i).Velocity,SingleRunsMeta(i).AoA,f(1),f(2)];
    
end

figure(3)
hold off
ind = data(:,2)==5;
plot(data(ind,1),data(ind,3),'r-')
hold on
plot(data(ind,1),data(ind,4),'r-')
ind = data(:,2)==10;
plot(data(ind,1),data(ind,3),'b-')
plot(data(ind,1),data(ind,4),'b-')



