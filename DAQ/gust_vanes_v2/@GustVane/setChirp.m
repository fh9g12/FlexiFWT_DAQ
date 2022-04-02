function setChirp(obj,duration,amplitude,start_freq,end_freq)
%SETRANDOMGUST Summary of this function goes here
%   Detailed explanation goes here
obj.setAmplitude(amplitude,GustMode.Chirp);
obj.setDuration(duration,GustMode.Chirp);
obj.setFrequency(start_freq);
obj.setEndFrequency(end_freq);
obj.setMode(GustMode.Chirp);
end

