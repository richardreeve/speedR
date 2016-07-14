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

# Now preallocate the matrix
source("LessNaiveBoot.r")

Rprof(file="LessNaiveBoot.out", line.profiling=TRUE)
set.seed(123)
ResultsLNB <- LessNaiveBoot(BioData, subR)
Rprof(append=F)
LessNaiveBootAprof <- aprof("LessNaiveBoot.r", "LessNaiveBoot.out")

plot(LessNaiveBootAprof)

all.equal(as.numeric(ResultsNB),as.numeric(ResultsLNB))

head(targetedSummary(target=9, LessNaiveBootAprof),10)
head(targetedSummary(target=9, LessNaiveBootAprof, findParent = T),10)

## Now using mean.default()
source("FastBoot.r")

Rprof(file="FastBoot.out", line.profiling=TRUE)
set.seed(123)
ResultsFB <- FastBoot(BioData, subR)
Rprof(append=F)
FastBootAprof <- aprof("FastBoot.r", "FastBoot.out")

plot(FastBootAprof)
head(targetedSummary(target=9, FastBootAprof),10)

## Now no loops
source("NoLoopsBoot.r")

Rprof(file="NoLoopsBoot.out", line.profiling=TRUE)
set.seed(123)
ResultsNLB <- NoLoopsBoot(BioData, subR)
Rprof(append=F)
NoLoopsBootAprof <- aprof("NoLoopsBoot.r", "NoLoopsBoot.out")

plot(NoLoopsBootAprof)
head(targetedSummary(target=5, NoLoopsBootAprof),10)
