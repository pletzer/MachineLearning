import sys
import re
import numpy

resFile = sys.argv[1]

data = numpy.loadtxt(resFile)
bestRow = numpy.argmax(data[:, 1])
print(int(data[bestRow, 0]))