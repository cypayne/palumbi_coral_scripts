#!/usr/bin/env python 

''' matplotlib values: https://matplotlib.org/api/_as_gen/matplotlib.pyplot.plot.html
    
    note: pandas - [1:n] is n inclusive
          numpy  - [1:n] is n exclusive
'''

import sys
import numpy as np
import matplotlib.pyplot as plt

datafile = sys.argv[1]
x_vals = 0 # column number for x values
y_vals = 1 # column number for y values

# import data, assign x and y values to x,y arrays
with open(datafile) as f:
  lines = f.readlines()
  x = [line.split()[x_vals] for line in lines]
  y = [line.split()[y_vals] for line in lines]

#data = np.loadtxt(datafile)

#plt.plot(x,y)
plt.hist(x,y)

# plot characteristics
plt.xlabel('x')
plt.ylabel('y')
plt.title('Plot')
# plt.legend()
 
plt.show()

