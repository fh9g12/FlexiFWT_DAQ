vidFileReader = VideoReader('GX010083.MP4');
depVideoPlayer = vision.DeployableVideoPlayer;
redThresh = 0.1; % Threshold for red detection
num_frames = vidFileReader.NumFrames;
time_to_remember = vidFileReader.CurrentTime;
%frame = 1;
%while hasFrame(vidFileReader)
%    tempFrame = readFrame(vidFileReader);
%    tempFrame = double(imcrop(tempFrame,[689.5 524.5 498 370]));
%    if frame == 1
%        meanFrame = tempFrame;
%        frame = 0;
%    else
%        meanFrame = meanFrame + tempFrame;
%    end
%end
%meanFrame = uint8(meanFrame ./ num_frames);

%imshow(meanFrame)
vidFileReader.CurrentTime = time_to_remember;
while hasFrame(vidFileReader)
    rawRgbFrame = readFrame(vidFileReader);
    rawRgbFrame = imcrop(rawRgbFrame,[689.5 524.5 498 370]);
    rgbFrame = rawRgbFrame - meanFrame;
    grayFrame = rgb2gray(rgbFrame);
    grayFrame = medfilt2(grayFrame, [3 3]); % Filter out the noise by using median filter
    grayBinFrame = imbinarize(grayFrame, 0.1); % Convert the image into binary image with the red objects as white
    edgeFrame = edge(grayFrame,'Prewitt');
    
    diffFrame = imsubtract(rgbFrame(:,:,1),rgb2gray(rgbFrame));
    diffFrame = medfilt2(diffFrame, [3 3]); % Filter out the noise by using median filter
    binFrame = imbinarize(diffFrame, redThresh); % Convert the image into binary image with the red objects as white
    depVideoPlayer(rgbFrame)
    pause(1/vidFileReader.FrameRate)
end
