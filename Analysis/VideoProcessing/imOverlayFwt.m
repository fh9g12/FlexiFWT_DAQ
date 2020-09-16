function image = imOverlayFwt(origImage,angles,centre,lengths,color,width)
%IMOVE Summary of this function goes here
%   Detailed explanation goes here
if ~exist('color','var')
    color = 'black';
end
if ~exist('width','var')
    width = 10;
end
image = insertShape(origImage,'Line',FWTCoords(centre,angles,lengths),...
    'LineWidth',width,'Color',color);
end
