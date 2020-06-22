close all;clc;fclose all;clear all;restoredefaultpath;
%%
%5deg, 16m/s
 data5d0 = [     0.692          15.78
       2.401           5.41];
%7.5deg, 16m/s
 data7d5 = [      1.223          38.65
       2.339           5.97];
%10deg, 16m/s       
 data10d0 = [        1.846          33.68
       2.241           2.52];
% AoA
aoa = [5,7.5,10];

%%
figure
subplot(2,1,1)
hold all
plot(aoa,[data5d0(1,1),data7d5(1,1),data10d0(1,1)],'o-')
plot(aoa,[data5d0(2,1),data7d5(2,1),data10d0(2,1)],'o-')
hold off
xlabel('AoA, deg')
ylabel('Freq, Hz');
grid on

subplot(2,1,2)
hold all
plot(aoa,[data5d0(1,2),data7d5(1,2),data10d0(1,2)],'o-')
plot(aoa,[data5d0(2,2),data7d5(2,2),data10d0(2,2)],'o-')
hold off
xlabel('AoA, deg')
ylabel('Damping, %');
grid on