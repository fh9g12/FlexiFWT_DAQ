%% get roll
res = [];
for i=-90:0.25:90
    res = [res;i,objFunc(i,0,0,grayFrame)];
end
[v,i] = min(res(:,2));
roll_obj = res(i,1);

%% get left FWT
res = [];
for i=-90:0.25:90
    res = [res;i,objFunc(roll_obj,i,0,grayFrame)];
end
[v,i] = min(res(:,2));
left_obj = res(i,1);


%% get right FWT
res = [];
for i=-90:0.25:90
    res = [res;i,objFunc(roll_obj,left_obj,i,grayFrame)];
end
[v,i] = min(res(:,2));
right_obj = res(i,1);

[roll_obj,left_obj,right_obj]




function val = objFunc(roll,tip1,tip2,grayFrame)
RGB = insertShape(grayFrame,'Line',FWTCoords([234,186],112,50,roll,tip1,tip2),'LineWidth',10,'Color','black');
RGB = rgb2gray(RGB);
binRGB = imbinarize(RGB,0.15);
val = sum(sum(binRGB));
end