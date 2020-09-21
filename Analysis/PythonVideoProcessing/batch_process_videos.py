import glob
from proccess_video import process_video_file
import ray


folder = "/Volumes/Seagate Expansi/PhD Files/Data/WT data/VideoData/21-Aug-2020/"

files = glob.glob(folder+'*.MP4', recursive=True)

@ray.remote
def process_file(name):
    try:
        process_video_file(name,roi=(700,360,540,530),threshold=35)
        return (True,name)
    except:
        return(False,name)


ray.init()


futures = [process_file.remote(i) for i in files]
print(ray.get(futures))


#process_video_file(files[5],roi=(700,360,540,530),threshold=35,display_video=True)