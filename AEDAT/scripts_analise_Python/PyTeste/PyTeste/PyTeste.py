# -*- encoding: utf-8 -*-
import struct
import os
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.image as im
import pandas as pd
from scipy import ndimage
import sys
import cv2

V2 = "aedat"  # current 32bit file format

def loadaerdat(datafile='/tmp/aerout.dat', length=0, version=V2, debug=1, camera='DVS128'):
    """    
    load AER data file and parse these properties of AE events:
    - timestamps (in us), 
    - x,y-position [0..127]
    - polarity (0/1)

    @param datafile - path to the file to read
    @param length - how many bytes(B) should be read; default 0=whole file
    @param version - which file format version is used: "aedat" = v2, "dat" = v1 (old)
    @param debug - 0 = silent, 1 (default) = print summary, >=2 = print all debug
    @param camera='DVS128' or 'DAVIS240'
    @return (ts, xpos, ypos, pol) 4-tuple of lists containing data of all events;
    """
    # constants
    aeLen = 8  # 1 AE event takes 8 bytes
    readMode = '>II'  # struct.unpack(), 2x ulong, 4B+4B
    td = 0.000001  # timestep is 1us   
    if(camera == 'DVS128'):
        xmask = 0x00fe  # Bin -> 0000 0000 1111 1110  ||  Dec -> 254
        xshift = 1
        ymask = 0x7f00  # Bin -> 0111 1111 0000 0000  ||  Dec -> 32512
        yshift = 8
        pmask = 0x1     # Bin -> 0000 0000 0000 0001  ||  Dec -> 1
        pshift = 0
    else:
        raise ValueError("Unsupported camera: %s" % (camera))

    aerdatafh = open(datafile, 'rb')
    k = 0  # line number
    p = 0  # pointer, position on bytes
    statinfo = os.stat(datafile)
    if length == 0:
        length = statinfo.st_size    
    print ("file size", length)
    
    if sys.version[0] == '3':
        value = 35
    else:
        value = '#'

    # header
    lt = aerdatafh.readline()
    while lt and lt[0] == value:
        p += len(lt)
        k += 1
        lt = aerdatafh.readline() 
        if debug >= 2:
            print (str(lt))
        continue
    
    # variables to parse
    timestamps = []
    xaddr = []
    yaddr = []
    pol = []
    
    # read data-part of file
    aerdatafh.seek(p)
    s = aerdatafh.read(aeLen)
    p += aeLen
    
    print (xmask, xshift, ymask, yshift, pmask, pshift)    
    while p < length:
        addr, ts = struct.unpack(readMode, s)
        # parse event type
        if(camera == 'DVS128'):            
            x_addr = (addr & xmask) >> xshift # Endereço x -> bits de 1-7 
            y_addr = (addr & ymask) >> yshift # Endereço y -> bits de 8-14
            a_pol = (addr & pmask) >> pshift  # Endereço polaridade -> bit 0
            
            if debug >= 3: 
                print("ts->", ts) 
                print("x-> ", x_addr)
                print("y-> ", y_addr)
                print("pol->", a_pol)

            timestamps.append(ts)
            xaddr.append(x_addr)
            yaddr.append(y_addr)
            pol.append(a_pol)
                  
        aerdatafh.seek(p)
        s = aerdatafh.read(aeLen)
        p += aeLen        

    if debug > 0:
        try:
            print ("read %i (~ %.2fM) AE events, duration= %.2fs" % (len(timestamps), len(timestamps) / float(10 ** 6), (timestamps[-1] - timestamps[0]) * td))
            n = 5
            print ("showing first %i:" % (n))
            print ("timestamps: %s \nX-addr: %s\nY-addr: %s\npolarity: %s" % (timestamps[0:n], xaddr[0:n], yaddr[0:n], pol[0:n]))
        except:
            print ("failed to print statistics")

    return np.array(timestamps), np.array(xaddr), np.array(yaddr), np.array(pol)

T, X, Y, P = loadaerdat('C:\\Users\\BioLab\\Desktop\\PyTeste\\PyTeste\\video_chave_fenda.aedat')


def matrix_active(x, y, pol):
    matrix = np.zeros([128, 128])+0.5
    if(len(x) == len(y)):
        for i in range(len(x)):
            matrix[y[i], x[i]] = matrix[y[i], x[i]] +  pol[i] - 0.5 # matrix[x[i],y[i]] + pol[i]
    else:
        print("error x,y missmatch")
    return matrix

m = matrix_active(X[5000:10000], Y[5000:10000], P[5000:10000])





#fps = 60
#time = (T[-1]-T[0])/1000000
#frames = fps*time
#events = int(len(T)/frames)
#i, f = 0, events
#frame = 0
#while frame < frames:
#    m = matrix_active(X[i:f], Y[i:f], P[i:f])
#    m = ndimage.rotate(m,180)
#    im.imsave('C:\\Users\\BioLab\\Desktop\\PyTeste\\PyTeste\\imagens\\img'+str(frame)+'.png', m,cmap='gray')
#    i += events
#    f += events
#    frame += 1




#image_folder = 'C:\\Users\\BioLab\\Desktop\\PyTeste\\PyTeste\\imagens'
#video_name = 'C:\\Users\\BioLab\\Desktop\\PyTeste\\PyTeste\\imagens\\video.avi'
#images = [img for img in os.listdir(image_folder) if img.endswith(".png")]
#frame = cv2.imread(os.path.join(image_folder, images[0]))
#height, width, layers = frame.shape
#video = cv2.VideoWriter(video_name, -1, 34, (width,height))
#for image in images:
#    video.write(cv2.imread(os.path.join(image_folder, image)))
#cv2.destroyAllWindows()
#video.release()























#m = matrix_active(X[5000:10000], Y[5000:10000], P[5000:10000])
#plt.imshow(m,cmap='gray')
#plt.show()




#import cv2
#img = cv2.imread('img.jpg')
#img_gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
#cv2.namedWindow('opa',cv2.WINDOW_NORMAL)
#cv2.imshow('opa',img)
#cv2.imshow('opa1',img_gray)
#cv2.waitKey(5000)
#cv2.destroyAllWindows()