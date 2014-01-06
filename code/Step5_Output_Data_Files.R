rm(list = ls())

#Load Necessary Packages
library(plyr)
library(doBy)
library(reshape)


setwd("C:/Users/Zach/Documents/UrbanCCD/Streetlights")

#Open Alley Lights and Crime
Alley.Lights<- read.csv(file="alley.csv", head=TRUE)

#Open Street Lights One Out and Crime
Street.Lights.OneOut<- read.csv(file="street-one.csv", head=TRUE)

#Open Street Lights All Out and Crime
Street.Lights.AllOut<- read.csv(file="street-all.csv", head=TRUE)

#Change Community Areas to Numeric
Alley.Lights$community_area <- as.character(Alley.Lights$community_area)
Street.Lights.OneOut$community_area <- as.character(Street.Lights.OneOut$community_area)
Street.Lights.AllOut$community_area <- as.character(Street.Lights.AllOut$community_area)

Alley.Lights$community_area[which(nchar(Alley.Lights$community_area)==4)] <- as.numeric(substr(Alley.Lights$community_area[which(nchar(Alley.Lights$community_area)==4)],3,3))
Alley.Lights$community_area[which(nchar(Alley.Lights$community_area)==5)] <- as.numeric(substr(Alley.Lights$community_area[which(nchar(Alley.Lights$community_area)==5)],3,4))
Street.Lights.OneOut$community_area[which(nchar(Street.Lights.OneOut$community_area)==4)] <- as.numeric(substr(Street.Lights.OneOut$community_area[which(nchar(Street.Lights.OneOut$community_area)==4)],3,3))
Street.Lights.OneOut$community_area[which(nchar(Street.Lights.OneOut$community_area)==5)] <- as.numeric(substr(Street.Lights.OneOut$community_area[which(nchar(Street.Lights.OneOut$community_area)==5)],3,4))
Street.Lights.AllOut$community_area[which(nchar(Street.Lights.AllOut$community_area)==4)] <- as.numeric(substr(Street.Lights.AllOut$community_area[which(nchar(Street.Lights.AllOut$community_area)==4)],3,3))
Street.Lights.AllOut$community_area[which(nchar(Street.Lights.AllOut$community_area)==5)] <- as.numeric(substr(Street.Lights.AllOut$community_area[which(nchar(Street.Lights.AllOut$community_area)==5)],3,4))

# Remove Duplicates
Alley.Lights         <-         Alley.Lights[!duplicated(Alley.Lights$Service.Request.No),]
Street.Lights.OneOut <- Street.Lights.OneOut[!duplicated(Street.Lights.OneOut$Service.Request.No),]
Street.Lights.AllOut <- Street.Lights.AllOut[!duplicated(Street.Lights.AllOut$Service.Request.No),]


# Remove Community Area 0
Alley.Lights         <-         Alley.Lights[Alley.Lights$community_area        !=0,]
Street.Lights.OneOut <- Street.Lights.OneOut[Street.Lights.OneOut$community_area!=0,]
Street.Lights.AllOut <- Street.Lights.AllOut[Street.Lights.AllOut$community_area!=0,]

