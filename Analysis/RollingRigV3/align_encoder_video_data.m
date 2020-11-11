function [t,enc,angles] = align_encoder_video_data(t_vid,angles_vid,t_enc,roll_enc)
%ALIGN_ENCODER_VIDEO_DATA Summary of this function goes here
%   Detailed explanation goes here
% align data
lag = calc_encoder_video_delay(t_vid,angles_vid(:,1),t_enc,roll_enc);
%create overlap time vectors
t_lag_vid = t_enc-lag;                      % create equivelent video times for encoders time
t_lag_vid = t_lag_vid(t_lag_vid>=0);    % crop to actual video times
t_lag_vid = t_lag_vid(t_lag_vid<=t_vid(end));
t_lag_enc = t_lag_vid + lag;            % create encoder time

% interpolate both to get aligned time series
enc = interp1(t_enc,roll_enc,t_lag_enc);
angles = interp1(t_vid,angles_vid,t_lag_vid);

% ensure encoder and video start with 180 of each other
shift = round(mean(enc(1:20)-angles(1:20,1))/360)*360;
angles(:,1) = angles(:,1) +shift;

% create actual time vector
t = t_lag_enc - t_lag_enc(1);
end

