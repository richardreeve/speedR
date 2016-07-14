NaiveBoot <- function(x, R)
{
  results <- NULL

  for (i in 1:R)
  {
    index <- sample(seq_len(nrow(x)), replace=TRUE)
    results <- rbind(results,
                     tapply(x$S[index], x$site[index],
                            function(y) mean(y) - mean(x$S)))
  }
  return(results)
}
