function RunData = GetMeanRollRates(RunData,MaxPeriods,rollRange,includeInverted,includeEncDeg)
%GETMEANROLLRATES Summary of this function goes here
%   Detailed explanation goes here

addpath('../CommonLibrary')

if ~exist('rollRange','var')
   rollRange = 90; 
end
if ~exist('includeInverted','var')
   includeInverted = 1; 
end

if ~exist('includeEncDeg','var')
   includeInverted = 0; 
end

parfor i =1:length(RunData)
    enc_deg = LoadEncoderData(RunData(i).RunNumber);
    if enc_deg(end)>MaxPeriods*360+180
        startDeg = enc_deg(end) - MaxPeriods*360;
    else
        startDeg = enc_deg(end) - floor((enc_deg(end)-180)/360)*360;
    end
    [~,index] = min( abs( enc_deg-startDeg ) );
    
    enc_deg_trimmed = enc_deg(index:end);
    v_enc_deg = diff(enenc_deg_trimmedc_deg)*1700;
    
    ind = mod(enc_deg_trimmed,360)>360-rollRange;
    ind = ind | mod(enc_deg_trimmed,360)<rollRange;
    if includeInverted
        ind = ind | (mod(enc_deg_trimmed,360)<180+rollRange & mod(enc_deg_trimmed,360)>180-rollRange);
        pm='pm'
    else
        pm=''
    end
    
    
    
    RunData(i).(['MeanRollRate',pm,num2str(rollRange)]) = mean(v_enc_deg(ind(1:end-1)));
    if includeEncDeg
        RunData(i).EncDeg = enc_deg;
    end
end
end

