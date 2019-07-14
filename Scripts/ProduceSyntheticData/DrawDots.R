# PURPOSE create a library of images
library("optparse")

parser <- OptionParser()
parser <- add_option(parser, c("-n", "--numberOfImages"), type="integer",
                     default=500, help="Number of images")
parser <- add_option(parser, c("-r", "--minRange"), type="integer",
                     default=1, help="Set min number of dots")
parser <- add_option(parser, c("-R", "--maxRange"), type="integer",
                     default=5, help="Set max number of dots")
parser <- add_option(parser, c("-r", "--range"), type="integer",
                     default=5, help="Set max number of dots")
parser <- add_option(parser, c("-s", "--seed"), type="integer",
                     default=123, help="Set random seed")
parser <- add_option(parser, c("-d", "--directory"),
                     default="../../Data/Synthetic/Dots", help="Set output directory")
parser <- add_option(parser, c("-c", "--csvFile"),
                     default="training.csv", help="Set CSV file name containing number of dots for each image")
options <- parse_args(parser)

set.seed(options$seed)


# Where store the images
StorageDIR <- options$directory

df <- data.frame("imageId"=rep(0, options$numberOfImages), "numberOfDots"=options$numberOfImages)

# use directory name to label images
for(n in options$minRange:options$maxRange) {
    dirName <- paste(StorageDIR, "/", as.character(n), sep='')
    print( paste('Creating ', dirName) )
    dir.create(dirName, showWarnings=FALSE)
}

for(i in 1:options$numberOfImages) {

    # random number of dots, note as.integer rounds to the lowest integer so add 1
    numDots <- as.integer(runif(1, min=options$minRange, max=options$maxRange + 1))

    # random position
    x <- runif(numDots, min = 0, max = 1)
    y <- runif(numDots, min = 0, max = 1)

    # random dot size
    extent <- runif(numDots, min = 0.5, max = 2)

    df[i,"imageId"] = i
    df[i, "numberOfDots"] = numDots

    jpeg(filename=paste(StorageDIR, "/", as.character(numDots), "/", "img", i, ".jpg", sep = ""), height = 40, width = 40)
    par(mai = rep(0,4))
    plot(x, y, cex=extent, xlim = c(0,1), ylim = c(0,1), axes = FALSE, xlab = "", ylab = "",
         pch = 21, bg = "black", col = "white")
    dev.off()

}

write.csv(df, file=paste(StorageDIR, "/", options$csvFile, sep=""))