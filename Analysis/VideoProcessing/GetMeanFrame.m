function [meanFrame] = GetMeanFrame(videoFileReader,ROI,StartTime,EndTime)
%GETMEANFRAME Summary of this function goes here
%   Detailed explanation goes here

if class(videoFileReader) ~= 'VideoReader'
    error('Video reader object of the wrong class')
end
if EndTime > videoFileReader.Duration
    EndTime = videoFileReader.Duration;
end
if StartTime > videoFileReader.Duration
    error('Start TIme Must be less than the duration of the video')
end

videoFileReader.CurrentTime = StartTime;
frameCount = 0;
while videoFileReader.CurrentTime<EndTime
    tempFrame = readFrame(videoFileReader);
    tempFrame = double(imcrop(tempFrame,ROI));
    if frameCount == 0
        meanFrame = tempFrame;
    else
        meanFrame = meanFrame + tempFrame;
    end
    frameCount = frameCount + 1;
end
meanFrame = uint8(meanFrame ./ frameCount);

end

