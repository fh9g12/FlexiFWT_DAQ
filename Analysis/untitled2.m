close all
newcolors = [0 0 0;... % black
            230 159 0;... %red
            86 180 233;... %dark blue
            0 158 115;... %dark green
            240 228 66;...   %brown
            0 114 178;...
            255 50 0;...
            204 121 167]./255; %orange;
set(0,'DefaultAxesColorOrder',newcolors(1:2,:))
set(0,'DefaultAxesLineStyleOrder','-|-.')
%set(0,'DefaultAxesColorOrder',[1 0 0;0 1 0; 0 0 1])
f = figure(1);
%colororder(newcolors)
hold off
for i = 1:4
    plot(rand(1,5),rand(1,5)) 
    hold on
end
   
legend()
