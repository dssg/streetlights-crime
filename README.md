Street Light Outages and Crime in Chicago
==================

This a [Data Science for Social Good](http://www.dssg.io) project that estimates the association between alley and street light and outages and crime in Chicago over the period April 2012 - July 2013.


## The Power of City Data

This project uses data from the [City of Chicago Data Portal](https://data.cityofchicago.org/).  Chicago has been leader in making city data available to the public.  We believe that this data allows for a variety of questions to be studied in a way that they have not been studied before.  Further, as this project demonstrates, the data can be used to study questions that matter and that are important for department planning.


## The Problem: Why Study Outages and Crime?

The [Chicago Department of Transportation](http://www.cityofchicago.org/city/en/depts/cdot.html) (CDOT) received reports that some alley and street light outages were caused purposefully.  The department was concerned that individuals may be causing outages with the intent to commit crime in darker areas.  CDOT contacted us to investigate whether there was in fact a relationship between outages and crime around the city.  CDOT can use the findings to determine if shortening outage durations can decrease crime.  The geographic detail we provide can be used to determine if certain outages should be prioritized in order to reduce crime. 


## Methodological Challenges: Correlation vs. Causation

Our aim is to obtain a causal estimate of the effect of outages on crime.  The fundamental challenge is that different areas may be both high crime and susceptible to outages.  Therefore, raw correlations may tend to overestimate the causal effect.


## Our Approach: Comparisons within Areas Affected by Outages

We estimate the association between outages and crime by comparing crime rates during outages in the area affected by the outage to crime rates in the same areas immediately before and after the outage.  This method has the strong advantage that each outage-affected area serves as its own control.

The approach also partially adjusts for variation in crime rates over time by comparing crime rates in time periods close to each other.  However, our best model includes further adjustments for the crime time trend.

Specifically, we use Poisson Generalized Linear Models, which are useful for studying counts and rates.  Crime rates are modeled as a function of an outage indicators variable, fixed effects for each outage area, and a full set of monthly indicator varaibles to adjust estimates for the crime time trend.