# Make Alley Lights Output File
Alley.Lights$Crime.Rate.During                        <- round(30*Alley.Lights$Crimes.All.During/Alley.Lights$OutageDuration, 2)
Alley.Lights$Crime.Rate.Before.and.After              <- round(30*(Alley.Lights$Crimes.All.Before + Alley.Lights$Crimes.All.After)/(30 + Alley.Lights$After.Period.Duration), 2)
Alley.Lights$Crime.Rate.Before                        <- round(Alley.Lights$Crimes.All.Before, 2)
Alley.Lights$Crime.Rate.After                         <- round(30*Alley.Lights$Crimes.All.After/Alley.Lights$After.Period.Duration, 2)
Alley.Lights$Theft.Rate.During                        <- round(30*Alley.Lights$Theft.During/Alley.Lights$OutageDuration, 2)
Alley.Lights$Theft.Rate.Before.and.After              <- round(30*(Alley.Lights$Theft.Before + Alley.Lights$Theft.After)/(30 + Alley.Lights$After.Period.Duration), 2)
Alley.Lights$Theft.Rate.Before                        <- round(Alley.Lights$Theft.Before, 2)
Alley.Lights$Theft.Rate.After                         <- round(30*Alley.Lights$Theft.After/Alley.Lights$After.Period.Duration, 2)
Alley.Lights$Narcotics.Rate.During                    <- round(30*Alley.Lights$Narcotics.During/Alley.Lights$OutageDuration, 2)
Alley.Lights$Narcotics.Rate.Before.and.After          <- round(30*(Alley.Lights$Narcotics.Before + Alley.Lights$Narcotics.After)/(30 + Alley.Lights$After.Period.Duration), 2)
Alley.Lights$Narcotics.Rate.Before                    <- round(Alley.Lights$Narcotics.Before, 2)
Alley.Lights$Narcotics.Rate.After                     <- round(30*Alley.Lights$Narcotics.After/Alley.Lights$After.Period.Duration, 2)
Alley.Lights$Battery.Rate.During                      <- round(30*Alley.Lights$Battery.During/Alley.Lights$OutageDuration, 2)
Alley.Lights$Battery.Rate.Before.and.After            <- round(30*(Alley.Lights$Battery.Before + Alley.Lights$Battery.After)/(30 + Alley.Lights$After.Period.Duration), 2)
Alley.Lights$Battery.Rate.Before                      <- round(Alley.Lights$Battery.Before, 2)
Alley.Lights$Battery.Rate.After                       <- round(30*Alley.Lights$Battery.After/Alley.Lights$After.Period.Duration, 2)
Alley.Lights$CriminalDamage.Rate.During               <- round(30*Alley.Lights$CriminalDamage.During/Alley.Lights$OutageDuration, 2)
Alley.Lights$CriminalDamage.Rate.Before.and.After     <- round(30*(Alley.Lights$CriminalDamage.Before + Alley.Lights$CriminalDamage.After)/(30 + Alley.Lights$After.Period.Duration), 2)
Alley.Lights$CriminalDamage.Rate.Before               <- round(Alley.Lights$CriminalDamage.Before, 2)
Alley.Lights$CriminalDamage.Rate.After                <- round(30*Alley.Lights$CriminalDamage.After/Alley.Lights$After.Period.Duration, 2)
Alley.Lights$MotorVehicleTheft.Rate.During            <- round(30*Alley.Lights$MotorVehicleTheft.During/Alley.Lights$OutageDuration, 2)
Alley.Lights$MotorVehicleTheft.Rate.Before.and.After  <- round(30*(Alley.Lights$MotorVehicleTheft.Before + Alley.Lights$MotorVehicleTheft.After)/(30 + Alley.Lights$After.Period.Duration), 2)
Alley.Lights$MotorVehicleTheft.Rate.Before            <- round(Alley.Lights$MotorVehicleTheft.Before, 2)
Alley.Lights$MotorVehicleTheft.Rate.After             <- round(30*Alley.Lights$MotorVehicleTheft.After/Alley.Lights$After.Period.Duration, 2)
Alley.Lights$Robbery.Rate.During                      <- round(30*Alley.Lights$Robbery.During/Alley.Lights$OutageDuration, 2)
Alley.Lights$Robbery.Rate.Before.and.After            <- round(30*(Alley.Lights$Robbery.Before + Alley.Lights$Robbery.After)/(30 + Alley.Lights$After.Period.Duration), 2)
Alley.Lights$Robbery.Rate.Before                      <- round(Alley.Lights$Robbery.Before, 2)
Alley.Lights$Robbery.Rate.After                       <- round(30*Alley.Lights$Robbery.After/Alley.Lights$After.Period.Duration, 2)
Alley.Lights$Assault.Rate.During                      <- round(30*Alley.Lights$Assault.During/Alley.Lights$OutageDuration, 2)
Alley.Lights$Assault.Rate.Before.and.After            <- round(30*(Alley.Lights$Assault.Before + Alley.Lights$Assault.After)/(30 + Alley.Lights$After.Period.Duration), 2)
Alley.Lights$Assault.Rate.Before                      <- round(Alley.Lights$Assault.Before, 2)
Alley.Lights$Assault.Rate.After                       <- round(30*Alley.Lights$Assault.After/Alley.Lights$After.Period.Duration, 2)
Alley.Lights$Burglary.Rate.During                     <- round(30*Alley.Lights$Burglary.During/Alley.Lights$OutageDuration, 2)
Alley.Lights$Burglary.Rate.Before.and.After           <- round(30*(Alley.Lights$Burglary.Before + Alley.Lights$Burglary.After)/(30 + Alley.Lights$After.Period.Duration), 2)
Alley.Lights$Burglary.Rate.Before                     <- round(Alley.Lights$Burglary.Before, 2)
Alley.Lights$Burglary.Rate.After                      <- round(30*Alley.Lights$Burglary.After/Alley.Lights$After.Period.Duration, 2)
Alley.Lights$Homicide.Rate.During                     <- round(30*Alley.Lights$Homicide.During/Alley.Lights$OutageDuration, 2)
Alley.Lights$Homicide.Rate.Before.and.After           <- round(30*(Alley.Lights$Homicide.Before + Alley.Lights$Homicide.After)/(30 + Alley.Lights$After.Period.Duration), 2)
Alley.Lights$Homicide.Rate.Before                     <- round(Alley.Lights$Homicide.Before, 2)
Alley.Lights$Homicide.Rate.After                      <- round(30*Alley.Lights$Homicide.After/Alley.Lights$After.Period.Duration, 2)
Alley.Lights$DeceptivePractice.Rate.During            <- round(30*Alley.Lights$DeceptivePractice.During/Alley.Lights$OutageDuration, 2)
Alley.Lights$DeceptivePractice.Rate.Before.and.After  <- round(30*(Alley.Lights$DeceptivePractice.Before + Alley.Lights$DeceptivePractice.After)/(30 + Alley.Lights$After.Period.Duration), 2)
Alley.Lights$DeceptivePractice.Rate.Before            <- round(Alley.Lights$DeceptivePractice.Before, 2)
Alley.Lights$DeceptivePractice.Rate.After             <- round(30*Alley.Lights$DeceptivePractice.After/Alley.Lights$After.Period.Duration, 2)
Alley.Lights <- Alley.Lights[,c("Service.Request.No","DateCreated", "DateCompleted", "Location", "Outcome", "x_coord", "y_coord", "zip_code", "ward","police_district", "community_area", "After.Period.Duration", "OutageDuration", 
                                                "Crimes.All.During", "Crimes.All.Before", "Crimes.All.After", "Crime.Rate.During", "Crime.Rate.Before.and.After", "Crime.Rate.Before", "Crime.Rate.After",
                                                "Theft.During", "Theft.Before", "Theft.After", "Theft.Rate.During", "Theft.Rate.Before.and.After", "Theft.Rate.Before", "Theft.Rate.After",
                                                "Narcotics.During", "Narcotics.Before", "Narcotics.After", "Narcotics.Rate.During", "Narcotics.Rate.Before.and.After", "Narcotics.Rate.Before", "Narcotics.Rate.After",
                                                "Battery.During", "Battery.Before", "Battery.After", "Battery.Rate.During", "Battery.Rate.Before.and.After", "Battery.Rate.Before", "Battery.Rate.After",
                                                "CriminalDamage.During", "CriminalDamage.Before", "CriminalDamage.After", "CriminalDamage.Rate.During", "CriminalDamage.Rate.Before.and.After", "CriminalDamage.Rate.Before", "CriminalDamage.Rate.After",
                                                "MotorVehicleTheft.During", "MotorVehicleTheft.Before", "MotorVehicleTheft.After", "MotorVehicleTheft.Rate.During", "MotorVehicleTheft.Rate.Before.and.After", "MotorVehicleTheft.Rate.Before", "MotorVehicleTheft.Rate.After",
                                                "Robbery.During", "Robbery.Before", "Robbery.After", "Robbery.Rate.During", "Robbery.Rate.Before.and.After", "Robbery.Rate.Before", "Robbery.Rate.After",
                                                "Assault.During", "Assault.Before", "Assault.After", "Assault.Rate.During", "Assault.Rate.Before.and.After", "Assault.Rate.Before", "Assault.Rate.After",
                                                "Burglary.During", "Burglary.Before", "Burglary.After", "Burglary.Rate.During", "Burglary.Rate.Before.and.After", "Burglary.Rate.Before", "Burglary.Rate.After", 
                                                "Homicide.During", "Homicide.Before", "Homicide.After", "Homicide.Rate.During", "Homicide.Rate.Before.and.After", "Homicide.Rate.Before", "Homicide.Rate.After",
                                                "DeceptivePractice.During", "DeceptivePractice.Before", "DeceptivePractice.After", "DeceptivePractice.Rate.During", "DeceptivePractice.Rate.Before.and.After", "DeceptivePractice.Rate.Before", "DeceptivePractice.Rate.After")]
