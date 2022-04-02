function setSineGust(obj,amplitude,freq)
%SETRANDOMGUST Summary of this function goes here
%   Detailed explanation goes here
obj.setAmplitude(amplitude,GustMode.Sine);
obj.setFrequency(freq);
obj.setMode(GustMode.Sine);
end

