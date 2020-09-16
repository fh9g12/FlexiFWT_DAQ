function [coords] = FWTCoords(centre,angles,lengths)
%FWTCOORDS Summary of this function goes here
%   Detailed explanation goes here
roll = angles(1);
foldLeft = angles(2);
foldRight = angles(3);

mainLength = lengths(1);
FWTLength = lengths(2);

coords = [centre,centre(1)+cosd(roll)*mainLength,centre(2)+sind(roll)*mainLength];
coords = [coords;centre,centre(1)+cosd(roll+180)*mainLength,centre(2)+sind(roll+180)*mainLength];
coords = [coords;coords(1,3:4),coords(1,3)+cosd(roll+foldLeft)*FWTLength,coords(1,4)+sind(roll+foldLeft)*FWTLength];
coords = [coords;coords(2,3:4),coords(2,3)+cosd(roll+foldRight+180)*FWTLength,coords(2,4)+sind(roll+foldRight+180)*FWTLength];
end

