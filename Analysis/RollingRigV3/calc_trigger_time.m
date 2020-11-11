function [t_trig,tau]=calc_trigger_time(t,y)
% CALC_TRIGGER_TIME Calculates the time when the ROlling Rig was released
%   t_trig = CALC_TRIGGER_TIME(t,y) calculates the time in t at which the
%   system was release, where y is the normalised velocity of the release.
%
%    
    % find a point after the release
    I_75 = find(y>0.6321,1);
    y = y(1:I_75);
    t = t(1:I_75);
    
    thres = [0.1,0.15,0.2,0.2212,0.3935];
    inds = zeros(1,length(thres));
    for i = 1:length(thres)
        inds(i) = find(y<thres(i),1,'last');
    end
    p = polyfit(thres(1:3),inds(1:3),1);
    ind = round(p(end));
    if ind<1
        ind = 1;
    end
    t_trig = t(ind);
    tau = (t(end)-t(ind));
    
%     x_trig = x_trig - round(abs(y_prime(ind+10))/y_prime_mean/0.05*100)/100;
%     y_pp = gradient(y_prime)*100;
%     t_trig = t_trig - abs(0.05/y_pp(ind+10));
    %re-align x
%     x = x-x_trig+0.2;
end
