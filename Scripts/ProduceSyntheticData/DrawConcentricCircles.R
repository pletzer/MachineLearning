library(plotrix)

dR = function(R, Q=1) {
   Q/(4 * pi * R^2)
}

# PURPOSE create a library of images

# Where store the images
StorageDIR = "/tmp"

# How many images per category
n.images = 5

# range of number of circles
range.n = c(2,10)

for(n.rayons in seq(range.n[1], range.n[2])){

dir.create(paste(StorageDIR, "/", as.character(n.rayons), sep = ""), showWarnings = FALSE)

rayons = c(1, rep(NA,n.rayons-1))

for(i in 2:length(rayons)){

rayons[i] = rayons[i-1] + dR(rayons[i-1])
}

for(i in 1:n.images){

jpeg(filename =  paste(StorageDIR, "/", as.character(n.rayons), "/", "img", i, ".jpg", sep = ""))
plot(1,1, type = "n", xlim = c(0,2), ylim = c(0,2), axes = FALSE, xlab = "", ylab = "")
draw.circle(runif(1, -0.5, 0), runif(1, -0.5, 0), rayons)
dev.off()
}
}



