clear all;
%close all;
restoredefaultpath;
addpath('../CommonLibrary')

% set global parameters
localDir = '../../data/';  % the directory containing the 'data' folder

load('RollData.mat')

configs = {...
    {'RollingRig_Fixed',[],[],[0 0 1],-1,'Fixed',1}...
    ,{'RollingRig_Removed',[],[],[1 0 0],-1,'Removed',0.725}...
    ,{'RollingRig_Removed',[],[],[0,0,1],-0.381,'Removed Scaled to 1m',1}...
    ,{'RollingRig_Free',10,0, [0 0 1],-1,'Free, 10 Degrees Flare',1}...
    ,{'RollingRig_Free',20,0, [0 1 0],-1,'Free, 20 Degrees Flare',1}...
    ,{'RollingRig_Free',30,0, [1 0 0],-1,'Free, 30 Degrees Flare',1}...
    ,{'RollingRig_Free',20,10, [1 0 0],-1,'Free, camber 10, Flare 20 Degrees',1}...
    ,{'RollingRig_Free',20,-10, [0 0 1],-1,'Free, camber -10, Flare 20 Degrees',1}...
    };

AileronAngle = 7;
velocity = 15;

figure(2)
clf;
indicies = [5,7,8];
%indicies = 4:6;
%indicies = [4,5,6];
indicies = [4,5,6];

velocities = [20];
ails = [21];


for v_i = 1:length(velocities)
    velocity = velocities(v_i);
    for a_i = 1:length(ails)
        aileron = ails(a_i);
        subplot(length(ails),length(velocities),(a_i-1)*length(velocities)+v_i);
        legends = {};
        for i = 1:length(indicies)
            % build up filters
            f = {};
            f{1} = {'MassConfig',configs{indicies(i)}{1}};
            f{2} = {'AileronAngle',ails(a_i)};
            f{3} = {'Velocity',{'range',[velocity-2,velocity+2]}};
            f{4} = {'FlareAngle',configs{indicies(i)}{2}};
            f{5} = {'CamberAngle',configs{indicies(i)}{3}};
            filtData = RollData(GetConfigIndicies(RollData,f));
            enc_deg = movmean(filtData(2).EncDeg,100);
            enc_v = diff(enc_deg)*1700; 
            %enc_v = movmean(enc_v,30);
            enc_deg = enc_deg(1:end-2);
            enc_v = enc_v(1:end-1);
            ind = abs(enc_deg)>180;

            enc_deg = mod(enc_deg(ind),360);
            enc_v = abs(enc_v(ind));

            %bin the data
            stepSize = 10;
            bins = 0:10:360;
            
            meanval = zeros(size(bins));
            stdval = zeros(size(bins));
            for j = 1:length(bins)
                inds = (enc_deg>= bins(j)-stepSize/2) & (enc_deg < bins(j)+stepSize/2);
                meanval(j) = mean(enc_v(inds));
                stdval(j) = std(enc_v(inds));
            end
            mBins = bins;
            mBins(mBins>=270) = mBins(mBins>=270) - 360;
            mBins(mBins<270 & mBins>=90) = mBins(mBins<270 & mBins>=90) - 180;
            % plot(bins-180,meanval - mean(meanval),'-o','color',configs{indicies(i)}{4})
            plot(mBins,meanval,'-o','color',configs{indicies(i)}{4})
            hold on
            legends = [legends,configs{indicies(i)}{6}];
        end
        if v_i == length(velocities)
            legend(legends)
    end
    grid on
    %ylim([-30,30])
    %ylim([0.5,1.4])
    title(['Velocity = ',num2str(velocity),' [m/s]'])
    ylabel('Roll rate [Deg/s]')
    xlabel('Roll Angle [Deg]')
    end
end


