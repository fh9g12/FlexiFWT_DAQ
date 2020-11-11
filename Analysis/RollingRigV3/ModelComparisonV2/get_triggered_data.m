function [x,y_org]=get_triggered_data(x,y)
    % filter out noise
    fs = 100;
    order = fs;
    cutoff = 8;
    shape = [1 1 0 0];
    frex = [0, cutoff, cutoff+2,fs/2]/(fs/2);
    filtkern = firls(order,frex,shape);
    y_org = y;
    y = filtfilt(filtkern,1,y);
    %calc gradient
    y_prime = gradient(y)*100;
    y_prime_mean = mean(y_prime(end-500:end));
    
    % calc trigger point        
    thres = 0.1:0.1:0.2;
    inds = zeros(1,length(thres));
    for i = 1:length(thres)
        inds(i) = find(movmedian(abs(y_prime(11:end)/y_prime_mean),6)>thres(i),1);
    end
    I = ~isoutlier(inds);
    p = polyfit(thres(I),inds(I),1);
    ind = round(p(end));
    x_trig = x(ind+10);
%     x_trig = x_trig - round(abs(y_prime(ind+10))/y_prime_mean/0.05*100)/100;
    y_pp = gradient(y_prime)*100;
    x_trig = x_trig - abs(0.05/y_pp(ind+10));
    %re-align x
    x = x-x_trig+0.2;
end
