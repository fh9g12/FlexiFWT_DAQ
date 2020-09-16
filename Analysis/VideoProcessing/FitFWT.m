function [x_final] = FitFWT(thresholdIm,centre,lengths,width,x_0,x_range)
%FITFWT Summary of this function goes here
%   Detailed explanation goes here
if ~exist('width')
    width = 10;
end
if ~exist('x_0')
    x_0 =[0,0,0];
end
if ~exist('x_range')
    x_range =[90,90,90];
end

% fit the wing
x_final = [0,0,0];
for index = 1:3
    res = [];
    temp_x = x_final;
    for i=x_0(index)-x_range(index):0.5:x_0(index)+x_range(index)
        temp_x(index) = i;
        res = [res;i,objFunc(temp_x,thresholdIm,centre,lengths,width)];
    end
    [~,i] = min(res(:,2));
    x_final(index) = res(i,1);    
end

end

function val = objFunc(angles,thresholdIm,centre,lengths,width)
binRGB = rgb2gray(imOverlayFwt(thresholdIm,angles,centre,lengths,'black',width));%,0.15);
val = sum(sum(binRGB));
end