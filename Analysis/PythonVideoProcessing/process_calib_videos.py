import glob
import cv2
import ray
from numpy import rad2deg
from proccess_video import process_video_file
from image_ultilites import getMeanFrame,crop_image
from rolling_rig_utilites import get_wing_diff,get_wing_angles
from scipy.io import savemat


folder = "/Volumes/Seagate Expansi/PhD Files/Data/WT data/VideoData/21-Aug-2020/"

file_name = lambda number:f'GX010{number:3d}.MP4'
mat_file_name = lambda number:f'GX010{number:3d}.mat'

mean_vid = file_name(207)

# Create Background Image
# mean_num = 207
# file_range = range(200,221)

mean_num = 231
file_range = [234,235,236]

center = (700+270,360+337)
width = 100
gen_roi = lambda center,width:(center[0]-width,center[1]-width,width*2,width*2)


def get_mean(filename,roi):
    cap = cv2.VideoCapture(filename)
    print(filename + " - Generating Mean Image...")
    bg = getMeanFrame(cap,roi,-5)
    bg = cv2.GaussianBlur(bg,(3,3),0)
    cap.release()
    return bg

bg = get_mean(folder+file_name(mean_num),gen_roi(center,width))

#diff = [get_wing_diff(get_mean(folder+file_name(i),gen_roi(center,width)),bg,60) for i in file_range]
#diff = [crop_image(frame,gen_roi((width,width),width)) for frame in diff]

# calculate the roll angles
diff = [get_wing_angles(get_mean(folder+file_name(i),gen_roi(center,width)),bg,(width,width),(80,20),None,threshold = 60,pie_angle = 45) for i in file_range]

data = [[0,vals[0],0,0,270,337] for vals in diff] 
names = ["t","roll","LeftFold","RightFold","centreX","centreY"]

for i,_data in enumerate(data):
    savemat(folder+mat_file_name(file_range[i]),dict(zip(names,_data)))