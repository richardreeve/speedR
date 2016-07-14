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

## Now in parallel
detectCores()

## Set the number of workers we will use
ncores <- detectCores()
ncores <- detectCores() / 2
ncores <- detectCores() - 1
ncores <- detectCores() / 2 - 1
ncores <- 2

## Split the jobs
splitR <- table(cut(1:subR, ncores, labels=F))
print(splitR)

## save the start time
tp0 <- structure(.Internal(Sys.time()))

## initialize a list where we can store the id of each child
children<-vector("list", ncores)

## send the division of work in splitR to each of the cores
for (i in 1:ncores)
{
  children[[i]] <- mcparallel(cmpfast(BioData, splitR[i]))
}

## Wait for the child processes named in "children" to finish
results <- mccollect(children)

## Record end time
tp1 <- structure(.Internal(Sys.time()))

## Calculate execution time
tp <- tp1 - tp0
tp
## Speedup
ts / tp
## Efficiency
ts / (ncores * tp)


## save the start time
tmcl0 <- structure(.Internal(Sys.time()))

## send the division of work in splitR to each of the cores
results <- mclapply(splitR, function(y) cmpfast(BioData, y))

## Record end time
tmcl1 <- structure(.Internal(Sys.time()))

## Calculate execution time
tmcl <- tmcl1 - tmcl0
tmcl
ts / tmcl
ts / (ncores * tmcl)
