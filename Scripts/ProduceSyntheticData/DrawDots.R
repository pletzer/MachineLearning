# PURPOSE create a library of images
library("optparse")

parser <- OptionParser(add_help_option=TRUE)
parser <- add_option(parser, c("-n", "--numberOfImages"), type="integer",
                     default=500, help="Number of images")
parser <- add_option(parser, c("-r", "--minRange"), type="integer",
                     default=1, help="Set min number of dots")
parser <- add_option(parser, c("-R", "--maxRange"), type="integer",
                     default=5, help="Set max number of dots")
parser <- add_option(parser, c("-s", "--seed"), type="integer",
                     default=123, help="Set random seed")
parser <- add_option(parser, c("-o", "--outputDir"),
                     default="../../Data/Synthetic/Dots/train", help="Set output directory")
parser <- add_option(parser, c("-c", "--csvFile"),
                     default="train.csv", help="Set CSV file name containing number of dots for each image")

options <- parse_args(parser)

set.seed(options$seed)

# Where to store the images
outputDir <- paste(options$outputDir, "/", sep='')
dir.create(outputDir, showWarnings=FALSE)

df <- data.frame("imageId"=rep(0, options$numberOfImages), "numberOfDots"=options$numberOfImages)

for(i in 1:options$numberOfImages) {

    # random number of dots, note as.integer rounds to the lowest integer so add 1
    numDots <- as.integer(runif(1, min=options$minRange, max=options$maxRange + 1))

    # random position on a grid

    grid = expand.grid(x = seq(0.1, 0.9, 0.2), y = seq(0.1, 0.9, 0.2))

    my.sample = sample(1:nrow(grid), size = numDots)

    x <- grid$x[my.sample]
    y <- grid$y[my.sample]

    # random dot size (option removed)
    # extent <- runif(numDots, min = 0.5, max = 2)
    extent = 1
    
    df[i,"imageId"] = i
    df[i, "numberOfDots"] = numDots

    jpeg(filename=paste(outputDir, "img", i, ".jpg", sep = ""), height = 100, width = 100, quality = 100, res = 300)
    par(mai = rep(0,4))
    plot(x, y, cex=extent, xlim = c(0,1), ylim = c(0,1), axes = FALSE, xlab = "", ylab = "",
         pch = 21, bg = rgb(0, 0, 0, 0.5), col = "white")
    dev.off()

}

write.csv(df, file=paste(outputDir, options$csvFile, sep=""))
