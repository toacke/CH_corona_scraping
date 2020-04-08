setwd(dirname(file.choose()))
# load the files which are used in the .Rmd file to the directory

###########
#start shiny
library(rsconnect)
library(RcppArmadillo)
library(shiny)
library(rlang)
rsconnect::setAccountInfo(name='YOUR_NAME', 
                          token='YOUR_TOKEN', 
                          secret='YOUR_SECRET')


deployApp("YOUR_APP.Rmd")
y


