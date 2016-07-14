library(aprof)
library(boot)
library(compiler)

N <- 750 #Number of records per site

S <- 100 # Number of sites
BioData <- data.frame(S=rpois(N*S,15),
                      site=as.factor(rep(1:S,N)))

SiteMeans <- function(x, d)
{
  tapply(x$S[d], x$site[d], mean) - mean(x$S)
}

# Number of repeats
subR <- 2000

BtResults <- boot(BioData, SiteMeans, subR)

source("NaiveBoot.r")
Rprof(file="NaiveBoot.out", line.profiling=TRUE)
set.seed(123)
ResultsNB <- NaiveBoot(BioData, subR)
Rprof(append=F)
NaiveBootAprof <- aprof("NaiveBoot.r", "NaiveBoot.out")

plot(NaiveBootAprof)
head(targetedSummary(target=8, NaiveBootAprof),10)

