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
indicies = indicies & string({MetaData.Job}) == 'RollingRigv1_1';
indicies = indicies | string({MetaData.Job}) == 'RollingRig_NewMount';
%indicies = indicies & (strcmp(string({MetaData.RunType}),'Steady')|strcmp(string({MetaData.RunType}),'StepInput'));
%indicies = indicies & [MetaData.LCO];

RunData = MetaData(indicies);

runData = LoadRunNumber(RunData(6).RunNumber);
%runData = LoadFromFile('/Users/fintan/OneDrive - University of Bristol/Documents/Projects/3_Rolling Experiment/data/20MAR2020/Locked/trim_locked_datum_aoa0d0_v20d0_t0d0.mat');
enc_v = runData.daq.encoder.v;

%turn into degrees and remove jumps
enc_deg = enc_v / 5 * 360;
for i=1:length(enc_deg)-1
    if enc_deg(i+1)+180<enc_deg(i)
        enc_deg(i+1:end) = enc_deg(i+1:end) + 360;
    end
end


t = runData.daq.t;

fs = 1700;
fcutoff = 10;
transw =0.1;
order = round(17*fs/fcutoff);

shape = [1 1 0 0];
frex = [0 fcutoff fcutoff+fcutoff*transw fs/2]./(fs/2);
filtkern = firls(order,frex,shape);
enc_deg_filt = filtfilt(filtkern,1,enc_deg);

figure(1)
hold off
plot(t,mod(enc_deg,360),'r-')
hold on
%plot(t,mod(enc_deg_filt,360),'b-')


figure(2)
hold off
plot(mod(enc_deg(2:end),360),diff(enc_deg),'r.')
hold on 
plot(mod(enc_deg_filt(2:end),360),diff(enc_deg_filt),'b.')
ylim([-1 1])