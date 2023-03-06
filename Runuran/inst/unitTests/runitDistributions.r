
### --- Test setup --- 
  #Libraries
  library(Runuran)
  library(ghyp)
  library(gamlss.dist)
  library(VGAM)


  ## size of sample for test
  samplesize <- 1.e3

  # Tolerance for the u-error
  u_tolerance <- 1.e-10 

  ## Setting the seed of the random number generator so that 
  ## we get the same results in every run..	
  set.seed(100)

### --- Test functions --- 

# Beta Distribution
test.udbeta <- function() {
  shape1 <- c(1,10)
  shape2 <- c(2.5,0.7)
  for(i in 1:length(shape1)){
    distr <- udbeta(shape1=shape1[i], shape2=shape2[i])
    pinvObj <- pinvd.new(distr)
    u <- runif(samplesize)
    checkEquals(pbeta(uq(pinvObj, u), shape1[i], shape2[i]), u, tolerance=u_tolerance)
  }
}


# Cauchy Distribution
test.udcauchy <- function() {
  location <- c(-2.5,0.9)
  scale <- c(0.7,1.2)
  for(i in 1:length(location)){
    distr <- udcauchy(location=location[i], scale=scale[i])
    pinvObj <- pinvd.new(distr)
    u <- runif(samplesize)
    checkEquals(pcauchy(uq(pinvObj, u), location[i], scale[i]), u, tolerance=u_tolerance)
  }
}

# Chi Distribution
test.udchi <- function() {	
  nu <- c(5,15)
  for(i in 1:length(nu)){
    distr <- udchi(df=nu[i])
    pinvObj <- pinvd.new(distr)
    u <- runif(samplesize)
    checkEquals(pchisq(uq(pinvObj, u)^2, nu[i]), u, tolerance=u_tolerance)
  }
}

# Chi-Squared Distribution
test.udchisq <- function() {	
  nu <- c(5,15)
  for(i in 1:length(nu)){
    distr <- udchisq(df=nu[i])
    pinvObj <- pinvd.new(distr)
    u <- runif(samplesize)
    checkEquals(pchisq(uq(pinvObj, u), nu[i]), u, tolerance=u_tolerance)
  }
}

# Exponential Distribution
test.udexp <- function() {	
  rate <- c(2.4,6.7)
  for(i in 1:length(rate)){
    distr <- udexp(rate=rate[i])
    pinvObj <- pinvd.new(distr)
    u <- runif(samplesize)
    checkEquals(pexp(uq(pinvObj, u), rate[i]), u, tolerance=u_tolerance)
  }
}

# F Distribution
test.udf <- function() {
  df1 <- c(3,6)
  df2 <- c(6,3)
  for(i in 1:length(df1)){
    distr <- udf(df1=df1[i], df2=df2[i])
    pinvObj <- pinvd.new(distr)
    u <- runif(samplesize)
    checkEquals(pf(uq(pinvObj, u), df1[i], df2[i]), u, tolerance=u_tolerance)
  }
}

# Frechet Distribution (Benchmark: VGAM package)
test.udfrechet <- function() {
  shape <- c(2,1)
  location <- c(-1.3,2.1)
  scale <- c(1.1,6.1)
  for(i in 1:length(shape)){
    distr <- udfrechet(shape=shape[i], location=location[i], scale=scale[i])
    pinvObj <- pinvd.new(distr)
    u <- runif(samplesize)
    checkEquals(pfrechet(uq(pinvObj, u), location= location[i], scale=scale[i], shape=shape[i]), u, tolerance=u_tolerance)
  }
}

# Gamma Distribution
test.udgamma <- function() {
  shape <- c(2,7.3)
  scale <- c(1.5,0.5)
  for(i in 1:length(shape)){
    distr <- udgamma(shape=shape[i], scale=scale[i])
    pinvObj <- pinvd.new(distr)
    u <- runif(samplesize)
    checkEquals(pgamma(uq(pinvObj, u), shape=shape[i], scale=scale[i]), u, tolerance=u_tolerance)
  }
}

