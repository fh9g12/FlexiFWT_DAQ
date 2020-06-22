close all;clc;fclose all;clear all;restoredefaultpath;
%%
fpass = 15.0;
% fDir = 'C:\Users\PXI-1082\Documents\R Cheung\data\25NOV2019\mFull_locked_conGust_Run4\';
% freq = unique(sort([1.0:0.5:9.0 ...
%     ,1.0:0.1:2.0 ...
%     ,5.0:0.1:7.0 ...
%     ,7.5:0.1:8.5])); % list of gust frequencies
% fnamePrefix = 'conGust_locked_aoa10d0_v21d0_a3d0_f';

% fDir = 'C:\Users\PXI-1082\Documents\R Cheung\data\25NOV2019\mFull_conGust_Run3\';
% freq = unique(sort([1.0:0.5:9.0 ...
%     ,1.5:0.1:3.0 ...
%     ,6.0:0.1:8.5])); % list of gust frequencies
% fnamePrefix = 'mFull_conGust_aoa10d0_v20d6_a5d0_f';

% fDir = 'C:\Users\PXI-1082\Documents\R Cheung\data\26NOV2019\m3Qtr_conGust\';
% fDir = 'C:\Users\PXI-1082\Documents\R Cheung\data\26NOV2019\m3Qtr_conGust_Run3\';
% freq = [1.0:0.2:9.0 ...
%     ,1.3,2.0,2.5,6.0 ...
%     ,2.1,2.4,5.1,6.5,8.5 ...
%     ,2.3,4.9,5.3,5.5,6.2,7.6 ...
%     ,2.5,5.3,5.5,7.9]; % list of gust frequencies
% fnamePrefix = 'm3Qtr_conGust_aoa8d6_v20d6_a5d0_f';

% % fDir = 'C:\Users\PXI-1082\Documents\R Cheung\data\26NOV2019\m3Qtr_locked_conGust_Run4\';
% fDir = 'C:\Users\PXI-1082\Documents\R Cheung\data\27NOV2019\m3Qtr_locked_conGust\';
% % fDir = 'D:\WORK\data\26NOV2019\m3Qtr_locked_conGust_Run4\';
% freq = [1.0:0.2:9.0 ...
%     ,1.4, 3.5, 3.9, 5.6, 6.1, 6.2, 6.3, 8.0, 8.1, 8.4, 9.0];
% fnamePrefix = 'm3Qtr_conGust_locked_aoa8d6_v20d6_a4d0_f';

% fDir = 'C:\Users\PXI-1082\Documents\R Cheung\data\27NOV2019\mHalf_conGust_Run3\';
% % freq = [1.0:0.2:9.0 ...
% %     ,1.4, 3.5, 3.9, 5.6, 6.1, 6.2, 6.3, 8.0, 8.1, 8.4, 9.0];
% freq = [1.0:0.2:9.0 ...
%         ,1.5,1.9,2.1,2.2,2.6,2.7,4.9,5.3,5.5,5.7,5.9,6.3,6.5,6.8,7.7];
% fnamePrefix = 'mHalf_conGust_aoa6d6_v20d6_a5d0_f';


% fDir = 'C:\Users\PXI-1082\Documents\R Cheung\data\28NOV2019\mHalf_locked_conGust_Run3\';
% freq = [1.0:0.2:9.0 ...
%     ,1.5,2.8,3.0,5.6,6.0,6.1,6.2,6.6,6.7,6.9,7.1,7.9,8.0,8.3,8.5,8.8,6.3,6.5,5.9];
% fnamePrefix = 'mHalf_conGust_locked_aoa6d6_v20d6_a4d0_f';

% fDir = 'C:\Users\PXI-1082\Documents\R Cheung\data\28NOV2019\mEmpty_conGust_Run6\';
% freq = [1.0:0.2:9.0 ...
%                 1.6,1.9,2.1,2.6,3.4,4.0,6.3,6.4,6.8,8.2,6.5,6.7,8.3,6.9];
% fnamePrefix = 'mEmpty_conGust_aoa3d0_v20d6_a4d0_f';


% fDir = 'C:\Users\PXI-1082\Documents\R Cheung\data\28NOV2019\mEmpty_locked_conGust_Run7\';
% fDir = 'C:\Users\PXI-1082\Documents\R Cheung\data\29NOV2019\mEmpty_locked_conGust_Run2\';

