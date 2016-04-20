library(unmarked)
library(FactoMineR)

data <- read.csv("Chagas Data Unmarked Site Trial.csv")

#a sparse matrix does not work well

#owner is site
#dog is sample
colnames(data)

y <- data$Results_Coded
data$Owner #Site
data$Dog #Sample
site_covs <- data[,c(1,3,4,14,15)]
sample_covs <- data[,c(6,9,11,12,13)]

J <- max(data[,3]) # number of repeated observations...in this case, number of pollen samples for each site, from within a +- time period
R <- length(unique(data$Owner)) # number of sites

owner <- unique(data$Owner)
  
mat <- matrix(data=NA, nrow=R, ncol=J)
for (i in 1:R){
  n <- sum(data$Owner==owner[i])
  mat[i,1:n] <- data$Results_Coded[data$Owner==owner[i]]
}

?unmarkedFramePCount
?pcount
#unmarkedDF <- unmarkedFramePCount()
#fit <- pcount(~ site_covs ~sample_covs,data = unmarkedDF), silent = T)