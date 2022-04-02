function setOneMinusCosine(obj,amplitude,freq,inverted)
%SETRANDOMGUST Summary of this function goes here
%   Detailed explanation goes here
obj.setAmplitude(amplitude,GustMode.OneMinusCosine);
obj.setFrequency(freq);
obj.setInverted(inverted);
obj.setMode(GustMode.OneMinusCosine);
end

