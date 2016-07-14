library(aprof)

source("interpreter.r")
Rprof(file="interpreter.out",
      interval=0.02,
      line.profiling=TRUE)

InterpreterQuirks(N=1e7) # run 10 million times

Rprof(append=FALSE) # stop profiling

summaryRprof("interpreter.out")

IntQuirksAprof <- aprof("interpreter.r","interpreter.out")

IntQuirksAprof
plot(IntQuirksAprof)
summary(IntQuirksAprof)
