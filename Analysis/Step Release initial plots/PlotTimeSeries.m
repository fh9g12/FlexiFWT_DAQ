clear all;
close all;
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

iAccelRef = [9];
iAccel = [6];
% iAccelRef = [2];
% iAccel = [5];

y =[];
dr = 4;

for i= 1:length(SingleRunsMeta)
    m = load([localDir,SingleRunsMeta(i).Folder,'/',SingleRunsMeta(i).Filename]);
    
    for jj = 1:length(iAccel)
        x = m.d.daq.accelerometer.calibration(iAccel(jj))*m.d.daq.accelerometer.v(:,iAccel(jj)) ...
            -m.d.daq.accelerometer.calibration(iAccelRef(jj))*m.d.daq.accelerometer.v(:,iAccelRef(jj));
        v(:,jj) = decimate(x,dr);
    end
    y = [y,v];
end

dt = 1/(1700/dr);
fmax = 8;
%% filter signal
[y,~] = filterSignal(y,dt,fmax);

%normlise to largest peak
[maxval,peakIndex] = max(y);




for i = 1:size(y,2)
   y(:,i) = y(:,i)./maxval(i);
   [a,~]=findpeaks(y(:,i));
   peaks = a(y(a,i)>0.5);
   y(:,i) = y(:,i)./y(peaks(1),i);
   peakIndex(i) = peaks(1);
end

% normalise to the first peak over 0.5




for i = 2:size(y,2)
    delta = peakIndex(1)-peakIndex(i);
    if delta > 0
        y(:,i)=[zeros(delta,1);y(1:end-delta,i)];
    elseif delta < 0
        y(:,i)=[y(1-delta:end,i);zeros(-delta,1)];
    end
end

figure(5)
plot((1:20:3000)/425,y(1:20:3000,:))
grid minor
l = legend(arrayfun(@(x)sprintf('%.1f m/s',x),round(speeds,1),'UniformOutput',false));
l.FontSize = 18;
t = title('Normalised response of the Wing-tip Z accelerometer to a Step Response at multiple speeds (Unlocked)');
ylabel('Normailised Response')
xlabel('Time [s]')

