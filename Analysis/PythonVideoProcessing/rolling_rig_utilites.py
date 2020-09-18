import cv2
import numpy as np

from image_ultilites import crop_image


def overlay_rolling_rig(img,angles,centre,lengths,color=(0,0,0),width=5):
    roll, fold_left, fold_right = np.deg2rad(angles)
    len_main, len_fwt = lengths
    cx,cy = centre

    # calc some point
    # positive roll rotates anti-clockwise in the camera frame
    # positive fold folds a wingtip down (hence its different on both sides)

    left_inner_x = cx + np.cos(roll) * len_main
    left_inner_y = cy - np.sin(roll) * len_main
    left_outer_x = left_inner_x + np.cos(fold_left-roll) * len_fwt
    left_outer_y = left_inner_y + np.sin(fold_left-roll) * len_fwt

    right_inner_x = cx - np.cos(roll) * len_main
    right_inner_y = cy + np.sin(roll) * len_main
    right_outer_x = right_inner_x - np.cos(roll+fold_right) * len_fwt
    right_outer_y = right_inner_y + np.sin(roll+fold_right) * len_fwt

    coords=[]
    coords.append((right_outer_x,right_outer_y))
    coords.append((right_inner_x,right_inner_y))
    coords.append((cx,cy))
    coords.append((left_inner_x,left_inner_y))
    coords.append((left_outer_x,left_outer_y))

    return cv2.polylines(img, [np.rint(coords).astype('int32')],  False, color, width)

def get_wing_diff(img,bg,min_threshold=30):
    img = cv2.GaussianBlur(img,(3,3),0)
    img = cv2.subtract(img,bg)
    # img = np.abs(img[:,:,1]-img[:,:,2]).astype('uint8')
    img[:,:,0] = 0
    img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    ret,img = cv2.threshold(img,min_threshold,255,cv2.THRESH_BINARY)
    return img

def get_centre_point(video_capture,bg,centre,lengths,roi=None,min_threshold=30):
    video_capture.set(cv2.CAP_PROP_POS_FRAMES, 0)
    cx,cy = centre
    len_main, len_fwt = lengths
    fail = 0
    accumulator = None
    np.seterr(divide='ignore')
    while video_capture.isOpened():
        ret, img = video_capture.read()
        if ret:
            fail = 0
            img = get_wing_diff(crop_image(img,roi),bg,min_threshold = min_threshold)
            semi_width = int(len_main*0.75)
            img = crop_image(img,(int(cx-semi_width),int(cy-semi_width),
            int(semi_width*2),int(semi_width*2)))

            img = cv2.circle(img,(int(semi_width),int(semi_width)),
                                                int(len_main*0.2),(0,0,0),-1)
            points = cv2.findNonZero(img)

            [vx,vy,x,y] = cv2.fitLine(points, cv2.DIST_L2,0,0.01,0.01)
            lefty = int((-x*vy/vx) + y)
            righty = int(((semi_width*2-x)*vy/vx)+y)
            if accumulator is None:
                accumulator = np.zeros_like(img).astype('float')
            else:
                tmp = np.zeros_like(img).astype('float')
                tmp = cv2.line(tmp,(semi_width*2-1,righty),(0,lefty),(0.01),2)
                accumulator += tmp
        else:
            fail += 1
            if fail>10:
                break
    accumulator = (accumulator==np.max(accumulator))*255
    return np.mean(cv2.findNonZero(accumulator),0)[0]+np.array([cx-semi_width,cy-semi_width])

def get_wing_angles(frame,bg,centre,lengths,roi,threshold = 30):
    len_main, len_fwt = lengths
    cx,cy = centre

    # calculate the moments for the red pixels
    # aim is to find the quadrant the wing is in, in terms of roll
    img = cv2.GaussianBlur(frame,(3,3),0)
    img = cv2.subtract(crop_image(frame,roi),bg)
    r_img = cv2.subtract(img[:,:,2] , img[:,:,1])
    r_img = np.where(r_img<20,0,r_img)
    M = cv2.moments(r_img)
    r_cY = int(M["m01"] / M["m00"])
    r_cX = int(M['m10']/M['m00'])

    # get vector from wing centre to 'red centre'
    red_vector = np.array([r_cX-cx,r_cY-cy])
    red_vector /= np.sqrt(np.sum(red_vector**2))

    # calculate angles
    frame = get_wing_diff(crop_image(frame,roi),bg,min_threshold = threshold)

    # select region excluding wingtips and central support to find the roll angle of the inner wing
    roll_frame = frame.copy()
    semi_width = int(len_main*0.75)
    roll_frame = crop_image(roll_frame,(int(cx-semi_width),int(cy-semi_width),
    int(semi_width*2),int(semi_width*2)))

    roll_frame = cv2.circle(roll_frame,(int(semi_width),int(semi_width)),
                                        int(len_main*0.2),(0,0,0),-1)

    # fit a line to all the white pixels to find the roll angle
    points = cv2.findNonZero(roll_frame)
    [vx,vy,x,y] = cv2.fitLine(points, cv2.DIST_L2,0,0.01,0.01)
    roll = -np.arctan2(vy,vx)[0]

    # the fitted line doesnt know about direction so need to utilise the calculated roll angle
    # and the location of the red pixels (i.e the left side of the wing) to find which quadrent
    # the wing is in and hence how to alter roll angle
    if abs(red_vector[0])>abs(red_vector[1]):
        # x is bigger than y
        if red_vector[0]>0:
            roll += np.pi
        else:
            if roll < 0:
                roll += np.pi*2
            else:
                roll += 0
    else:
        # y is bigger than x
        if red_vector[1]<0:
            if roll < 0:
                roll += np.pi*2
            else:
                roll += np.pi    
        else:
            if roll < 0:
                roll += np.pi
            else:
                roll += 0

    # -------------------------- Calculate the fold angles -------------------------
    
    # create a frame centred about the wing
    fwt_frame = frame.copy()
    semi_span = len_fwt + len_main
    fwt_frame = fwt_frame[int(cy-semi_span):int(cy+semi_span),int(cx-semi_span):int(cx+semi_span)]
    fwt_frame = cv2.circle(fwt_frame,(int(semi_span),int(semi_span)),int(len_main),(0,0,0),-1)

    # rotate by the opposite of the roll angle
    M = cv2.getRotationMatrix2D((semi_span,semi_span),-np.rad2deg(roll),1)
    fwt_frame = cv2.warpAffine(fwt_frame,M,(semi_span*2,semi_span*2))

    # get the right tip roi
    right_frame = fwt_frame[int(semi_span-len_fwt):int(semi_span+len_fwt),-int(len_fwt*2):]
    points = cv2.findNonZero(right_frame)
    [vx,vy,x,y] = cv2.fitLine(points, cv2.DIST_L2,0,0.01,0.01)
    right_angle = -np.arctan(vy/vx)[0]

    # get the left tip roi
    left_frame = fwt_frame[int(semi_span-len_fwt):int(semi_span+len_fwt),:int(len_fwt*2)]
    points = cv2.findNonZero(left_frame)
    [vx,vy,x,y] = cv2.fitLine(points, cv2.DIST_L2,0,0.01,0.01)
    left_angle = np.arctan(vy/vx)[0]

    return tuple(np.rad2deg([roll,left_angle,right_angle]))