Alley.Lights <- Alley.Lights[order(Alley.Lights$community_area),]
write.csv(Alley.Lights, file = "Alley_Lights_and_Crime.csv", row.names=FALSE) 

# Make Street Lights (One Out) Output File
Street.Lights.OneOut$Crime.Rate.During                        <- round(30*Street.Lights.OneOut$Crimes.All.During/Street.Lights.OneOut$OutageDuration, 2)
Street.Lights.OneOut$Crime.Rate.Before.and.After              <- round(30*(Street.Lights.OneOut$Crimes.All.Before + Street.Lights.OneOut$Crimes.All.After)/(30 + Street.Lights.OneOut$After.Period.Duration), 2)
Street.Lights.OneOut$Crime.Rate.Before                        <- round(Street.Lights.OneOut$Crimes.All.Before, 2)
Street.Lights.OneOut$Crime.Rate.After                         <- round(30*Street.Lights.OneOut$Crimes.All.After/Street.Lights.OneOut$After.Period.Duration, 2)
Street.Lights.OneOut$Theft.Rate.During                        <- round(30*Street.Lights.OneOut$Theft.During/Street.Lights.OneOut$OutageDuration, 2)
Street.Lights.OneOut$Theft.Rate.Before.and.After              <- round(30*(Street.Lights.OneOut$Theft.Before + Street.Lights.OneOut$Theft.After)/(30 + Street.Lights.OneOut$After.Period.Duration), 2)
Street.Lights.OneOut$Theft.Rate.Before                        <- round(Street.Lights.OneOut$Theft.Before, 2)
Street.Lights.OneOut$Theft.Rate.After                         <- round(30*Street.Lights.OneOut$Theft.After/Street.Lights.OneOut$After.Period.Duration, 2)
Street.Lights.OneOut$Narcotics.Rate.During                    <- round(30*Street.Lights.OneOut$Narcotics.During/Street.Lights.OneOut$OutageDuration, 2)
Street.Lights.OneOut$Narcotics.Rate.Before.and.After          <- round(30*(Street.Lights.OneOut$Narcotics.Before + Street.Lights.OneOut$Narcotics.After)/(30 + Street.Lights.OneOut$After.Period.Duration), 2)
Street.Lights.OneOut$Narcotics.Rate.Before                    <- round(Street.Lights.OneOut$Narcotics.Before, 2)
Street.Lights.OneOut$Narcotics.Rate.After                     <- round(30*Street.Lights.OneOut$Narcotics.After/Street.Lights.OneOut$After.Period.Duration, 2)
Street.Lights.OneOut$Battery.Rate.During                      <- round(30*Street.Lights.OneOut$Battery.During/Street.Lights.OneOut$OutageDuration, 2)
Street.Lights.OneOut$Battery.Rate.Before.and.After            <- round(30*(Street.Lights.OneOut$Battery.Before + Street.Lights.OneOut$Battery.After)/(30 + Street.Lights.OneOut$After.Period.Duration), 2)
Street.Lights.OneOut$Battery.Rate.Before                      <- round(Street.Lights.OneOut$Battery.Before, 2)
Street.Lights.OneOut$Battery.Rate.After                       <- round(30*Street.Lights.OneOut$Battery.After/Street.Lights.OneOut$After.Period.Duration, 2)
Street.Lights.OneOut$CriminalDamage.Rate.During               <- round(30*Street.Lights.OneOut$CriminalDamage.During/Street.Lights.OneOut$OutageDuration, 2)
Street.Lights.OneOut$CriminalDamage.Rate.Before.and.After     <- round(30*(Street.Lights.OneOut$CriminalDamage.Before + Street.Lights.OneOut$CriminalDamage.After)/(30 + Street.Lights.OneOut$After.Period.Duration), 2)
Street.Lights.OneOut$CriminalDamage.Rate.Before               <- round(Street.Lights.OneOut$CriminalDamage.Before, 2)
Street.Lights.OneOut$CriminalDamage.Rate.After                <- round(30*Street.Lights.OneOut$CriminalDamage.After/Street.Lights.OneOut$After.Period.Duration, 2)
Street.Lights.OneOut$MotorVehicleTheft.Rate.During            <- round(30*Street.Lights.OneOut$MotorVehicleTheft.During/Street.Lights.OneOut$OutageDuration, 2)
Street.Lights.OneOut$MotorVehicleTheft.Rate.Before.and.After  <- round(30*(Street.Lights.OneOut$MotorVehicleTheft.Before + Street.Lights.OneOut$MotorVehicleTheft.After)/(30 + Street.Lights.OneOut$After.Period.Duration), 2)
Street.Lights.OneOut$MotorVehicleTheft.Rate.Before            <- round(Street.Lights.OneOut$MotorVehicleTheft.Before, 2)
Street.Lights.OneOut$MotorVehicleTheft.Rate.After             <- round(30*Street.Lights.OneOut$MotorVehicleTheft.After/Street.Lights.OneOut$After.Period.Duration, 2)
Street.Lights.OneOut$Robbery.Rate.During                      <- round(30*Street.Lights.OneOut$Robbery.During/Street.Lights.OneOut$OutageDuration, 2)
Street.Lights.OneOut$Robbery.Rate.Before.and.After            <- round(30*(Street.Lights.OneOut$Robbery.Before + Street.Lights.OneOut$Robbery.After)/(30 + Street.Lights.OneOut$After.Period.Duration), 2)
Street.Lights.OneOut$Robbery.Rate.Before                      <- round(Street.Lights.OneOut$Robbery.Before, 2)
Street.Lights.OneOut$Robbery.Rate.After                       <- round(30*Street.Lights.OneOut$Robbery.After/Street.Lights.OneOut$After.Period.Duration, 2)
Street.Lights.OneOut$Assault.Rate.During                      <- round(30*Street.Lights.OneOut$Assault.During/Street.Lights.OneOut$OutageDuration, 2)
Street.Lights.OneOut$Assault.Rate.Before.and.After            <- round(30*(Street.Lights.OneOut$Assault.Before + Street.Lights.OneOut$Assault.After)/(30 + Street.Lights.OneOut$After.Period.Duration), 2)
Street.Lights.OneOut$Assault.Rate.Before                      <- round(Street.Lights.OneOut$Assault.Before, 2)
Street.Lights.OneOut$Assault.Rate.After                       <- round(30*Street.Lights.OneOut$Assault.After/Street.Lights.OneOut$After.Period.Duration, 2)
Street.Lights.OneOut$Burglary.Rate.During                     <- round(30*Street.Lights.OneOut$Burglary.During/Street.Lights.OneOut$OutageDuration, 2)
Street.Lights.OneOut$Burglary.Rate.Before.and.After           <- round(30*(Street.Lights.OneOut$Burglary.Before + Street.Lights.OneOut$Burglary.After)/(30 + Street.Lights.OneOut$After.Period.Duration), 2)
Street.Lights.OneOut$Burglary.Rate.Before                     <- round(Street.Lights.OneOut$Burglary.Before, 2)
Street.Lights.OneOut$Burglary.Rate.After                      <- round(30*Street.Lights.OneOut$Burglary.After/Street.Lights.OneOut$After.Period.Duration, 2)
Street.Lights.OneOut$Homicide.Rate.During                     <- round(30*Street.Lights.OneOut$Homicide.During/Street.Lights.OneOut$OutageDuration, 2)
Street.Lights.OneOut$Homicide.Rate.Before.and.After           <- round(30*(Street.Lights.OneOut$Homicide.Before + Street.Lights.OneOut$Homicide.After)/(30 + Street.Lights.OneOut$After.Period.Duration), 2)
Street.Lights.OneOut$Homicide.Rate.Before                     <- round(Street.Lights.OneOut$Homicide.Before, 2)
Street.Lights.OneOut$Homicide.Rate.After                      <- round(30*Street.Lights.OneOut$Homicide.After/Street.Lights.OneOut$After.Period.Duration, 2)
Street.Lights.OneOut$DeceptivePractice.Rate.During            <- round(30*Street.Lights.OneOut$DeceptivePractice.During/Street.Lights.OneOut$OutageDuration, 2)
Street.Lights.OneOut$DeceptivePractice.Rate.Before.and.After  <- round(30*(Street.Lights.OneOut$DeceptivePractice.Before + Street.Lights.OneOut$DeceptivePractice.After)/(30 + Street.Lights.OneOut$After.Period.Duration), 2)
Street.Lights.OneOut$DeceptivePractice.Rate.Before            <- round(Street.Lights.OneOut$DeceptivePractice.Before, 2)
Street.Lights.OneOut$DeceptivePractice.Rate.After             <- round(30*Street.Lights.OneOut$DeceptivePractice.After/Street.Lights.OneOut$After.Period.Duration, 2)
Street.Lights.OneOut <- Street.Lights.OneOut[,c("Service.Request.No","DateCreated", "DateCompleted", "Location", "Outcome", "x_coord", "y_coord", "zip_code", "ward","police_district", "community_area", "After.Period.Duration", "OutageDuration", 
                                                "Crimes.All.During", "Crimes.All.Before", "Crimes.All.After", "Crime.Rate.During", "Crime.Rate.Before.and.After", "Crime.Rate.Before", "Crime.Rate.After",
                                                "Theft.During", "Theft.Before", "Theft.After", "Theft.Rate.During", "Theft.Rate.Before.and.After", "Theft.Rate.Before", "Theft.Rate.After",
                                                "Narcotics.During", "Narcotics.Before", "Narcotics.After", "Narcotics.Rate.During", "Narcotics.Rate.Before.and.After", "Narcotics.Rate.Before", "Narcotics.Rate.After",
                                                "Battery.During", "Battery.Before", "Battery.After", "Battery.Rate.During", "Battery.Rate.Before.and.After", "Battery.Rate.Before", "Battery.Rate.After",
                                                "CriminalDamage.During", "CriminalDamage.Before", "CriminalDamage.After", "CriminalDamage.Rate.During", "CriminalDamage.Rate.Before.and.After", "CriminalDamage.Rate.Before", "CriminalDamage.Rate.After",
                                                "MotorVehicleTheft.During", "MotorVehicleTheft.Before", "MotorVehicleTheft.After", "MotorVehicleTheft.Rate.During", "MotorVehicleTheft.Rate.Before.and.After", "MotorVehicleTheft.Rate.Before", "MotorVehicleTheft.Rate.After",
                                                "Robbery.During", "Robbery.Before", "Robbery.After", "Robbery.Rate.During", "Robbery.Rate.Before.and.After", "Robbery.Rate.Before", "Robbery.Rate.After",
                                                "Assault.During", "Assault.Before", "Assault.After", "Assault.Rate.During", "Assault.Rate.Before.and.After", "Assault.Rate.Before", "Assault.Rate.After",
                                                "Burglary.During", "Burglary.Before", "Burglary.After", "Burglary.Rate.During", "Burglary.Rate.Before.and.After", "Burglary.Rate.Before", "Burglary.Rate.After", 
                                                "Homicide.During", "Homicide.Before", "Homicide.After", "Homicide.Rate.During", "Homicide.Rate.Before.and.After", "Homicide.Rate.Before", "Homicide.Rate.After",
                                                "DeceptivePractice.During", "DeceptivePractice.Before", "DeceptivePractice.After", "DeceptivePractice.Rate.During", "DeceptivePractice.Rate.Before.and.After", "DeceptivePractice.Rate.Before", "DeceptivePractice.Rate.After")]
