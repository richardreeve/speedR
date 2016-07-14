FastBoot <- function(x,R)
{
  results <- array(dim=c(R,nlevels(x$site)))
  avg <- mean(x$S)
  for (i in 1:R)
  {
    index <- sample(seq_len(nrow(x)), replace=TRUE)
    
    results[i,] <- tapply(x$S[index], x$site[index],
                          function(y) mean.default(y) - avg)
  }
  return(results)
}
