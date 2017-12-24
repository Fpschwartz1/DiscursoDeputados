
dnormalComp <- function(media1=0, dp1=1, media2=3, dp2=1, nc=.95, rc="=")
{

  ########################
  # Script principal
  ########################
  
  # eixo x da curva normal
  lim <- c(
           min(c(media1+c(-4,4)*dp1, media2+c(-4,4)*dp2)), 
           max(c(media1+c(-4,4)*dp1, media2+c(-4,4)*dp2))
         )
  x <- seq(lim[1], lim[2], by = 0.01)
  
  # curva normal
  cn1 <- function(x) {dnorm(x,media1,dp1)} # curva normal
  cn2 <- function(x) {dnorm(x,media2,dp2)} # curva normal
  
  # traça as curvas normais 1 e 2
  if(cn1(media1)>=cn2(media2)){
    plot(x,cn1(x),ylab="Densidade",xlab="x",
         main="Curva Normal",type="l",lwd=2)
    lines(x,cn2(x),lwd=2, col="red")
  } else {
    plot(x,cn2(x),ylab="Densidade",xlab="x",
         main="Curva Normal",type="l",lwd=2,col="red")
    lines(x,cn1(x),lwd=2)
  }
    

  # linha horzontal em zero
  lines(lim,c(0,0))
  
  # linhas da média
  lines(c(media1,media1),c(-1,cn1(media1)),lwd=4,type="l")
  lines(c(media2,media2),c(-1,cn2(media2)),lwd=4,type="l",col="red")
  
  # intervalos de confiaça
  if(rc=="="){
    xI11 <- media1 - qnorm(nc+(1-nc)/2)*dp1
    xI12 <- media1 + qnorm(nc+(1-nc)/2)*dp1
    xI21 <- media2 - qnorm(nc+(1-nc)/2)*dp2
    xI22 <- media2 + qnorm(nc+(1-nc)/2)*dp2
  } else if(rc=="<"){
    xI11 <- media1 - 4*dp1
    xI12 <- media1 + qnorm(1-nc)*dp1
    xI21 <- media2 - 4*dp2
    xI22 <- media2 + qnorm(1-nc)*dp2    
  } else if(rc==">"){
    xI11 <- media1 + qnorm(nc)*dp1
    xI12 <- media1 + 4*dp1
    xI21 <- media2 + qnorm(nc)*dp2
    xI22 <- media2 + 4*dp2    
  }
    
  
  inc <- (xI12-xI11)/20
  i<-xI11+inc
  lines(c(i,i),c(-1,cn1(i)),col="black",lty=4,lwd=2)
  while(i < xI12){
    lines(c(i,i),c(0,cn1(i)),col="black",lwd=0.5)
    i<-i+inc
  }
  lines(c(i,i),c(-1,cn1(i)),col="black",lty=4,lwd=2)
  
  inc <- (xI22-xI21)/20
  i<-xI21+inc
  lines(c(i,i),c(-1,cn2(i)),col="red",lty=4,lwd=2)
  while(i < xI22){
    lines(c(i,i),c(0,cn2(i)),col="red",lwd=0.5)
    i<-i+inc
  }
  lines(c(i,i),c(-1,cn2(i)),col="red",lty=4,lwd=2)
}      