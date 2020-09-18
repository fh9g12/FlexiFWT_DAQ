vidFileReader = VideoReader('/Volumes/Seagate Expansi/PhD Files/Data/WT data/VideoData/20-Aug-2020/GX010124.MP4');

depVideoPlayer = vision.DeployableVideoPlayer;

ROI = [700,620,500,400];
%centre = [236,186]; %position of centre of rotation in ROI
centre = [243,196]; %position of centre of rotation in ROI
centre = [252,160]; %position of centre of rotation in ROI
lengths = [112,45]; %length of main wing semi span and FWT length in pixels

disp('calulating mean frame')
MeanFrame = GetMeanFrame(vidFileReader,ROI,vidFileReader.Duration-5,vidFileReader.Duration);
grayMeanFrame = rgb2gray(MeanFrame);



disp('calulating initial angles')
%% get initial Angles
firstFrame = GetFrameAt(vidFileReader,0,ROI);

% get the greyscale image
Diff = firstFrame-grayMeanFrame;
Diff(:,:,3) = 0;
grayDiff = rgb2gray(Diff);
thresholdIm = uint8((grayDiff>40)*255);
%calc angles
angles = FitFWT(thresholdIm,centre,lengths,7,[0,0,0],[90,90,90]);
imshow(imOverlayFwt(firstFrame,angles,centre,lengths,'red',3),'InitialMagnification',300)


disp('calulating all angles')
%% analysis the video
res = zeros(vidFileReader.NumFrames,3);
res(1,:) = angles;
frame_count = 1;
f = waitbar(0,'Calculating Video');
while hasFrame(vidFileReader)
    frame_count = frame_count +1;
    frame = readFrame(vidFileReader);
    frame = imcrop(frame,ROI);
    grayDiff = rgb2gray(frame-MeanFrame);
    thresholdIm = uint8((grayDiff>40)*255);
    res(frame_count,:) = FitFWT(thresholdIm,centre,lengths,7,res(frame_count-1,:),[10,10,10]);
    if mod(frame_count,10)==0
        f = waitbar(frame_count/vidFileReader.NumFrames,f,'Calculating Video');
    end
end
disp('complete')


vidFileReader.CurrentTime = 0;
frame_count = 0;
while hasFrame(vidFileReader)
    frame_count = frame_count+1;
    rawRgbFrame = rgb2gray(readFrame(vidFileReader));
    rawRgbFrame = imcrop(rawRgbFrame,[689.5 524.5 498 370]);
    
    depVideoPlayer(imOverlayFwt(rawRgbFrame,res(frame_count,:),centre,lengths,'red',3))
    roll_temp = res(frame_count,1);
    pause(1/vidFileReader.FrameRate)
end
figure(3)
plot(mod(res(:,1),360),res(:,2),'r.')
hold on
plot(mod(res(:,1),360),res(:,3),'g.')
plot(mod(res(:,1)-180,360),res(:,3),'b.')



