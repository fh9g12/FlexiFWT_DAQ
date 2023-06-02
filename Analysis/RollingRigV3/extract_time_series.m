clear all;
%close all;
restoredefaultpath;
addpath('../CommonLibrary')
addpath('..')
addpath('VideoCalibration/')

% directory with data and VideoData folders in
dataDir = 'D:\PhD Files\Data\WT data';

load(fullfile(dataDir,'MetaData_old.mat'),'MetaData')

% pick only fixed rolling rig jobs
RunData = GetV2Runs(dataDir);

f = waitbar(0,'Please wait...');
for i=1:length(RunData)
    %load run data
    [angles,t] = LoadEncoderData(RunData(i).RunNumber,dataDir);

    % load video data
    if ~isempty(RunData(i).GoProNumber)
        ss = strsplit(RunData(i).VideoFilename,'.');
        [angles_vid,centre,t_vid] = LoadVideoData(fullfile(dataDir,'VideoData',RunData(i).VideoFolder,[ss{1},'.mat']));
        % align data
        [t,angles,angles_vid] = align_encoder_video_data(t_vid,angles_vid,t,angles);
        angles = [angles,angles_vid];
    end

    %down sample to 100Hz
    t_max = floor(t(end)*100)/100;
    fs = 500;
    t_ds = (0:1/fs:t_max)';
    angles = interp1(t,angles,t_ds);
    RunData(i).t = t_ds;
    RunData(i).ts_data = angles;
    waitbar(i/length(RunData),f,'Loading your data');
end
close(f)
save('RunData_500.mat','RunData')