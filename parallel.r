library(aprof)
library(boot)

RNGkind("L'Ecuyer-CMRG")
library(parallel)

N <- 750 # Number of records per site

S <- 100 # Number of sites
BioData <- data.frame(S=rpois(N*S,15),
                      site=as.factor(rep(1:S,N)))

# Number of repeats
subR <- 2000

source("FastBoot.r")
cmpfast <- compiler::cmpfun(FastBoot)

## save the start time and end time
ts0 <- structure(.Internal(Sys.time()))
ResultsFB <- cmpfast(BioData, subR)
ts1 <- structure(.Internal(Sys.time()))
## Calculate execution time
ts <- ts1 - ts0
ts
