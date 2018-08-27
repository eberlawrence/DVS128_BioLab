

import socket
import struct
import numpy as np
import time
import matplotlib
#matplotlib.use('gdk')
from time import sleep
from matplotlib import pyplot as plt
import itertools

filename = 'DVS128.aedat'
file_read = open(filename, "rb")
xdim = 128  
ydim = 128

def matrix_active(x, y, pol):
    matrix = np.zeros([ydim, xdim])
    if(len(x) == len(y)):
        for i in range(len(x)):
            matrix[y[i], x[i]] = matrix[y[i], x[i]] +  pol[i] - 0.5  # matrix[x[i],y[i]] + pol[i]
    else:
        print("error x,y missmatch")
    return matrix

