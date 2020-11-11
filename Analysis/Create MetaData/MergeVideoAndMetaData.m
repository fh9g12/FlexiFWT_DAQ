load('VideoMetaData.mat')
load('MetaData.mat')

for i = 1:length(VideoMetaData)
    rn = VideoMetaData(i).RunNumber;
    if ~isnan(rn)
        meta_i = find([MetaData.RunNumber]==rn,1);
        MetaData(meta_i).GoProNumber = VideoMetaData(i).GoProNumber;
        MetaData(meta_i).VideoComment = VideoMetaData(i).Comment;
        MetaData(meta_i).VideoFilename = VideoMetaData(i).Filename;
        MetaData(meta_i).VideoFolder = VideoMetaData(i).Folder;
        MetaData(meta_i).VideoDatetime = VideoMetaData(i).Datetime;
    end
end
save('MetaData'