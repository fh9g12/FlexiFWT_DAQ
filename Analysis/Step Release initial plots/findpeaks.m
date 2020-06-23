%%finds peaks and throughs
%%Nagi Hatoum
%%copyright 2005
function [p,t]=findpeaks(s)
warning off
ds=diff(s);
ds=[ds(1);ds];%pad diff
filter=find(ds(2:end)==0)+1;%%find zeros
ds(filter)=ds(filter-1);%%replace zeros
ds=sign(ds);
ds=diff(ds);
t=find(ds>0 & s(1:end-1)>0);
p=find(ds<0 & s(1:end-1)>0);
