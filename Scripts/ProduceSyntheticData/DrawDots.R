# PURPOSE create a library of images
library("optparse")

parser <- OptionParser()
parser <- add_option(parser, c("-n", "--numberOfImages"), type="integer",
                     default=500, help="Number of images")
parser <- add_option(parser, c("-r", "--range"), type="integer",
                     default=5, help="Set max number of dots")
parser <- add_option(parser, c("-s", "--seed"), type="integer",
                     default=123, help="Set random seed")
options <- parse_args(parser)

set.seed(options$seed)


# Where store the images
StorageDIR = "../../Data/Synthetic/Dots"

# range of number of points
range.n = c(1, options$range)

for(n in seq(range.n[1], range.n[2])){

  dir.create(paste(StorageDIR, "/", as.character(n), sep = ""), showWarnings = FALSE)

  for(i in 1:options$numberOfImages){

    x <- runif(n, min = 0, max = 1)
    y <- runif(n, min = 0, max = 1)

    jpeg(filename =  paste(StorageDIR, "/", as.character(n), "/", "img", i, ".jpg", sep = ""), height = 40, width = 40)
    par(mai = rep(0,4))
    plot(x,y, cex = runif(n, min = 0.5, max = 2), xlim = c(0,1), ylim = c(0,1), axes = FALSE, xlab = "", ylab = "",
         pch = 21, bg = "black", col = "white")
    dev.off()
  }
}
