function [frame] = GetFrameAt(VideoFileReader,Time,ROI)
%GETFRAMEAT Summary of this function goes here
%   Detailed explanation goes here
if class(VideoFileReader) ~= 'VideoReader'
    error('Video reader object of the wrong class')
end
if Time >= VideoFileReader.Duration
    error('Time must be less than the duration of the video')
end
VideoFileReader.CurrentTime = Time;
frame = readFrame(VideoFileReader);
frame = imcrop(frame,ROI);
end

