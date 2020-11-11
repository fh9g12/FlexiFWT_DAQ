function [RunData] = get_angles_with_roll(RunData,varargin)
%GET_ROLL_RATE_WITH_ROLL Summary of this function goes here
%   Detailed explanation goes here
% Default Values
stepSize = 5;
upperLimit = 360;

while ~isempty(varargin)
    switch lower(varargin{1})
          case 'stepsize'
              stepSize = varargin{2};
        case 'upperlimit'
            upperLimit = varargin{2};
          otherwise
              error(['Unexpected option: ' varargin{1}])
    end
    varargin(1:2) = [];
 end

for i = 1:length(RunData)
    enc_deg = RunData(i).ts_data(:,1);
    angles = RunData(i).ts_data(:,2:4);
    
    if enc_deg(end)>0 && RunData(i).AileronAngle < 0
        enc_deg = -enc_deg;
    elseif enc_deg(end)<0 && RunData(i).AileronAngle > 0
        enc_deg = -enc_deg;
    end
    
    final_roll = abs(enc_deg(end));
    start_roll = abs(enc_deg(1));
    periods = (final_roll - 180 - start_roll)/360;
    
    if periods > 2
        ind = abs(enc_deg)>start_roll+360;
    else
        ind = abs(enc_deg)>start_roll+90;
    end

    enc_deg = mod(enc_deg(ind),upperLimit);
    angles = angles(ind,:);
    angles(:,1) = mod(angles(:,1),360);

    %bin the data
    mBins = ((stepSize:stepSize:upperLimit)-stepSize/2)';

    meanval = zeros(length(mBins),3);
    stdval = zeros(length(mBins),3);
    for j = 1:length(mBins)
        inds = (enc_deg>= mBins(j)-stepSize/2) & (enc_deg < mBins(j)+stepSize/2);
        meanval(j,:) = nanmean(angles(inds,:));
        stdval(j,:) = nanstd(angles(inds,:));
    end
    RunData(i).AnglesWithRoll = meanval;
    RunData(i).AnglesStdWithRoll = stdval;
    RunData(i).RollBins_Angles = mBins;
end
end