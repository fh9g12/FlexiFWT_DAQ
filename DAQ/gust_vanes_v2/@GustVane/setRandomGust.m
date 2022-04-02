function setRandomGust(obj,duration,amplitude)
%SETRANDOMGUST Summary of this function goes here
%   Detailed explanation goes here
obj.setAmplitude(amplitude,GustMode.RandomTurbulence);
obj.setDuration(duration,GustMode.RandomTurbulence);
obj.setMode(GustMode.RandomTurbulence);
end

