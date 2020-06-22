close all;clc;fclose all;clear all;restoredefaultpath;
%% Trim Curve Fit
swSave = 0;
%%
if(swSave)
    dataDirs = ["C:\Users\PXI-1082\Documents\R Cheung\data\19NOV2019\mFull_trim2",...
        "C:\Users\PXI-1082\Documents\R Cheung\data\19NOV2019\mFull_trim3",...
        "C:\Users\PXI-1082\Documents\R Cheung\data\19NOV2019\mFull_trim4",...
        "C:\Users\PXI-1082\Documents\R Cheung\data\20NOV2019\mHalf_trim",...
        "C:\Users\PXI-1082\Documents\R Cheung\data\20NOV2019\mHalf_trim2",...
        "C:\Users\PXI-1082\Documents\R Cheung\data\20NOV2019\mHalf_trim3",...
        "C:\Users\PXI-1082\Documents\R Cheung\data\20NOV2019\mEmpty_trim4",...
        "C:\Users\PXI-1082\Documents\R Cheung\data\21NOV2019\mEmpty_trim",...
        "C:\Users\PXI-1082\Documents\R Cheung\data\21NOV2019\mEmpty_trim2",...
        "C:\Users\PXI-1082\Documents\R Cheung\data\21NOV2019\m3qtr_trim3",...
        "C:\Users\PXI-1082\Documents\R Cheung\data\21NOV2019\m3qtr_trim4",...
        "C:\Users\PXI-1082\Documents\R Cheung\data\21NOV2019\m3qtr_trim5",...
        ];
    %% Load data
    d.alpha = [];
    d.vel = [];
    d.theta = [];
    d.massMoment = [];
    for ii = 1:length(dataDirs)
        % get files in each folder
        dataFiles = dir(dataDirs(ii));
        for jj = 1:size(dataFiles,1)
            if contains(dataFiles(jj).name,'trim_aoa')
                m = load([dataFiles(jj).folder,'\',dataFiles(jj).name]);
                d.alpha = [d.alpha,m.d.cfg.aoa];
                d.vel = [d.vel,m.d.cfg.velocity];
                d.theta = [d.theta,mean(m.d.daq.encoder.v)*m.d.daq.encoder.calibration.slope+...
                    m.d.daq.encoder.calibration.constant];
                d.massMoment = [d.massMoment,findML(m.d)];
            end
        end
    end
    save('trimData.mat','d');
else
    load('trimData.mat');
end
%% show data set
figure
plot3(d.vel,d.alpha,d.theta,'o')
grid on
xlabel('v, m/s')
ylabel('\alpha, deg')
zlabel('\theta, deg')
%%
gamma = 10.0/180.0*pi;
rho = 1.225;
g = 9.81;
L = 1.0;
m = d.massMoment';
theta = d.theta'/180.0*pi;
alpha = d.alpha'/180.0*pi;
q = (0.5*rho*d.vel.^2)';
S = 1.0;
[x] = fitCL(q,S,alpha,theta,m,g,L,gamma);
% find weight moment error
mlErr = findMLErr(q,S,x,alpha,theta,m,g,L,gamma);

figure
plot3(d.alpha,d.theta,mlErr,'o')
grid on
xlabel('\alpha, deg')
ylabel('\theta, deg')
zlabel('Mass Moment Error')

figure
plot3(d.vel,d.theta,mlErr,'o')
grid on
xlabel('v, m/s')
ylabel('\theta, deg')
zlabel('Mass Moment Error')

% find alpha error
alphaFitted = findAlpha(q,S,x,theta,m,g,L,gamma);
alphaFittedDeg = alphaFitted/pi*180;
alphaFittedErr = alphaFittedDeg-d.alpha';

figure
plot3(d.vel,d.theta,alphaFittedErr,'o')
grid on
xlabel('v, m/s')
ylabel('\theta, deg')
zlabel('\alpha Error')

% find alpha, theta = 0.0
alphaFitted = findAlpha(q,S,x,zeros(size(theta)),m,g,L,gamma);
alphaFittedDeg = alphaFitted/pi*180;

figure
plot3(d.vel,d.massMoment,alphaFittedDeg,'o')
grid minor
xlabel('v, m/s')
ylabel('Mass Moment, Nm')
zlabel('\alpha, deg')

IDX = (d.massMoment<0.05)&(d.massMoment>0.03);

figure
plot(d.vel(IDX),alphaFittedDeg(IDX),'o-')
grid minor
xlabel('v, m/s')
ylabel('\alpha, deg')

%% Trim alpha prediction
% find alpha, theta = 0.0, v = 22.0m/s
vel = 20.6;
mCases = unique([m;0.302*87.6e-3]); % add on missing mass case
qCases = 0.5*rho*(ones(size(mCases))*vel).^2;
tCases = zeros(size(mCases));
alphaFitted = findAlpha(qCases,S,x,tCases,mCases,g,L,gamma);
alphaFittedDeg = alphaFitted/pi*180;
fprintf('Velocity = %3.1f m/s\n',vel);
fprintf('Mass Moment (kgm)	Alpha (deg)\n');
disp([mCases,alphaFittedDeg]);
figure
plot(mCases,alphaFittedDeg,'o-')
grid minor
xlabel('Added Mass Moment, Nm')
ylabel('\alpha, deg')
title(['Trim \alpha @ V = ',num2str(vel,'%2.1f'),'m/s']);
%% functions
function ML = findML(dataStrut)
ML = 0;
L = 0.1535:0.0148:0.302; % moment arms
for ii = 0:10
    m = dataStrut.inertia.(sprintf('position_%d',ii)).mass;
    ML = ML+m*1e-3*L(ii+1);
end
end