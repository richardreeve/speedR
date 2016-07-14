NoLoopsBoot <- function(x, R)
{
  
  avg <- mean(x$S)
  t(replicate(R,
              {
                index <- sample(seq_len(nrow(x)), replace=TRUE)
                
                tapply(x$S[index], x$site[index],  
                       function(y) mean.default(y) - avg)
              }))
}
