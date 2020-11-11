function [RunData] = get_roll_rate_with_roll(RunData,varargin)
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
    % get encoder values and assure they are going the correct way for the
    % aileron angle
    enc_deg = RunData(i).ts_data(:,1);   
    if enc_deg(end)>0 && RunData(i).AileronAngle < 0
        enc_deg = -enc_deg;
    elseif enc_deg(end)<0 && RunData(i).AileronAngle > 0
        enc_deg = -enc_deg;
    end
    period = RunData(i).t(2)-RunData(i).t(1);
    fs = 1/period;
    
    % get the filtered encoder angle and encoder velocity
    d_enc = get_sgolay_gradients(enc_deg,[0,1],period,4,floor(fs/5)+1);
    
    % calulate number of complete periods
    final_roll = abs(d_enc(end,1));
    start_roll = abs(enc_deg(1,1));
    periods = (final_roll - 180 - start_roll)/360;
    
    %only select data from last 2 complete periods
    if periods > 2
        ind = abs(d_enc(:,1))>start_roll+360;
    else
        ind = abs(d_enc(:,1))>start_roll+90;
    end
   
    enc_deg = mod(d_enc(ind,1),upperLimit);
    enc_v = d_enc(ind,2);

    %bin the data
    mBins = ((stepSize:stepSize:upperLimit)-stepSize/2)';

    meanval = zeros(size(mBins));
    stdval = zeros(size(mBins));
    for j = 1:length(mBins)
        inds = (enc_deg>= mBins(j)-stepSize/2) & (enc_deg < mBins(j)+stepSize/2);
        meanval(j) = nanmean(enc_v(inds));
        stdval(j) = nanstd(enc_v(inds));
    end
    
    %Return the results
    RunData(i).RollRateWithRoll = meanval;
    RunData(i).RollBins = mBins;
end
end