library(unmarked)
library(FactoMineR)

#read in your data file
data <- read.csv("Chagas Data Unmarked Site Trial.csv")

colnames(data)

#need to indentify your covariates
which_site <- colnames(data)[c(1,3,4,14,15)] #these are the site covariates
which_sample <- colnames(data)[c(6,9,11,12,13)] #these are the sample covariates

#need to define J and R for the unmarked function
J <- max(data[,3]) # number of repeated observations
R <- length(unique(data$Owner)) # number of sites

owner <- unique(data$Owner) #owner is the site

#need to make a matrix of the response variable
#here it is the Restults_Coded column as an RXJ matrix
mat <- matrix(data=NA, nrow=R, ncol=J)
for (i in 1:R){
  n <- sum(data$Owner==owner[i])
  mat[i,1:n] <- data$Results_Coded[data$Owner==owner[i]]
}
rownames(mat) <- owner

#need to make a data.frame with only the site covariates
site_covs <- data[!duplicated(data$Owner),which_site]
rownames(site_covs) <- owner

#need to make a named list with the sample covariates, each covariate is a list element
sample_covs <- list()
for(j in 1:length(which_sample)) {
  sample_covs[[j]] <- data.frame(matrix(data=NA, nrow=R, ncol=J))
  for(k in 1:length(owner)){
    n <- sum(data$Owner==owner[k])
    sample_covs[[j]][k,1:n] <- data[data$Owner==owner[k],which_sample[j]]
  }
}
names(sample_covs) <- which_sample

#create an unmarked object for analysis
unmarkedDF <- unmarkedFramePCount(mat, siteCovs = site_covs, obsCovs = sample_covs)

#try different models
#you will get a warning if you don't set k as an argument in pcount, but that is OK and the model will mostly still converge
#if the model does not converge, you will get a warning, not an error, that means there is really not enough variation for the model to partition
fit <- list()
fit[[1]] <- pcount(~ 1 ~ 1, data = unmarkedDF)
fit[[2]] <- pcount(~ 1 ~ Site.Prevalence, data = unmarkedDF)
fit[[3]] <- pcount(~ 1 ~ X + Y, data = unmarkedDF)
fit[[4]] <- pcount(~ Sex_Dog ~ 1, data = unmarkedDF)
fit[[5]] <- pcount(~ Age_Grouped_Coded ~ 1, data = unmarkedDF)
fit[[6]] <- pcount(~ Size_Wt_Lbs_Coded ~ 1, data = unmarkedDF)
fit[[7]] <- pcount(~ Breed_Group ~ 1, data = unmarkedDF)

fms <- fitList("lam(1)p(1)" = fit[[1]],
               "lam(1)p(Site.Prevalence)" = fit[[2]],
               "lam(1)p(X + Y)" = fit[[3]],
               "lam(Sex_Dog)p(1)" = fit[[4]],
               "lam(Age_Grouped_Coded)p(1)" = fit[[5]],
               "lam(Size_Wt_Lbs_Coded)p(1)" = fit[[6]],
               "lam(Breed_Group)p(1)" = fit[[7]])

#rank models by AIC
ms <- modSel(fms)
coef(ms) #this returns the estimated coefficients for each model
ms #this returns the ranked list of models
#interpret this as, if the AIC is more than 2 units less than another model, then it is significantly better than the other model
