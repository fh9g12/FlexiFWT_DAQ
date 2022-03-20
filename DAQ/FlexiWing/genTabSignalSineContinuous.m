function [waveForm,timeStamps] = genTabSignalSineContinuous(amplitude,freq,delay,sigLength,totalDuration,samplingFreq,tabOffset)
%% WINDY WTT - generate tab signal - sine
% Created: R.C.M. Cheung
% Contact: r.c.m.cheung@bristol.ac.uk
% Date: 11 July 2019

nSamples = ceil(totalDuration*samplingFreq);
if((freq>0.0)&&(amplitude~=0.0))
    nCycles = sigLength*freq; % number of cycles
    wt = 2*pi*(0.0:freq/samplingFreq:nCycles); % omega*t of sine signal
    nDelay = floor(delay*samplingFreq); % delay, in number of samples
    nSigEnd = nDelay+length(wt); % end of sine signal, in number of samples
    % lengthen signal if delay plus sine is longer than total time
    if(nSamples<nSigEnd)
        nSamples = nSigEnd;
    end
    waveForm = zeros(1,nSamples);
    waveForm((nDelay+1):nSigEnd) = amplitude*sin(wt);
else
    waveForm = zeros(1,nSamples);
end
if(tabOffset~=0.0)
    waveForm = waveForm+tabOffset;
end
timeStamps = (0:nSamples-1)/samplingFreq; % timestamps output
end
