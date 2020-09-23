function [lag] = calc_encoder_video_delay_v2(t_vid,roll_vid,t_enc,roll_enc)
%CALC_ENCODER_VIDEO_DELAY Summary of this function goes here
%   Detailed explanation goes here

    % ensure roll and encoder are equal at the start ( as they should both
    % start stationary)
    delta = mean(roll_vid(1:20))-mean(roll_enc(1:20));
    roll_vid = roll_vid - delta;
    
    % up scale video data to encoder data
    t_vid_up = 0:1/1700:floor(t_vid(end)*1700)/1700;
    vid_n = length(t_vid_up);
    roll_vid = interp1(t_vid,roll_vid,t_vid_up)';
    roll_vid(isnan(roll_vid)) = 0;
    ro
    n = length(t_enc);
    
    
    % calc the delta of moving one past the other (puesdo convolution)
    roll_enc_padded = [flipud(roll_enc);roll_enc;flipud(roll_enc)];
    
    n_con = length(roll_enc_padded)-length(roll_vid);
    con = ones(n_con,1);
    for i = 1:n_con
        con(i) = sum((roll_enc_padded(i:vid_n+(i-1))-roll_vid).^2);
    end
    
    % find the minimium of this convolution and convert to a time
    [~,i] = min(con);
    lag_ind = i-n;
    lag = lag_ind/1700;
end