# Generalized Hyperbolic Distribution (Benchmark: ghyp package)
test.udghyp <- function() {	
  lambda <- c(-1.7882,-0.5919)
  alpha <- c(21.3,45.9)
  beta <- c(2.67,4.59)
  delta <- c(0.0153,0.0177)
  mu <- c(-0.000004,-0.001271)  
  for(i in 1:length(alpha)){
    distr <- udghyp(lambda=lambda[i], alpha=alpha[i], beta=beta[i], delta=delta[i], mu=mu[i])  
    pinvObj <- pinvd.new(distr)
    ghypObj <- ghyp.ad(lambda=lambda[i], alpha=alpha[i], delta=delta[i], mu=mu[i], beta=beta[i])
    u <- runif(samplesize)
    checkEquals(pghyp(uq(pinvObj, u), ghypObj), u, tolerance=u_tolerance)
  }
}

# Generalized Inverse Gaussian Distribution (Benchmark: ghyp package)
test.udgig <- function() {
  lambda <- c(10,-0.5)
  chi <- c(1,1.5)
  psi <- c(1,2.7)
  for(i in 1:length(lambda)){
    distr <- udgig(theta=lambda[i], psi=psi[i], chi=chi[i])
    pinvObj <- pinvd.new(distr)
    u <- runif(samplesize)
    checkEquals(pgig(uq(pinvObj, u), lambda=lambda[i], chi=chi[i], psi=psi[i]), u, tolerance=u_tolerance)
  }
}

# Gumbel Distribution (Benchmark: VGAM package)
test.udgumbel <- function() {	
  location <- c(-1.3,2.1)
  scale <- c(1.1,6.1)
  for(i in 1:length(location)){
    distr <- udgumbel(location=location[i], scale=scale[i])
    pinvObj <- pinvd.new(distr)
    u <- runif(samplesize)
    checkEquals(pgumbel(uq(pinvObj, u), location= location[i], scale=scale[i]), u, tolerance=u_tolerance)
  }
}


# Hyperbolic Distribution (Benchmark: ghyp package)
test.udhyper <- function() {
  alpha <- c(0.5,2.5)
  beta <- c(0,-1.2)
  delta <- c(1,2)
  mu <- c(0,0.5)  
  for(i in 1:length(alpha)){
    distr <- udhyperbolic(alpha=alpha[i], delta=delta[i], mu=mu[i], beta=beta[i])
    pinvObj <- pinvd.new(distr)
    ghypObj <- hyp.ad(alpha=alpha[i], delta=delta[i], mu=mu[i], beta=beta[i])
    u <- runif(samplesize)
    checkEquals(pghyp(uq(pinvObj, u), ghypObj), u, tolerance=u_tolerance)
  }
}

# Inverse Gaussian Distribution (Benchmark: gamlss.dist package)
test.udig <- function() {
  mu <- c(1,2.5)
  sigma <- c(0.5,4.5)
  for(i in 1:length(mu)){
    distr <- udig(mu=mu[i], lambda=1/(sigma[i]^2))
    pinvObj <- pinvd.new(distr)
    u <- runif(samplesize)
    checkEquals(pIG(uq(pinvObj, u), mu=mu[i], sigma=sigma[i]), u, tolerance=u_tolerance)
  }
}

# Laplace Distribution (Benchmark: VGAM package)
test.udlaplace <- function() {
  location <- c(-1.3,2.1)
  scale <- c(1.1,6.1)
  for(i in 1:length(location)){
    distr <- udlaplace(location=location[i], scale=scale[i])
    pinvObj <- pinvd.new(distr)
    u <- runif(samplesize)
    checkEquals(plaplace(uq(pinvObj, u), location=location[i], scale=scale[i]), u, tolerance=u_tolerance)
  }
}


