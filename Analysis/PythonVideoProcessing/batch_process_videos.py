import glob
from proccess_video import process_video_file
import ray


folder = "/Volumes/Seagate Expansi/PhD Files/Data/WT data/VideoData/20-Aug-2020/"

files = glob.glob(folder+'*.MP4', recursive=True)

@ray.remote
def process_file(name):
    try:
        process_video_file(name,roi=(700,360,540,530),threshold=35)
        return (True,name)
    except:
        return(False,name)


ray.init()

# process all files in the folder
#futures = [process_file.remote(i) for i in files]

# process a specific file
# futures = [process_file.remote("/Volumes/Seagate Expansi/PhD Files/Data/WT data/VideoData/20-Aug-2020/GX010173.MP4")]

# process a specific set of files
get_file_name = lambda x : folder + f"GX010{x:3d}.MP4"
futures = [process_file.remote(get_file_name(i)) for i in range(169,181)]



print(ray.get(futures))


#process_video_file(files[5],roi=(700,360,540,530),threshold=35,display_video=True)