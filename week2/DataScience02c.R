# DataScience02c
WasteTime <- function()
{
  par(mar=c(0,0,0,0))
  pchValue <- c(19, 20, 21)
  for(i in seq(1,500, 25))
  {
    #cols<- rainbow(i, sqrt(1:i/i))
    cols<- rainbow(i, sqrt(1:i/i))
    cols.bg<- rainbow(i, 1:i/i)
    Z<-complex(mod=sqrt(1:i), arg=1:i + i/20)
    plot(Z, col=cols, bg=cols.bg, pch=pchValue, cex=sqrt(i:1), asp=1)
    sleepMe(0.2)
  }
}

sleepMe <- function(x=1)
{
  p1 <- proc.time()
  Sys.sleep(x)
  bogus <- proc.time() - p1
  # The cpu usage should be negligible
}