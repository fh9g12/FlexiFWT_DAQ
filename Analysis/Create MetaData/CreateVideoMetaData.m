%%get a list of all .mat files within a directory

matFiles = struct([]);

localDir = dir('../../VideoData/**/*.mp4');

for i = 1:length(localDir)
    %clearvars -except localDir matFiles RunNumber i
    
    %% get filename and folder
    folders = strsplit(localDir(i).folder,'/');
    len = length(folders);
    j=1;
    while j<len
      if strcmp(folders(j),'VideoData')
          break
      else
          j=j+1;
      end
    end

    %remove first two paths C:\LocalData
    folders(1:j)=[];
    
    %% get GoPro video Number
    sv = regexp(localDir(i).name,'GX(\d*).MP4','tokens');
    matFiles(i).GoProNumber = str2num(sv{1}{1});

    %% make a space for Assciated Data
    matFiles(i).RunNumber = NaN;
    matFiles(i).Comment = '';

    % add to the MetaData 
    matFiles(i).Filename = localDir(i).name;
    matFiles(i).Folder = [strjoin(folders,'/'),'/'];
    matFiles(i).Datetime = datetime(localDir(i).date);
end

VideoMetaData = matFiles;


%% assign run numbers for 21st of august
runData = VideoMetaData(contains(string({VideoMetaData.Folder}),'21-Aug-2020'));
runs = [1989:2000,NaN,2001:2038]; % run numbers for videos on this day
[~,I] = sort([runData.Datetime]);

for i = 1:length(runData)
    ind = find([VideoMetaData.GoProNumber] == runData(I(i)).GoProNumber);
    VideoMetaData(ind(1)).RunNumber = runs(i);
    VideoMetaData(ind(1)).Comment = 'Rolling Rig v2';
end

%% assign runnumbers to for 20th August
runData = VideoMetaData(contains(string({VideoMetaData.Folder}),'20-Aug-2020'));
runs = [1721:1727,NaN,1728,1729,NaN,1730:1732,NaN,1805:1844]; % run numbers for videos on this day
[~,I] = sort([runData.Datetime]);

for i = 1:length(runData)
    ind = find([VideoMetaData.GoProNumber] == runData(I(i)).GoProNumber);
    VideoMetaData(ind(1)).RunNumber = runs(i);
    VideoMetaData(ind(1)).Comment = 'Rolling Rig v2';
end


%% assign runnumbers to for 24th July
runData = VideoMetaData(contains(string({VideoMetaData.Folder}),'24-July-2020'));
runs = [1081,1083,1085,1088,1090,1096,1097,1100,1103,1105,1107,1109]; % run numbers for videos on this day
[~,I] = sort([runData.Datetime]);

for i = 1:length(runData)
    ind = find([VideoMetaData.GoProNumber] == runData(I(i)).GoProNumber);
    VideoMetaData(ind(1)).RunNumber = runs(i);
    VideoMetaData(ind(1)).Comment = 'Flexi-wing, 30 degree flare';
end

%% assign runnumbers to for 27th July
runData = VideoMetaData(contains(string({VideoMetaData.Folder}),'27-July-2020'));
runs = [1111,1145,1146,1148,1153,1155,1162,1164,1167,1170,1173,1184,1185,1186,1189]; % run numbers for videos on this day
[~,I] = sort([runData.Datetime]);

for i = 1:length(runData)
    ind = find([VideoMetaData.GoProNumber] == runData(I(i)).GoProNumber);
    VideoMetaData(ind(1)).RunNumber = runs(i);
    VideoMetaData(ind(1)).Comment = 'Flexi-wing, 30 degree flare';
end

%% assign runnumbers to for 28th July
runData = VideoMetaData(contains(string({VideoMetaData.Folder}),'28-July-2020'));
runs = [1192,1193,1196,1204,1225]; % run numbers for videos on this day
[~,I] = sort([runData.Datetime]);

for i = 1:length(runData)
    ind = find([VideoMetaData.GoProNumber] == runData(I(i)).GoProNumber);
    VideoMetaData(ind(1)).RunNumber = runs(i);
    VideoMetaData(ind(1)).Comment = 'Flexi-wing, 30 degree flare';
end

%% assign runnumbers to for 30th July
runData = VideoMetaData(contains(string({VideoMetaData.Folder}),'30-July-2020'));
runs = [zeros(1,13)*NaN,1358,1367,1370,1371,1373,1375,1379,...
    1381,1383,1386,1388,1390,1392,1394,1396]; % run numbers for videos on this day
[~,I] = sort([runData.Datetime]);

for i = 1:length(runData)
    ind = find([VideoMetaData.GoProNumber] == runData(I(i)).GoProNumber);
    VideoMetaData(ind(1)).RunNumber = runs(i);
    VideoMetaData(ind(1)).Comment = 'Rolling Rig v1';
end


%% add comments to NaN Runs (videos without run data)
VideoMetaData = UpdateComment(VideoMetaData,10129,'Vertical LCO at 20 m/s');
VideoMetaData = UpdateComment(VideoMetaData,10132,'Vertical LCO at 15 m/s');
VideoMetaData = UpdateComment(VideoMetaData,10137,'Vertical LCO at 10 m/s');
VideoMetaData = UpdateComment(VideoMetaData,10198,'Swinging Side to Side on Joystick (unsure of speed...)');

for i = 10016:10017
    VideoMetaData = UpdateComment(VideoMetaData,i,'10 degree flare examples');
end

for i = 10018:10022
    VideoMetaData = UpdateComment(VideoMetaData,i,'30 degree flare examples');
end

VideoMetaData = UpdateComment(VideoMetaData,10060,'Test Video Angles for Rolling Rig V1');
VideoMetaData = UpdateComment(VideoMetaData,10062,'Test Video Angles for Rolling Rig V1');

runs = 10077:10090;
runs(runs==10088)=[];
for i = runs
    if mod(i,2)
        state = 'upright ';
    else
        state = 'inverted ';
    end
    state = [state,num2str(floor((i-10077)/2)*5+10),' m/s'];
    VideoMetaData = UpdateComment(VideoMetaData,i,state);
end




save('VideoMetaData.mat','VideoMetaData')



function VideoMetaData = UpdateComment(VideoMetaData,Number,Comment)
    I = find([VideoMetaData.GoProNumber]==Number);
    VideoMetaData(I).Comment = Comment;
end
