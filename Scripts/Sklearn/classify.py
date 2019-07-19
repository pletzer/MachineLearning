import numpy
from sklearn import svm, metrics
import argparse
import cv2
import glob
import pandas
import re

def loadImages(filenames):
	"""
	Load image files as grey data arrays
	@param filenames list of jpg file names
	@return array of grey pixel data (1=white, 0=black)
	"""
	# open first file to get the image size
	im = cv2.imread(filenames[0])
	n0, n1 = im.shape[:2]
	numImages = len(filenames)
	inputData = numpy.zeros((numImages, n0*n1), numpy.float32)
	for i in range(numImages):
		fn = filenames[i]
		# extract the index from the file name
		index = int(re.search(r'img(\d+).jpg', fn).group(1)) - 1
		im = cv2.imread(fn)
    # average the R, G, B channels and flatten array
		inputData[index,:] = (im.mean(axis=2)/255.).flat
	return inputData

def getImageSizes(filename):
	"""
	Get the number of x and y pixels
	@parameter filename file name
	@return nx, ny
	"""
	im = cv2.imread(filename)
	return im.shape[:2]


dataDir = '../../Data/Synthetic/Dots/'
trainingDir = dataDir + 'train/'

df = pandas.read_csv(trainingDir + 'train.csv')
categories = df['numberOfDots'].unique()
categories.sort()
minNumDots = min(categories)
maxNumDots = max(categories)
numCategories = maxNumDots - minNumDots + 1
# labels start at zero
trainingOutput = numpy.array(df['numberOfDots']) - minNumDots
trainingInput = loadImages(glob.glob(trainingDir + 'img*.jpg'))

testingDir = dataDir + 'test/'
df = pandas.read_csv(testingDir + 'test.csv')
numCategories = len(categories)
# labels start at zero
testingOutput = numpy.array(df['numberOfDots']) - minNumDots
testingInput = loadImages(glob.glob(testingDir + 'img*.jpg'))

# train the model
n0, n1 = getImageSizes(trainingDir + 'img1.jpg')
print('Number of training images: {}'.format(trainingInput.shape[0]))
print('Number of testing images : {}'.format(testingInput.shape[0]))
print('Image size               : {} x {}'.format(n0, n1))
print('Categories               : {} min/max = {}/{}'.format(categories, minNumDots, maxNumDots))

clf = svm.SVC(kernel='rbf', gamma='scale', verbose=True, random_state=567)

# now train
clf.fit(trainingInput, trainingOutput)

# test
prediction = clf.predict(testingInput)
numDots = prediction + 1

# compute varError
diffs = (numDots - testingOutput)**2
varError = diffs.sum()
numFailures = (diffs != 0).sum()

print('variance of error = {} number of failures = {}'.format(varError, numFailures))

print('known number of dots for the first 5 testing images: {}'.format(testingOutput[:5] + 1))
print('inferred number dots for the first 5 testing images: {}'.format(prediction[:5] + 1))

# plot training/test dataset
from matplotlib import pylab
n = 30
for i in range(n):
	pylab.subplot(n//10, 10, i + 1)
	pylab.imshow(testingInput[i,...].reshape(n0, n1))
	pylab.title('{} ({})'.format(testingOutput[i] + minNumDots, numDots[i]))
	pylab.axis('off')
pylab.show()