% freq = [1.0:0.2:9.0 ...
%     1.7,1.8,1.9,3.0,3.2,6.7,6.9,7.0,7.2,7.3,7.6,8.7,8.9,7.5];
% fnamePrefix = 'mEmpty_conGust_locked_aoa3d0_v20d6_a3d0_f';


% fDir = 'C:\Users\PXI-1082\Documents\R Cheung\data\29NOV2019\mEmpty_locked_conGust_Run5\';
% freq = [1.5:0.1:2.3];
% fnamePrefix = 'mEmpty_conGust_locked_aoa3d0_v20d6_a8d0_f';



% fDir = 'C:\Users\PXI-1082\Documents\R Cheung\data\29NOV2019\mQtr_conGust_Run8\';
% freq = [1.0:0.2:9.0 ...
%         ,1.1,1.4,2.1,2.2,2.3,2.4,2.7,5.7,5.8,6.0,6.1,6.3,6.6,8.0,1.9,5.5,6.5,7.9,8.1];
% fnamePrefix = 'mQtr_conGust_aoa4d8_v20d6_a5d0_f';

% fDir = 'C:\Users\PXI-1082\Documents\R Cheung\data\29NOV2019\mQtr_conGust_Run6\';
% freq = 1:.1:2.6;
% fnamePrefix = 'mQtr_conGust_aoa4d8_v20d6_a5d0_f';
% %fnamePrefix = 'mQtr_conGust_aoa10d0_v16d0_a5d0_f';


% fDir = 'C:\Users\PXI-1082\Documents\R Cheung\data\02DEC2019\mQtr_locked_conGust_Run3\';
% freq = [1.0:0.2:9.0 ...
%                 ,1.6,1.7,6.3,6.4,6.5,6.8,6.9,8.1,1.9,6.1,6.7];
% fnamePrefix = 'mQtr_conGust_locked_aoa4d8_v20d6_a5d0_f';


% fDir = 'C:\Users\PXI-1082\Documents\R Cheung\data\EffectOfHingeAngle\03DEC2019\mQtr_conGust_Run2\';
% freq = [1:0.1:2.8];
% fnamePrefix = 'mQtr_conGust_aoa10d0_v16d0_a5d0_f';
%  
% fDir = 'C:\Users\PXI-1082\Documents\R Cheung\data\EffectOfHingeAngle\03DEC2019\mQtr_conGust_Run7\';
% freq = 1:0.1:2.8;
% fnamePrefix = 'mQtr_conGust_aoa5d0_v18d1_a3d0_f';
% 
% fDir = 'C:\Users\PXI-1082\Documents\R Cheung\data\EffectOfHingeAngle\03DEC2019\mQtr_conGust_Run9\';
% freq = 1:0.1:2.8;
% fnamePrefix = 'mQtr_conGust_aoa5d0_v16d0_a5d0_f';

% fDir = 'C:\Users\PXI-1082\Documents\R Cheung\data\EffectOfHingeAngle\05DEC2019\mQtr_locked_conGust_Run3';
% freq = 1.2:0.1:2.2;
% fnamePrefix = 'mQtr_conGust_locked_aoa5d0_v22d5_a4d0_f';

% fDir = 'C:\Users\PXI-1082\Documents\R Cheung\data\EffectOfHingeAngle\05DEC2019\mQtr_locked_conGust_Run6';
% freq = 1.2:0.1:2.2;
% fnamePrefix = 'mQtr_conGust_locked_aoa5d0_v18d1_a5d0_f';

% fDir = 'C:\Users\PXI-1082\Documents\R Cheung\data\EffectOfHingeAngle\05DEC2019\mQtr_locked_conGust_Run10';
% freq = 1.2:0.1:2.2;
% fnamePrefix = 'mQtr_conGust_locked_aoa5d0_v16d0_a5d0_f';

% fDir = 'C:\Users\PXI-1082\Documents\R Cheung\data\EffectOfHingeAngle\05DEC2019\mQtr_locked_conGust_Run13';
% freq = 1.2:0.1:2.2;
% fnamePrefix = 'mQtr_conGust_locked_aoa10d0_v18d1_a5d0_f';

fDir = 'C:\Users\PXI-1082\Documents\R Cheung\data\EffectOfHingeAngle\05DEC2019\mQtr_locked_conGust_Run16';
freq = 1.2:0.1:2.2;
fnamePrefix = 'mQtr_conGust_locked_aoa10d0_v16d0_a5d0_f';


