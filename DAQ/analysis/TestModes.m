v = [16,18,20.6,22.5];
mode1 = [0.69,1.33,1.41,1.58];
mode2 = [2.39,2.31,2.09,1.84];

figure(33)
hold off
plot(v,mode1,'ro-')
hold on
plot(v,mode2,'bo-')
grid minor

plot(v,ones(1,4)*1.65,'k--')
