load('VideoMetaData.mat','VideoMetaData');
load('MetaData.mat','MetaData');

day = '30-Jul';

runData = MetaData(contains(string({MetaData.Folder}),day));
vidData = VideoMetaData(contains(string({VideoMetaData.Folder}),day));


%% put all runs together in a simple form
simpleRunData = struct([]);
for i = 1:length(runData)
    simpleRunData(i).GoProNumber = NaN;
    simpleRunData(i).RunNumber = runData(i).RunNumber;
    simpleRunData(i).DateStr = datestr(runData(i).Datetime);
    simpleRunData(i).Datetime = runData(i).Datetime;
end
runs = length(runData);
for i = 1:length(vidData)
    simpleRunData(runs+i).GoProNumber = vidData(i).GoProNumber;
    simpleRunData(runs+i).RunNumber = NaN;
    simpleRunData(runs+i).DateStr = datestr(vidData(i).Datetime);
    simpleRunData(runs+i).Datetime = vidData(i).Datetime;
end

%% sort by datetime

[~,I] = sort([simpleRunData.Datetime]);
sortedSimpleRunData = simpleRunData(I);



