This folder contains the main code used for this project.  All files should be run in order.  You can start with Step 1 using the data files in the data folder.

Step0 is a Python file that matches the outage data provided to us by CDOT with data on the Open Portal to obtain X and Y coordinates.  It produces the data files in the data folder.

Step1 is a Python file that uses the files in the data folder and creates counts of crimes before, during, and after each outage.

Step2 is an R file that uses outputs from the Step1 file and estimates differences between the mean crime rate in outage-affected areas and the mean crime in the before and after comparison periods.

Step3 is an R file that uses outputs from the Step1 file and estimates the average difference in crime rates within outage-affected areas.

Step4 is an R file that uses outputs from the Step3 file and estimates the average difference in robbery rates within alley light outage-affected areas by community area.
