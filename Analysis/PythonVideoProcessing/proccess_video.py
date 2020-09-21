"""
Doc string
"""
import os
import argparse
from progress.bar import ChargingBar

import cv2
import numpy as np
from scipy.io import savemat
from image_ultilites import crop_image,getMeanFrame,selectROIResized
from rolling_rig_utilites import get_centre_point,get_wing_angles,get_wing_diff,overlay_rolling_rig

def process_video_file(video_file,save_file = "",inner_span = 120 ,fwt_span = 44 ,roi = None , threshold = 35 , display_video=False, background_image = None):
    # if save_file blank make the name the same as the video with a .mat extension
    if not save_file:
        pre,_ = os.path.splitext(video_file)
        save_file = pre + ".mat"

    _,filename = os.path.split(video_file) 
    cap = cv2.VideoCapture(video_file)

    # Select ROI to perform analysis in
    if roi is None: 
        ret,frame = cap.read()
        ROI = selectROIResized('Select ROI',frame, height = 600, flip = True, inter=cv2.INTER_AREA)
    else:
        ROI = tuple(roi)

    # Create Background Image
    if background_image is None:
        print(filename + " - Generating Mean Image...")
        bg = getMeanFrame(cap,ROI,-5)
        bg = cv2.GaussianBlur(bg,(3,3),0)
    elif isinstance(background_image, str):
        bg = cv2.imread(background_image,cv2.IMREAD_COLOR)
        if bg is None:
            raise ValueError('background image path is incorrect')
    elif type(background_image).__module__ == np.__name__:
        bg = crop_image(background_image,ROI)


    # find first approximation for centre
    print(filename + " - Finding the Centre Point...")
    cap.set(cv2.CAP_PROP_POS_FRAMES, 0)
    ret,frame = cap.read()
    test = get_wing_diff(crop_image(frame,ROI),bg,threshold)
    points = cv2.findNonZero(test)
    centre = np.mean(points,0)[0]

    # Hone in on centre point
    cx,cy = get_centre_point(cap,bg,centre,(inner_span,fwt_span),ROI,min_threshold=threshold)
    print(filename + f" - Centre point found: ({cx:.2f},{cy:.2f})")

    # get video Metadata
    frame_count = cap.get(cv2.CAP_PROP_FRAME_COUNT)
    fps = cap.get(cv2.CAP_PROP_FPS)
    period = 1/fps

    # Get anglar data
    bar = ChargingBar(filename + ' - Processing Video',max = cap.get(cv2.CAP_PROP_FRAME_COUNT))
    data = []
    cap.set(cv2.CAP_PROP_POS_FRAMES, 0)
    for i in range(int(frame_count)):
        bar.next()
        ret, frame = cap.read()   
        if ret:
            angles = get_wing_angles(frame,bg,centre,(inner_span,fwt_span),ROI,threshold= threshold)
            data.append((i*period,*angles,*centre))
            if display_video:
                frame = crop_image(frame,ROI)
                frame_rotated = cv2.rotate(frame, cv2.ROTATE_180)
                frame_rotated = overlay_rolling_rig(frame_rotated,angles,(ROI[2]-cx,ROI[3]-cy),(inner_span,fwt_span),(0,0,255),5)
                cv2.imshow('frame', frame_rotated)
                key = cv2.waitKey(1) & 0xFF
                if key == ord("c"):
                    break
                if key == ord("w"):
                    cv2.waitKey()
        else:
            data.append((i*period,*([np.nan]*3),*centre))
    # Closes all the frames
    bar.finish()

    print(filename + " - Saving to file")
    data = np.array(data)
    names = ["t","roll","LeftFold","RightFold","centreX","centreY"]
    data_dict = {name:data[:,i] for i,name in enumerate(names)}
    savemat(save_file,data_dict)

    print(filename + " - Complete")
    cap.release()
    cv2.destroyAllWindows()

def str2bool(v):
    if isinstance(v, bool):
       return v
    if v.lower() in ('yes', 'true', 't', 'y', '1'):
        return True
    elif v.lower() in ('no', 'false', 'f', 'n', '0'):
        return False
    else:
        raise argparse.ArgumentTypeError('Boolean value expected.')

if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("-v", "--video", required = True, help = "Video To pass")
    ap.add_argument("-s", "--save_file", help = "path to save file - if blank will use videopath and change suffix to .mat", default="")
    ap.add_argument("-i", "--inner_span", type=int, default=112, help="Semi-span of the inner wing section")
    ap.add_argument("-f", "--fwt_span", type=int, default=40, help="Semi-span of the FWT")
    ap.add_argument("-r","--roi", nargs="+", type=int)
    ap.add_argument("-t","--threshold", type=int, default=30, help="Minimium threholds value for binarising")
    ap.add_argument("-d","--display_video", type=str2bool, default=False, help="Show video")
    args = vars(ap.parse_args())

    process_video_file(args['video'],args['save_file'],args['inner_span'],args['fwt_span'],args['roi'] , args['threshold'] , args['display_video'])
   
