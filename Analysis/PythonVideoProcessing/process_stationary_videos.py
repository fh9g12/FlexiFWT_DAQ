import glob
import cv2
import ray
from proccess_video import process_video_file
from image_ultilites import getMeanFrame



folder = "/Volumes/Seagate Expansi/PhD Files/Data/WT data/VideoData/21-Aug-2020/"

file_name = lambda number:f'GX010{number:3d}.MP4'
mean_file_name = lambda number:f'GX010{number:3d}_mean.png'

mean_vid = file_name(207)

# Create Background Image
# mean_num = 207
# file_range = range(200,221)

mean_num = 231
file_range = [232,233]

cap = cv2.VideoCapture(folder+mean_vid)
print(file_name(mean_num) + " - Generating Mean Image...")
bg = getMeanFrame(cap,None,-5)
bg = cv2.GaussianBlur(bg,(3,3),0)
cv2.imwrite(folder+mean_file_name(mean_num),bg)
cap.release()




@ray.remote
def process_file(number):
    try:
        process_video_file(folder+file_name(number),roi=(700,360,540,530),threshold=35,display_video=False,background_image=bg)
        return (True,number)
    except:
        return(False,number)

ray.init()
futures = [process_file.remote(i) for i in file_range]
print(ray.get(futures))
