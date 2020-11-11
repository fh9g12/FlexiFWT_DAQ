function [v] = Correct_video(x,a,b,c,d)
%CORRECT_VIDEO applies a correction to the roll angles extrract from video
%data
if ~exist('a','var')
   a = 1.136;
end
if ~exist('b','var')
   b = 0.2968; 
end
if ~exist('c','var')
   c = -55.61;
end
if ~exist('d','var')
   d = 0.7591;
end
v = sind(2*x)*a + sind(x-c)*b + d;
end