# Log Normal Distribution
test.udlnorm <- function() {	
  meanlog <- c(1.3,2.1)
  sdlog <- c(1.1,0.7)
  for(i in 1:length(meanlog)){
    distr <- udlnorm(meanlog=meanlog[i], sdlog=sdlog[i])
    pinvObj <- pinvd.new(distr)
    u <- runif(samplesize)
    checkEquals(plnorm(uq(pinvObj, u), meanlog=meanlog[i], sdlog=sdlog[i]), u, tolerance=u_tolerance)
  }
}

# Logistic distribution
test.udlogis <- function() {
  location <- c(-1.3,2.1)
  scale <- c(1.1,6.1)
  for(i in 1:length(location)){
    distr <- udlogis(location=location[i], scale=scale[i])
    pinvObj <- pinvd.new(distr)
    u <- runif(samplesize)
    checkEquals(plogis(uq(pinvObj, u), location= location[i], scale=scale[i]), u, tolerance=u_tolerance)
  }
}

# Lomax distribution (Benchmark: VGAM package)
test.udlomax <- function() {
  shape <- c(1.3,2.1)
  scale <- c(1.1,6.1)
  for(i in 1:length(shape)){
    distr <- udlomax(shape=shape[i], scale=scale[i])
    pinvObj <- pinvd.new(distr)
    u <- runif(samplesize)
    checkEquals(plomax(uq(pinvObj, u), scale=scale[i], shape[i]), u, tolerance=u_tolerance)
  }
}

# Normal Distribution
test.udnorm <- function() {
  mu <- c(0.5,2.1)
  sigma <- c(1.1,2.1)
  for(i in 1:length(mu)){
    distr <- udnorm(mean=mu[i], sd=sigma[i])
    pinvObj <- pinvd.new(distr)
    u <- runif(samplesize)
    checkEquals(pnorm(uq(pinvObj, u), mean=mu[i], sd=sigma[i]), u, tolerance=u_tolerance)
  }
}


# Pareto distribution (Benchmark: VGAM package)
test.udpareto <- function() {	
  location <- c(1.3,2.1)
  shape <- c(1.1,6.1)
  for(i in 1:length(location)){
    distr <- udpareto(k=location[i], a=shape[i])
    pinvObj <- pinvd.new(distr)
    u <- runif(samplesize)
    checkEquals(ppareto(uq(pinvObj, u), location=location[i],shape=shape[i]), u, tolerance=u_tolerance)
  }
}

# Rayleigh distribution (Benchmark: VGAM package)
test.udrayleigh <- function() {	
  scale <- c(1.1,2.3)
  for(i in 1:length(scale)){
    distr <- udrayleigh(scale=scale[i])
    pinvObj <- pinvd.new(distr)
    u <- runif(samplesize)
    checkEquals(prayleigh(uq(pinvObj, u), a=scale[i]), u, tolerance=u_tolerance)
  }
}

# Slash distribution (Benchmark: VGAM package)
#test.udslash <- function() {			
#  distr <- udslash()
#  pinvObj <- pinvd.new(distr)
#  u <- runif(samplesize)
#  checkEquals(pslash(uq(pinvObj, u)), u, tolerance=u_tolerance)
#}


# Student t Distribution
test.udt <- function() {	
  nu <- c(5,15)
  for(i in 1:length(nu)){
    distr <- udt(df=nu[i])
    pinvObj <- pinvd.new(distr)
    u <- runif(samplesize)
    checkEquals(pt(uq(pinvObj, u), nu[i]), u, tolerance=u_tolerance)
  }
}


# Weibull distribution
test.udweibull <- function() {			
  shape <- c(1.7,3.1)
  for(i in 1:length(shape)){
    distr <- udweibull(shape=shape[i])
	pinvObj <- pinvd.new(distr)
	u <- runif(samplesize)
	checkEquals(pweibull(uq(pinvObj, u), shape=shape[i]), u, tolerance=u_tolerance)
  }
}


