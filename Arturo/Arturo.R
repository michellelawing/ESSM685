### Goal is to get a working calculation of Euclidean distances for each time series for next class

#load files
load("February_ED.RData")
load("March_EC.RData")

##MARCH TO FEBRUARY##
##Construct matrix from csv files marchMatx = as.matrix(March_EC)
colnames(March_EC) <- c("X", "Y", "Z", "R", "G", "B", "SCLR")
print(colnames(March_EC))
head (March_EC)
colnames(February_EC) <- c("X", "Y", "Z", "R", "G", "B", "SCLR")
print(colnames(February_EC))
head(February_EC)

#here are some different ways to visualize your data
library(scatterplot3d)
scatterplot3d(February_EC[,1:3])

library(rgl)
plot3d(February_EC[,1:3])

library(Rcmdr)
scatter3d(February_EC[,1],February_EC[,2],February_EC[,3])

library(plot3D) #another cool package

################
library(akima)
library(rgl)

Feb_surface <- interp(February_EC[,1],February_EC[,2],February_EC[,3])
surface3d(Feb_surface$x,Feb_surface$y,Feb_surface$z)

Mar_surface <- interp(March_EC[,1],March_EC[,2],March_EC[,3])
surface3d(Mar_surface$x,Mar_surface$y,Mar_surface$z)

#dist_F <- dist(February_EC[,1:3])
#don't use the dist function, also takes too long

# dist_MF <- matrix(NA, nrow = length(February_EC[,"X"]), ncol = length(March_EC[,"X"])) ##Must use matrix with larger row count or matrix wont be large enough to store the larger dataset
# for (i in 1:length(February_EC[,"X"]))
# {
# print ("inside loop 1")
# print(paste(c("i ", i, " & Feb Length ", length(February_EC[,"X"]))))
# for (j in 1:length(February_EC[,"X"])) ##might need to use get.knnx(marchMatx,)
# {
# print ("inside loop 2")
# print(paste(c("j ", j, " & March Length ", length(March_EC[,"X"]))))
# print ("beginning matrix build")
# dist_MF[i,j] <- sqrt(((February_EC[i,"X"] - March_EC[j,"X"])^2) + ((February_EC[i,"Y"] - March_EC[j,"Y"])^2) + ((February_EC[i,"Z"] - March_EC[j,"Z"])^2))
# }
# }
# head(dist_MF)
# tail(dist_MF)