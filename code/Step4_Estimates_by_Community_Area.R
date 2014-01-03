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

Table.OneOut[is.na(Table.OneOut)] <- ""   
Table.AllOut[is.na(Table.AllOut)] <- ""  



#Open Street Lights Out and Crime
Street.Lights.AllOut<- read.csv(file="street-all.csv", head=TRUE)


#Change Community Areas to Numeric
Street.Lights.AllOut$community_area <- as.character(Street.Lights.AllOut$community_area)
Street.Lights.AllOut$community_area[which(nchar(Street.Lights.AllOut$community_area)==4)] <- as.numeric(substr(Street.Lights.AllOut$community_area[which(nchar(Street.Lights.AllOut$community_area)==4)],3,3))
Street.Lights.AllOut$community_area[which(nchar(Street.Lights.AllOut$community_area)==5)] <- as.numeric(substr(Street.Lights.AllOut$community_area[which(nchar(Street.Lights.AllOut$community_area)==5)],3,4))

# Remove Duplicates
Street.Lights.AllOut         <-         Street.Lights.AllOut[!duplicated(Street.Lights.AllOut$Service.Request.No),]

# Remove Community Area 0
Street.Lights.AllOut         <-         Street.Lights.AllOut[Street.Lights.AllOut$community_area        !=0,]

# Keep 6 Community Areas with Significant Results
Street.Lights.AllOut.Signif.CommAreas <- Street.Lights.AllOut[which(Street.Lights.AllOut$community_area==16 | Street.Lights.AllOut$community_area==19 | Street.Lights.AllOut$community_area==42 | Street.Lights.AllOut$community_area==54 | Street.Lights.AllOut$community_area==66 | Street.Lights.AllOut$community_area==69),]
Street.Lights.AllOut.Signif.CommAreas$RateNotDuring <- 30*(Street.Lights.AllOut.Signif.CommAreas$Crimes.All.Before + Street.Lights.AllOut.Signif.CommAreas$Crimes.All.After)/(30 + Street.Lights.AllOut.Signif.CommAreas$After.Period.Duration)
Street.Lights.AllOut.Signif.CommAreas$RateDuring <- 30*Street.Lights.AllOut.Signif.CommAreas$Crimes.All.During/Street.Lights.AllOut.Signif.CommAreas$OutageDuration
Street.Lights.AllOut.Signif.CommAreas$RateDiff <- Street.Lights.AllOut.Signif.CommAreas$RateDuring - Street.Lights.AllOut.Signif.CommAreas$RateNotDuring
Street.Lights.AllOut.Signif.CommAreas <- Street.Lights.AllOut.Signif.CommAreas[order(-Street.Lights.AllOut.Signif.CommAreas$RateDiff),]
Street.Lights.AllOut.Signif.CommAreas <- Street.Lights.AllOut.Signif.CommAreas[,c("Service.Request.No","DateCreated", "DateCompleted", "Location", "Outcome", "x_coord", "y_coord", "zip_code", "ward",
                             "police_district", "community_area", "Crimes.All.Before", "Crimes.All.During", "Crimes.All.After", "RateNotDuring", "RateDuring", 
                             "RateDiff", "After.Period.Duration", "OutageDuration")]
Street.Lights.AllOut.Signif.CommAreas <- Street.Lights.AllOut.Signif.CommAreas[Street.Lights.AllOut.Signif.CommAreas$RateDiff>=1.5,]
Street.Lights.AllOut.Signif.CommAreas <- Street.Lights.AllOut.Signif.CommAreas[order(Street.Lights.AllOut.Signif.CommAreas$community_area),]








