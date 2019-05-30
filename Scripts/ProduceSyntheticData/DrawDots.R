# PURPOSE create a library of images

# Where store the images
StorageDIR = "../../Data/Synthetic/Dots"

# How many images per category
n.images = 500

# range of number of points
range.n = c(1,5)

for(n in seq(range.n[1], range.n[2])){

dir.create(paste(StorageDIR, "/", as.character(n), sep = ""), showWarnings = FALSE)

for(i in 1:n.images){
x <- runif(n, min = 0, max = 1)
y <- runif(n, min = 0, max = 1)

jpeg(filename =  paste(StorageDIR, "/", as.character(n), "/", "img", i, ".jpg", sep = ""), height = 40, width = 40)
par(mai = rep(0,4))
plot(x,y, cex = runif(n, min = 0.5, max = 2), xlim = c(0,1), ylim = c(0,1), axes = FALSE, xlab = "", ylab = "",
pch = 21, bg = "black", col = "white")
dev.off()
}
}
