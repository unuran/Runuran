# source("./R/Runur.R",echo=TRUE,print.eval=TRUE)

# load library 'unuran'
dyn.load("libunuran.so",local=FALSE)

# load library 'Runuran' (interface between R and 'unuran')
dyn.load("libRunuran.so")

# load methods to define a class unuran in R
library(methods)

# define class 'unur'
 setClass("unur",representation(string="character",p="externalptr"), 
                  prototype = list(string=character(), p="externalptr"))

# Initialization for class 'unuran'
setMethod("initialize","unur",  
           function(.Object,x=character())
            { .Object@string <- x
              .Object@p <-.Call("R_unur_init",x) 
              .Object 
            }
         )

# definition of Function 'sample' , 
setGeneric("sample")
sample.unur<-function(x,y) .Call("R_unur_sample",x@p,as.integer(y))

# definition of Function 'print'
print.unur<-function(x) print(x@string)

# test
print("------------------------test ----------------------")
gen1<-new("unur","normal")
print.unur(gen1)
sample.unur(gen1,5)


print("------------------------Beispiele ----------------------")
# Beispiel 1
datanormal1=sample.unur(gen1,5)
print(datanormal1)
#
# Beispiel 2
gen2<-new("unur","normal(1,2);domain=(0,inf)")
datanormal2=sample.unur(gen2,5)
print(datanormal2)
hist(z<-sample.unur(gen2,100000),breaks=20)
#
# Beispiel 3
gen3<-new("unur","normal(1,2);domain=(0,inf)&method=hinv")
datanormal3=sample.unur(gen3,5)
print(datanormal3)
hist(z<-sample.unur(gen3,100000),breaks=20)
#
# Beispiel 4
gen4<-new("unur","distr = cont; pdf=\"1-x*x\"; domain=(-1,1) & method=tdr")
datanormal4=sample.unur(gen4,5)
print(datanormal4)
hist(z<-sample.unur(gen4,100000),breaks=20)

# Beispiel 5 hyperbolische Funktion
gen5<-new("unur","distr = cont; pdf=\"1/sqrt(1+x^2)*exp(-2*sqrt(1+x^2)+1*x)\"; domain=(-1,3) & method=tdr")
datanormal5=sample.unur(gen5,5)
print(datanormal5)
hist(z<-sample.unur(gen5,100000),breaks=20)

#------output to postscript file----------
# postscript("bild.ps",horizontal=FALSE)     # open Device postscript - see also help(Device)
# hist(z <- sample.unur(gen5, 1e+05), breaks = 40,tck=0.01,main="Titel")
# graphics.off()                           # close graphic Devices