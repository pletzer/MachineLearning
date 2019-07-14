# PURPOSE create a library of images
library("optparse")

parser <- OptionParser()
parser <- add_option(parser, c("-n", "--numberOfImages"), type="integer",
                     default=500, help="Number of images")
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

# range of number of dots
range.n = c(1, options$range)

df <- data.frame("imageId"=rep(0, options$numberOfImages), "numberOfDots"=options$numberOfImages)

for(i in 1:options$numberOfImages) {

    numDots <- as.integer(runif(1, min=range.n[1], max=range.n[2] + 1))
    x <- runif(numDots, min = 0, max = 1)
    y <- runif(numDots, min = 0, max = 1)
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