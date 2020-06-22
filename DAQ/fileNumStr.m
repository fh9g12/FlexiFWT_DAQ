function [s] = fileNumStr(f)
% Created: R.C.M. Cheung
% Contact: r.c.m.cheung@bristol.ac.uk
% Date: 11 NOV 2019
s = strrep(strrep(num2str(f,'%0.1f'),'.','d'),'-','n');
end