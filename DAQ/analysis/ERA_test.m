close all;clc;fclose all;clear all;restoredefaultpath;
%% ERA Test
% mainDir = 'C:\WORK\WINDY_TEST_NOV2019\';
mainDir = 'C:\Users\PXI-1082\Documents\R Cheung\';

addpath([mainDir,'DAQ\ERA']);

% fDir = [mainDir,'data\20NOV2019\rGust'];
% fname = ['rGust_aoa10d0_v21d0_a3d0_t0d0'];

% fDir = [mainDir,'data\21NOV2019\rGust\'];
% fname = ['rGust_aoa5d0_v17d5_a3d0_t0d0'];

% fDir = [mainDir,'data\22NOV2019\mEmpty_rGust2'];
% fname = ['rGust_aoa2d5_v22d0_a3d0_t0d0'];

% fDir = [mainDir,'data\25NOV2019\mFull_rGust'];
% fname = ['mFull_rGust_aoa10d0_v20d6_a3d0_t0d0'];

% fDir = [mainDir,'data\25NOV2019\mFull_locked_rGust2'];
% fname = ['mFull_rGust_locked_aoa10d0_v20d6_a3d0_t0d0'];
% 

% fDir = [mainDir,'data\26NOV2019\m3Qtr_rGust'];
% fname = ['m3Qtr_rGust_aoa8d6_v20d6_a3d0_t0d0'];

% fDir = [mainDir,'data\26NOV2019\m3Qtr_locked_rGust2'];
% fname = ['m3Qtr_rGust_locked_aoa8d6_v20d6_a3d0_t0d0'];
% 
% fDir = [mainDir,'data\27NOV2019\mHalf_rGust'];
% fname = ['mHalf_rGust_aoa6d6_v20d6_a3d0_t0d0'];
% 
% fDir = [mainDir,'data\27NOV2019\mHalf_locked_rGust2'];
% fname = ['mHalf_rGust_locked_aoa6d6_v20d6_a3d0_t0d0'];
% 
% 
% fDir = [mainDir,'data\28NOV2019\mEmpty_rGust'];
% fname = ['mEmpty_rGust_aoa3d0_v20d6_a3d0_t0d0'];
% 
% fDir = [mainDir,'data\28NOV2019\mEmpty_locked_rGust2'];
% fname = ['mEmpty_rGust_locked_aoa3d0_v20d6_a3d0_t0d0'];
% 
% fDir = [mainDir,'data\29NOV2019\mQtr_rGust'];
% fname = ['mQtr_rGust_aoa4d8_v20d6_a3d0_t0d0'];
% 
% fDir = [mainDir,'data\29NOV2019\mQtr_locked_rGust2'];
% fname = ['mQtr_rGust_locked_aoa4d8_v20d6_a3d0_t0d0'];
% 
% % fDir = [mainDir,'data\EffectOfHingeAngle\02DEC2019\mQtr_rGust1'];
% % fname = ['mQtr_rGust_aoa10d0_v18d1_a3d0_t0d0'];
% 
% fDir = [mainDir,'data\EffectOfHingeAngle\03DEC2019\mQtr_rGust1'];
% fname = ['mQtr_rGust_aoa5d0_v22d5_a2d0_t0d0'];

% fDir = [mainDir,'data\EffectOfHingeAngle\03DEC2019\mQtr_rGust3'];
% fname = ['mQtr_rGust_aoa5d0_v16d0_a4d0_t0d0'];

% fDir = [mainDir,'data\EffectOfHingeAngle\03DEC2019\mQtr_rGust2'];
% fname = ['mQtr_rGust_aoa5d0_v18d0_a4d0_t0d0'];

% fDir = [mainDir,'data\EffectOfHingeAngle\02DEC2019\mQtr_rGust1'];
% fname = ['mQtr_rGust_aoa10d0_v16d0_a3d0_t0d0'];

% fDir = [mainDir,'data\EffectOfHingeAngle\03DEC2019\mQtr_rGust5'];
% fname = ['mQtr_rGust_aoa7d5_v16d0_a3d0_t0d0'];

% fDir = [mainDir,'data\EffectOfHingeAngle\02DEC2019\mQtr_rGust1'];
% fname = ['mQtr_rGust_aoa10d0_v18d1_a3d0_t0d0'];

% fDir = [mainDir,'data\EffectOfHingeAngle\03DEC2019\mQtr_rGust2'];
% fname = ['mQtr_rGust_aoa5d0_v18d0_a4d0_t0d0'];

% fDir = [mainDir,'data\EffectOfHingeAngle\03DEC2019\mQtr_rGust4'];
% fname = ['mQtr_rGust_aoa7d5_v18d1_a3d0_t0d0'];


% fDir = [mainDir,'data\EffectOfHingeAngle\05DEC2019\mQtr_locked_rGust'];
% fname = ['mQtr_rGust_locked_aoa5d0_v22d5_a2d0_t0d0'];

% fDir = [mainDir,'data\EffectOfHingeAngle\05DEC2019\mQtr_locked_rGust2'];
% fname = ['mQtr_rGust_locked_aoa5d0_v18d1_a3d0_t0d0'];

% fDir = [mainDir,'data\EffectOfHingeAngle\05DEC2019\mQtr_locked_rGust3'];
% fname = ['mQtr_rGust_locked_aoa5d0_v16d0_a3d0_t0d0'];

fDir = [mainDir,'data\EffectOfHingeAngle\05DEC2019\mQtr_locked_rGust6'];
fname = ['mQtr_rGust_locked_aoa10d0_v16d0_a3d0_t0d0'];

fDir = [mainDir,'data\25NOV2019\mFull_rGust'];
fname = ['mFull_rGust_aoa10d0_v20d6_a3d0_t0d0'];

fDir = [mainDir,'data\27NOV2019\mHalf_rGust'];
fname = ['mHalf_rGust_aoa6d6_v20d6_a3d0_t0d0'];


%% prep
% channel names = {'z_wg','y_hg','z_hg','x_hg','y_wt','z_wt','x_wt','x_rt','z_rt','z_wgt','z_hgt'}
% zIdx = [1,3,6,10,11];
zIdxRef = 9;        % Z Refernce at the root
% zIdx = [3];       % Z Tri-Axis at the Hinge
zIdx = [6];         % Wingtip Tri-axis Z
% zIdx = [3,6];

xIdxRef = 2;        % root x ref
% xIdx = [4,7];
% xIdx = [4];       % Hinge (Tri-axis) X
xIdx = [5];         % WIngtip (Tri-axis) X
%% load files
dr = 4;
[fSelected,dSelected] = readFile(zIdx,zIdxRef,fDir,fname,dr);       % Z plot
% [fSelected,dSelected] = readFile(xIdx,xIdxRef,fDir,fname,dr);     % X plot
%% Function
function [fSelected,dSelected] = readFile(idx,idxRef,fDir,fname,dr)
% read files
y = [];
for ii = 1:5
    if(ii>1)
        matFile = [fDir,'\',fname,'_Run',num2str(ii),'.mat'];
    else
        matFile = [fDir,'\',fname,'.mat'];
    end
    disp(matFile);
    m = load(matFile);
    
%     encoderAngle = mean(m.d.daq.encoder.v.*m.d.daq.encoder.calibration.slope...
%         + m.d.daq.encoder.calibration.constant);
    
    for jj = 1:length(idx)
        x = m.d.daq.accelerometer.calibration(idx(jj))*m.d.daq.accelerometer.v(:,idx(jj)) ...
            -m.d.daq.accelerometer.calibration(idxRef)*m.d.daq.accelerometer.v(:,idxRef);
        v(:,jj) = decimate(x,dr);
    end
    y = [y,v];
%         y = [y,m.d.daq.accelerometer.v(:,zIdx)'];
end
samplingRate = m.d.daq.rate/dr;
fmax = 15.0;

% alpha = 80; % Hankel Matrix Num of Rows Multiplier
% [fSelected,dSelected] = runERA(y,samplingRate,fmax,alpha);

% % ERA using correlated input
% nCorrel = 400; % Number of correlations
% alpha = 50; % Hankel Matrix Num of Rows Multiplier
nCorrel = 400;
alpha = nCorrel/2;
[fSelected,dSelected] = runERACorrel(y,samplingRate,fmax,alpha,nCorrel);

fprintf('ERA Freq(Hz) ERA Damping(%%)\n')
fprintf('%12.3f %14.2f\n',[fSelected,dSelected]');
end