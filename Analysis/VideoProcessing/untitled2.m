clear all;
%close all;
restoredefaultpath;
addpath('../CommonLibrary')

% set global parameters
localDir_video = '/Volumes/Seagate Expansi/PhD Files/Data/WT data/VideoData/';  % the directory containing the 'data' folder
localDir_data = '/Volumes/Seagate Expansi/PhD Files/Data/WT data/data/';  % the directory containing the 'data' folder

load('../../VideoMetaData.mat')
[enc,t_enc] = LoadEncoderData(VideoMetaData(2).RunNumber,localDir_data);

name = strsplit(VideoMetaData(2).Filename,'.');
filename = [name{1},'.mat'];
load([localDir_video,VideoMetaData(2).Folder,filename])

for i =2:length(roll)
    if abs(roll(i)-roll(i-1))>180
        delta = roll(i)-roll(i-1);
        sign = abs(delta)/delta;
        roll(i:end) = roll(i:end) + 360*-sign;
    end
end
roll = roll - roll(1);

enc = -1*enc;
v_enc = diff(enc)*1700;
v_roll = diff(roll)*120;

figure(1)
clf;
plot(mod(enc(1:end-1),360),v_enc,'r.')
hold on
plot(mod(roll(1:end-1),360),v_roll,'b.')