%%
xRef = 8;
zRef = 9;
freq = unique(sort(round(freq*10)/10)); % round to nearest 0.1
for ff = 1:length(freq)
    s = fileNumStr(freq(ff));
    fname = [fnamePrefix,s,'_t0d0.mat'];
    disp(fname);
    m = load([fDir,'\',fname]);
    accV = m.d.daq.accelerometer.v;
    vel = m.d.cfg.velocity;
    for ii = 1:size(accV,2)
        x = accV(:,ii);
%         y = lowpass(x,fpass,m.d.daq.rate);
%         rVec(ff,ii) = rms(y);
        N = length(x);
        Fs = m.d.daq.rate;
        a = m.d.daq.gust.v;
        [FRF, dft_a, dft_b] = FRA(a,x,freq(ff),Fs,N);
        rVec(ff,ii) = abs(FRF);
        % gust FR calibrated
        AmpDeg = rms(a);
        sc = gustScaling(vel,freq(ff),AmpDeg)/AmpDeg;
        rSVec(ff,ii) = rVec(ff,ii)/sc;
    end
end

L = {'z_wg','y_hg','z_hg','x_hg','y_wt','z_wt','x_wt','x_rt','z_rt','z_wgt','z_hgt'};

figure
hold on
plot(freq,rVec,'o-');
legend(L,'location','northeast');
hold off
xlabel('freq, Hz')
ylabel('A')
grid on

figure
hold on
plot(freq,rVec(:,1:7),'o-');
hold off
legend(L{1:7},'location','northeast');
xlabel('freq, Hz')
ylabel('A')
grid on

figure
hold on
plot(freq,rVec(:,8:end),'o-');
hold off
legend(L{8:end},'location','northeast');
xlabel('freq, Hz')
ylabel('A')
grid on

figure
hold on
plot(freq,rSVec,'o-');
legend(L,'location','northeast');
hold off
xlabel('freq, Hz')
ylabel('A_{cal}')
grid on

%%
function [s] = fileNumStr(f)
% Created: R.C.M. Cheung
% Contact: r.c.m.cheung@bristol.ac.uk
% Date: 11 NOV 2019
s = strrep(strrep(num2str(f,'%0.1f'),'.','d'),'-','n');
end

 function [FRF, dft_a, dft_b] = FRA(a,b,f,Fs,N)

% FRA - Frequency Response Analyzer
% Applies Hanning window and then computes FRF point from stepped sine measurement. It uses Goertzel algorithm for computation of discrete Fourier transform 
% 
%   FRF = FRA(a,b,f,Fs)
%   FRF = FRA(a,b,f,Fs,N)
%
% Input parameters:
%   a ... excitation signal - vector (n,1)
%   b ... output signal in steady state - vector(n,1)
%   f ... frequency of interest (excitation frequency) [Hz]
%   Fs ... sampling frequency [Hz]
%   N ... number of points for calculation (N last points from a,b), N should be as high as possible (N < numel(a)) - default: 100 
%
% Output parameters:  
%   FRF - one points of frequency response function at given frequency (f) - compex scalar (1,1)
%
% Example:
%   Fs = 1000;  
%   f = 50; 
%   t = linspace(0,1,Fs);
%   a = sin(2*pi*50*t)';
%   b = 2*sin(2*pi*50*t + pi)';
%   FRF = FRA(a,b,f,Fs);
%   FRF = FRA(a,b,f,Fs,500);
%
% Referencies:
%   [1] Ewins D.J.: Modal Testing: theory, practice and application, 2001
%
% Created by Vaclav Ondra, 20th Jul 2014, Matlab 2014a,

    if nargin == 4 % only 4 inputs entered
        N = 100; % default value for points
    end
    
    win = hann(N); % hanning window
    a = a(end-N+1:end).*win; % application of window on the signal, just in steady state (given by N)
    b = b(end-N+1:end).*win;

    freq_index = round(f/Fs*N)+1; % index of frequency which will be computed

    
    dft_a = 2*2*goertzel(a,freq_index)/N; % DFT computed using Goertzel algorithm - System Processing Toolbox is needed
    dft_b = 2*2*goertzel(b,freq_index)/N; % corrections: first '2' for Hanning window, and '2/N' for the algorithm

    FRF = dft_b/dft_a; % FRF estimate

end
