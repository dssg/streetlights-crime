rm(list = ls())

setwd("C:/Users/Zach/Documents/UrbanCCD/Streetlights")

#Load Necessary Packages
library(plyr)
library(glmmML)


#Open Street Lights and Crime Data Files
Street.Lights.OneOut.Pois <- read.csv(file="Street_Lights_One_Out_and_Crime_for_Comm_Area_Est.csv", head=TRUE)
Street.Lights.AllOut.Pois <- read.csv(file="Street_Lights_All_Out_and_Crime_for_Comm_Area_Est.csv", head=TRUE)


#Create Output Tables
Table.OneOut  <- data.frame(matrix(ncol = 3, nrow = 77))
Table.OneOut  <- rename(Table.OneOut,  c("X1"="PctDiff.Narcotics", "X2"="PVal.Narcotics", "X3"="Star.Narcotics"))
Table.AllOut  <- data.frame(matrix(ncol = 6, nrow = 77))
Table.AllOut  <- rename(Table.AllOut,  c("X1"="PctDiff.AllCrimes", "X2"="PVal.AllCrimes", "X3"="Star.AllCrimes",
                                         "X4"="PctDiff.Battery"  , "X5"="PVal.Battery"  , "X6"="Star.Battery"))

                       
Table.OneOut[is.na(Table.OneOut)] <- ""   
Table.AllOut[is.na(Table.AllOut)] <- ""  



# Loops to run Regressions and Put Outputs in Table 

for (i in 1:77) {
  x <- sum(Street.Lights.OneOut.Pois$Narcotics[Street.Lights.OneOut.Pois$community_area==i])
  if (x > 20) { 
    Fit.OneOut.Narcotics    <- try(glmmboot(Narcotics        ~ offset(log(Duration)) + OutageInd, cluster=Service.Request.No, family=poisson(link=log), data=subset(Street.Lights.OneOut.Pois, community_area==i)))
    if(inherits(Fit.OneOut.Narcotics, "try-error")) { next }
    Table.OneOut[i,1] <- 100*exp(Fit.OneOut.Narcotics$coef[1])-100
    Table.OneOut[i,2] <- 2*pt(-abs(Fit.OneOut.Narcotics$coef[1]/Fit.OneOut.Narcotics$sd[1]),df=length(Fit.OneOut.Narcotics$pred-1))
  }
}

for (i in 1:77) {
  x <- sum(Street.Lights.AllOut.Pois$AllCrimes[Street.Lights.AllOut.Pois$community_area==i])
  if (x > 20) { 
    Fit.AllOut.AllCrimes    <- try(glmmboot(AllCrimes        ~ offset(log(Duration)) + OutageInd, cluster=Service.Request.No, family=poisson(link=log), data=subset(Street.Lights.AllOut.Pois, community_area==i)))
    if(inherits(Fit.AllOut.AllCrimes, "try-error")) { next }
    Table.AllOut[i,1] <- 100*exp(Fit.AllOut.AllCrimes$coef[1])-100
    Table.AllOut[i,2] <- 2*pt(-abs(Fit.AllOut.AllCrimes$coef[1]/Fit.AllOut.AllCrimes$sd[1]),df=length(Fit.AllOut.AllCrimes$pred-1))
  }
}

for (i in 1:77) {
  x <- sum(Street.Lights.AllOut.Pois$Battery[Street.Lights.AllOut.Pois$community_area==i])
  if (x > 20) { 
    Fit.AllOut.Battery    <- try(glmmboot(Battery        ~ offset(log(Duration)) + OutageInd, cluster=Service.Request.No, family=poisson(link=log), data=subset(Street.Lights.AllOut.Pois, community_area==i)))
    if(inherits(Fit.AllOut.Battery, "try-error")) { next }
    Table.AllOut[i,4] <- 100*exp(Fit.AllOut.Battery$coef[1])-100
    Table.AllOut[i,5] <- 2*pt(-abs(Fit.AllOut.Battery$coef[1]/Fit.AllOut.Battery$sd[1]),df=length(Fit.AllOut.Battery$pred-1))
  }
}

                      
Table.OneOut$Star.Narcotics[which(Table.OneOut$PVal.Narcotics<0.01 & Table.OneOut$PVal.Narcotics!="")]                                          <- rep("**", length(which(Table.OneOut$PVal.Narcotics<0.01 & Table.OneOut$PVal.Narcotics!="")))
Table.OneOut$Star.Narcotics[which(Table.OneOut$PVal.Narcotics<0.05 & Table.OneOut$PVal.Narcotics>=0.01 & Table.OneOut$PVal.Narcotics!="")]         <- rep("*" , length(which(Table.OneOut$PVal.Narcotics<0.05 & Table.OneOut$PVal.Narcotics>=0.01 & Table.OneOut$PVal.Narcotics!="")))
Table.AllOut$Star.AllCrimes[which(Table.AllOut$PVal.AllCrimes<0.01 & Table.AllOut$PVal.AllCrimes!="")]                                          <- rep("**", length(which(Table.AllOut$PVal.AllCrimes<0.01 & Table.AllOut$PVal.AllCrimes!="")))
Table.AllOut$Star.AllCrimes[which(Table.AllOut$PVal.AllCrimes<0.05 & Table.AllOut$PVal.AllCrimes>=0.01 & Table.AllOut$PVal.AllCrimes!="")]         <- rep("*" , length(which(Table.AllOut$PVal.AllCrimes<0.05 & Table.AllOut$PVal.AllCrimes>=0.01 & Table.AllOut$PVal.AllCrimes!="")))
Table.AllOut$Star.Battery[which(Table.AllOut$PVal.Battery<0.01 & Table.AllOut$PVal.Battery!="")]                                          <- rep("**", length(which(Table.AllOut$PVal.Battery<0.01 & Table.AllOut$PVal.Battery!="")))
Table.AllOut$Star.Battery[which(Table.AllOut$PVal.Battery<0.05 & Table.AllOut$PVal.Battery>=0.01 & Table.AllOut$PVal.Battery!="")]         <- rep("*" , length(which(Table.AllOut$PVal.Battery<0.05 & Table.AllOut$PVal.Battery>=0.01 & Table.AllOut$PVal.Battery!="")))

Table.OneOut[,1] <- round(as.numeric(Table.OneOut[,1]),3)
Table.OneOut[,2] <- round(as.numeric(Table.OneOut[,2]),3)
Table.AllOut[,1] <- round(as.numeric(Table.AllOut[,1]),3)
Table.AllOut[,2] <- round(as.numeric(Table.AllOut[,2]),3)
Table.AllOut[,4] <- round(as.numeric(Table.AllOut[,4]),3)
Table.AllOut[,5] <- round(as.numeric(Table.AllOut[,5]),3)









