load('/Volumes/Seagate Expansi/PhD Files/Data/WT data/VideoData/20-Aug-2020/GX010123.mat')
figure(1)
clf;
roll_mod = roll;
for i =2:length(roll)
    if abs(roll(i)-roll(i-1))>180
        delta = roll(i)-roll(i-1);
        sign = abs(delta)/delta;
        roll(i:end) = roll(i:end) + 360*-sign;
    end
end
v_roll = diff(roll)*120;
plot(roll_mod(1:end-1),v_roll,'+')
figure(2)
clf;
subplot(1,2,1)
plot(roll_mod,LeftFold,'+')
hold on
plot(roll_mod,RightFold,'+')