Street.Lights.OneOut <- Street.Lights.OneOut[order(Street.Lights.OneOut$community_area),]
write.csv(Street.Lights.OneOut, file = "Street_Lights_One_Out_and_Crime.csv", row.names=FALSE) 

# Make Street Lights (All Out) Output File
Street.Lights.AllOut$Crime.Rate.During                        <- round(30*Street.Lights.AllOut$Crimes.All.During/Street.Lights.AllOut$OutageDuration, 2)
Street.Lights.AllOut$Crime.Rate.Before.and.After              <- round(30*(Street.Lights.AllOut$Crimes.All.Before + Street.Lights.AllOut$Crimes.All.After)/(30 + Street.Lights.AllOut$After.Period.Duration), 2)
Street.Lights.AllOut$Crime.Rate.Before                        <- round(Street.Lights.AllOut$Crimes.All.Before, 2)
Street.Lights.AllOut$Crime.Rate.After                         <- round(30*Street.Lights.AllOut$Crimes.All.After/Street.Lights.AllOut$After.Period.Duration, 2)
Street.Lights.AllOut$Theft.Rate.During                        <- round(30*Street.Lights.AllOut$Theft.During/Street.Lights.AllOut$OutageDuration, 2)
Street.Lights.AllOut$Theft.Rate.Before.and.After              <- round(30*(Street.Lights.AllOut$Theft.Before + Street.Lights.AllOut$Theft.After)/(30 + Street.Lights.AllOut$After.Period.Duration), 2)
Street.Lights.AllOut$Theft.Rate.Before                        <- round(Street.Lights.AllOut$Theft.Before, 2)
Street.Lights.AllOut$Theft.Rate.After                         <- round(30*Street.Lights.AllOut$Theft.After/Street.Lights.AllOut$After.Period.Duration, 2)
Street.Lights.AllOut$Narcotics.Rate.During                    <- round(30*Street.Lights.AllOut$Narcotics.During/Street.Lights.AllOut$OutageDuration, 2)
Street.Lights.AllOut$Narcotics.Rate.Before.and.After          <- round(30*(Street.Lights.AllOut$Narcotics.Before + Street.Lights.AllOut$Narcotics.After)/(30 + Street.Lights.AllOut$After.Period.Duration), 2)
Street.Lights.AllOut$Narcotics.Rate.Before                    <- round(Street.Lights.AllOut$Narcotics.Before, 2)
Street.Lights.AllOut$Narcotics.Rate.After                     <- round(30*Street.Lights.AllOut$Narcotics.After/Street.Lights.AllOut$After.Period.Duration, 2)
Street.Lights.AllOut$Battery.Rate.During                      <- round(30*Street.Lights.AllOut$Battery.During/Street.Lights.AllOut$OutageDuration, 2)
Street.Lights.AllOut$Battery.Rate.Before.and.After            <- round(30*(Street.Lights.AllOut$Battery.Before + Street.Lights.AllOut$Battery.After)/(30 + Street.Lights.AllOut$After.Period.Duration), 2)
Street.Lights.AllOut$Battery.Rate.Before                      <- round(Street.Lights.AllOut$Battery.Before, 2)
Street.Lights.AllOut$Battery.Rate.After                       <- round(30*Street.Lights.AllOut$Battery.After/Street.Lights.AllOut$After.Period.Duration, 2)
Street.Lights.AllOut$CriminalDamage.Rate.During               <- round(30*Street.Lights.AllOut$CriminalDamage.During/Street.Lights.AllOut$OutageDuration, 2)
Street.Lights.AllOut$CriminalDamage.Rate.Before.and.After     <- round(30*(Street.Lights.AllOut$CriminalDamage.Before + Street.Lights.AllOut$CriminalDamage.After)/(30 + Street.Lights.AllOut$After.Period.Duration), 2)
Street.Lights.AllOut$CriminalDamage.Rate.Before               <- round(Street.Lights.AllOut$CriminalDamage.Before, 2)
Street.Lights.AllOut$CriminalDamage.Rate.After                <- round(30*Street.Lights.AllOut$CriminalDamage.After/Street.Lights.AllOut$After.Period.Duration, 2)
Street.Lights.AllOut$MotorVehicleTheft.Rate.During            <- round(30*Street.Lights.AllOut$MotorVehicleTheft.During/Street.Lights.AllOut$OutageDuration, 2)
Street.Lights.AllOut$MotorVehicleTheft.Rate.Before.and.After  <- round(30*(Street.Lights.AllOut$MotorVehicleTheft.Before + Street.Lights.AllOut$MotorVehicleTheft.After)/(30 + Street.Lights.AllOut$After.Period.Duration), 2)
Street.Lights.AllOut$MotorVehicleTheft.Rate.Before            <- round(Street.Lights.AllOut$MotorVehicleTheft.Before, 2)
Street.Lights.AllOut$MotorVehicleTheft.Rate.After             <- round(30*Street.Lights.AllOut$MotorVehicleTheft.After/Street.Lights.AllOut$After.Period.Duration, 2)
Street.Lights.AllOut$Robbery.Rate.During                      <- round(30*Street.Lights.AllOut$Robbery.During/Street.Lights.AllOut$OutageDuration, 2)
Street.Lights.AllOut$Robbery.Rate.Before.and.After            <- round(30*(Street.Lights.AllOut$Robbery.Before + Street.Lights.AllOut$Robbery.After)/(30 + Street.Lights.AllOut$After.Period.Duration), 2)
Street.Lights.AllOut$Robbery.Rate.Before                      <- round(Street.Lights.AllOut$Robbery.Before, 2)
Street.Lights.AllOut$Robbery.Rate.After                       <- round(30*Street.Lights.AllOut$Robbery.After/Street.Lights.AllOut$After.Period.Duration, 2)
Street.Lights.AllOut$Assault.Rate.During                      <- round(30*Street.Lights.AllOut$Assault.During/Street.Lights.AllOut$OutageDuration, 2)
Street.Lights.AllOut$Assault.Rate.Before.and.After            <- round(30*(Street.Lights.AllOut$Assault.Before + Street.Lights.AllOut$Assault.After)/(30 + Street.Lights.AllOut$After.Period.Duration), 2)
Street.Lights.AllOut$Assault.Rate.Before                      <- round(Street.Lights.AllOut$Assault.Before, 2)
Street.Lights.AllOut$Assault.Rate.After                       <- round(30*Street.Lights.AllOut$Assault.After/Street.Lights.AllOut$After.Period.Duration, 2)
Street.Lights.AllOut$Burglary.Rate.During                     <- round(30*Street.Lights.AllOut$Burglary.During/Street.Lights.AllOut$OutageDuration, 2)
Street.Lights.AllOut$Burglary.Rate.Before.and.After           <- round(30*(Street.Lights.AllOut$Burglary.Before + Street.Lights.AllOut$Burglary.After)/(30 + Street.Lights.AllOut$After.Period.Duration), 2)
Street.Lights.AllOut$Burglary.Rate.Before                     <- round(Street.Lights.AllOut$Burglary.Before, 2)
Street.Lights.AllOut$Burglary.Rate.After                      <- round(30*Street.Lights.AllOut$Burglary.After/Street.Lights.AllOut$After.Period.Duration, 2)
Street.Lights.AllOut$Homicide.Rate.During                     <- round(30*Street.Lights.AllOut$Homicide.During/Street.Lights.AllOut$OutageDuration, 2)
Street.Lights.AllOut$Homicide.Rate.Before.and.After           <- round(30*(Street.Lights.AllOut$Homicide.Before + Street.Lights.AllOut$Homicide.After)/(30 + Street.Lights.AllOut$After.Period.Duration), 2)
Street.Lights.AllOut$Homicide.Rate.Before                     <- round(Street.Lights.AllOut$Homicide.Before, 2)
Street.Lights.AllOut$Homicide.Rate.After                      <- round(30*Street.Lights.AllOut$Homicide.After/Street.Lights.AllOut$After.Period.Duration, 2)
Street.Lights.AllOut$DeceptivePractice.Rate.During            <- round(30*Street.Lights.AllOut$DeceptivePractice.During/Street.Lights.AllOut$OutageDuration, 2)
Street.Lights.AllOut$DeceptivePractice.Rate.Before.and.After  <- round(30*(Street.Lights.AllOut$DeceptivePractice.Before + Street.Lights.AllOut$DeceptivePractice.After)/(30 + Street.Lights.AllOut$After.Period.Duration), 2)
Street.Lights.AllOut$DeceptivePractice.Rate.Before            <- round(Street.Lights.AllOut$DeceptivePractice.Before, 2)
Street.Lights.AllOut$DeceptivePractice.Rate.After             <- round(30*Street.Lights.AllOut$DeceptivePractice.After/Street.Lights.AllOut$After.Period.Duration, 2)
Street.Lights.AllOut <- Street.Lights.AllOut[,c("Service.Request.No","DateCreated", "DateCompleted", "Location", "Outcome", "x_coord", "y_coord", "zip_code", "ward","police_district", "community_area", "After.Period.Duration", "OutageDuration", 
                                                "Crimes.All.During", "Crimes.All.Before", "Crimes.All.After", "Crime.Rate.During", "Crime.Rate.Before.and.After", "Crime.Rate.Before", "Crime.Rate.After",
                                                "Theft.During", "Theft.Before", "Theft.After", "Theft.Rate.During", "Theft.Rate.Before.and.After", "Theft.Rate.Before", "Theft.Rate.After",
                                                "Narcotics.During", "Narcotics.Before", "Narcotics.After", "Narcotics.Rate.During", "Narcotics.Rate.Before.and.After", "Narcotics.Rate.Before", "Narcotics.Rate.After",
                                                "Battery.During", "Battery.Before", "Battery.After", "Battery.Rate.During", "Battery.Rate.Before.and.After", "Battery.Rate.Before", "Battery.Rate.After",
                                                "CriminalDamage.During", "CriminalDamage.Before", "CriminalDamage.After", "CriminalDamage.Rate.During", "CriminalDamage.Rate.Before.and.After", "CriminalDamage.Rate.Before", "CriminalDamage.Rate.After",
                                                "MotorVehicleTheft.During", "MotorVehicleTheft.Before", "MotorVehicleTheft.After", "MotorVehicleTheft.Rate.During", "MotorVehicleTheft.Rate.Before.and.After", "MotorVehicleTheft.Rate.Before", "MotorVehicleTheft.Rate.After",
                                                "Robbery.During", "Robbery.Before", "Robbery.After", "Robbery.Rate.During", "Robbery.Rate.Before.and.After", "Robbery.Rate.Before", "Robbery.Rate.After",
                                                "Assault.During", "Assault.Before", "Assault.After", "Assault.Rate.During", "Assault.Rate.Before.and.After", "Assault.Rate.Before", "Assault.Rate.After",
                                                "Burglary.During", "Burglary.Before", "Burglary.After", "Burglary.Rate.During", "Burglary.Rate.Before.and.After", "Burglary.Rate.Before", "Burglary.Rate.After", 
                                                "Homicide.During", "Homicide.Before", "Homicide.After", "Homicide.Rate.During", "Homicide.Rate.Before.and.After", "Homicide.Rate.Before", "Homicide.Rate.After",
                                                "DeceptivePractice.During", "DeceptivePractice.Before", "DeceptivePractice.After", "DeceptivePractice.Rate.During", "DeceptivePractice.Rate.Before.and.After", "DeceptivePractice.Rate.Before", "DeceptivePractice.Rate.After")]
Street.Lights.AllOut <- Street.Lights.AllOut[order(Street.Lights.AllOut$community_area),]
write.csv(Street.Lights.AllOut, file = "Street_Lights_All_Out_and_Crime.csv", row.names=FALSE) 


