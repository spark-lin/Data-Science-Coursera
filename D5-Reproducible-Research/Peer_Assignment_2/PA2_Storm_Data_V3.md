---
title: "Reproducible Research-Week 4-Course Project 2-Storm Data"
author: "Spark-lin"
date: "July 18, 2016"
output: html_document
---

# Introduction

Storms and other severe weather events can cause both public health and economic problems for communities and municipalities. Many severe events can result in fatalities, injuries, and property damage, and preventing such outcomes to the extent possible is a key concern.

This project involves exploring the U.S. National Oceanic and Atmospheric Administration's (NOAA) storm database. This database tracks characteristics of major storms and weather events in the United States, including when and where they occur, as well as estimates of any fatalities, injuries, and property damage.

## Data

The data for this assignment come in the form of a comma-separated-value file compressed via the bzip2 algorithm to reduce its size. You can download the file from the course web site:

Storm Data [47Mb] (https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2)
There is also some documentation of the database available. Here you will find how some of the variables are constructed/defined.

National Weather Service Storm Data Documentation (https://d396qusza40orc.cloudfront.net/repdata%2Fpeer2_doc%2Fpd01016005curr.pdf)
National Climatic Data Center Storm Events FAQ
The events in the database start in the year 1950 and end in November 2011. In the earlier years of the database there are generally fewer events recorded, most likely due to a lack of good records. More recent years should be considered more complete.

# 1-Setting
## 1.1-Load prequired packpage
```{r}
echo = TRUE           # Always make code visible
options(scipen = 1)   # Turn off scientific notations for numbers
library(grid)
library(plyr)
library(ggplot2)
library(data.table)
library(gridExtra)
```


# 2-Data Loading and Processing
## 2.1-Set working directory and download files
```{r}
setwd("~/Desktop/Coursera/D5_Reproducible Research/Week 2/Project_02/")
```

## 2.2- Download files
```{r}
if (!"StormData.csv.bz2" %in% dir("./")) {
  print("Loading File.....Please wait")
  download.file("https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2", destfile = "StormData.csv.bz2")
}
```
### Check if there is exsiting StormData.csv dataset, if so, dont't download the file repatedly
```{r}
if (!"StormData" %in% ls()){
  StormData <- read.csv("StormData.csv", sep = ",", header = TRUE, stringsAsFactors = FALSE)
}
dim(StormData)
```


## 2.3-Read the headtitle of StormData set

```{r}
names(StormData)
```


## 2.4-Retrieve datatable of StormData set
```{r}
DT_StromData<- data.table(StormData)
str(DT_StromData)
```


## 2.5-Visualize the StormData prior to cleaning and processing data
```{r}
if (dim(StormData)[2] == 37) {
    StormData$Year <- as.numeric(format(as.Date(StormData$BGN_DATE, format = "%m/%d/%Y %H:%M:%S"), "%Y"))
}

hist(StormData$Year,breaks = 50 , 
     main = "Histogram of StormData by Year", 
     xlab = "Year",
     ylab = "Frequency")
```


Based on this histogram, we could clearly observe that the number of events rise steadily from 1950,
and start to rise rapidly around 1995 to 2012 (second bar next to 1990 from the histogram, scale = 2 Years).
Thus, it's approprite to use the subset data [1995, 2010] for our analsis.

```{r}
StormData_ST <- StormData[StormData$Year >= 1995, ]
dim(StormData_ST)
```

We now narrow down our dataset to 681500 row and 38 columns

```{r}
names(StormData_ST)
```


Consult the Strom Data Documentation file, we could further filter the variables that affected most by Weather event.
We keep only six columns (variables) for our analysis, see as below:
BGN_DATE, EVTYPE, FATALITIES, INJURIES,PROPDMG, PROPDMGEXP, CROPDMG, CROPDMGEXP

```{r}
Filtered_Col <- c("BGN_DATE","EVTYPE","FATALITIES","INJURIES","PROPDMG","PROPDMGEXP","CROPDMG","CROPDMGEXP")
Filtered_StormData <- StormData_ST[Filtered_Col]
Filtered_StormData$Year <- as.numeric(format(as.Date(Filtered_StormData$BGN_DATE,format = "%m/%d/%Y %H:%M:%S"), "%Y"))

```
### Normalize and formalize the Property data. 
```{r}
unique(Filtered_StormData$PROPDMGEXP)
```


```{r}
Filtered_StormData$PROPDMGEXP <- as.character(Filtered_StormData$PROPDMGEXP)
Filtered_StormData$PROPDMGEXP[Filtered_StormData$PROPDMGEXP == 'B'] <- "9"
Filtered_StormData$PROPDMGEXP[Filtered_StormData$PROPDMGEXP == 'M'] <- "6"
Filtered_StormData$PROPDMGEXP[Filtered_StormData$PROPDMGEXP == 'K'] <- "3"
Filtered_StormData$PROPDMGEXP[Filtered_StormData$PROPDMGEXP == 'H'] <- "2"
Filtered_StormData$PROPDMGEXP[Filtered_StormData$PROPDMGEXP == ' '] <- "0"

Filtered_StormData$PROPDMGEXP<- as.numeric(Filtered_StormData$PROPDMGEXP)
```

```{r}
Filtered_StormData$PROPDMGEXP[is.na(Filtered_StormData$PROPDMGEXP)] <- 0
Filtered_StormData$Total_PROPDMG <- Filtered_StormData$PROPDMG * 10^Filtered_StormData$PROPDMGEXP
```

### Normalize and formalize the Crop data. 
```{r}
unique(Filtered_StormData$CROPDMGEXP)
```


```{r}
Filtered_StormData$CROPDMGEXP <- as.character(Filtered_StormData$CROPDMGEXP)
Filtered_StormData$CROPDMGEXP[Filtered_StormData$CROPDMGEXP == 'B'] <- "9"
Filtered_StormData$CROPDMGEXP[Filtered_StormData$CROPDMGEXP == 'M'] <- "6"
Filtered_StormData$CROPDMGEXP[Filtered_StormData$CROPDMGEXP == 'K'] <- "3"
Filtered_StormData$CROPDMGEXP[Filtered_StormData$CROPDMGEXP == 'H'] <- "2"
Filtered_StormData$CROPDMGEXP[Filtered_StormData$CROPDMGEXP == ' '] <- "0"

Filtered_StormData$CROPDMGEXP<- as.numeric(Filtered_StormData$CROPDMGEXP)

Filtered_StormData$CROPDMGEXP[is.na(Filtered_StormData$CROPDMGEXP)] <- 0
Filtered_StormData$Total_CROPDMG <- Filtered_StormData$CROPDMG * 10^Filtered_StormData$CROPDMGEXP
```

# See the sorted and cleaned Storm Data subset [1995,2010]
```{r}
head(Filtered_StormData)
```



```{r}
names(Filtered_StormData)
```


# 3-Strom Impact on different domains
## 3.1-To make the analysis outcome more evident, let's retrieve the Top-15 Most severe types of weather events
## Mind that the dataset used here is StormData_ST  (Subset of StormDate[1995,2010])

### Top-10 Fatalities by Weather Event
```{r}
Fatalities <- aggregate(FATALITIES ~ EVTYPE, data = Filtered_StormData, FUN = sum)
Top10_Fatalities <- Fatalities[order(-Fatalities$FATALITIES), ][1:10, ] # Remove decreasing = T
Top10_Fatalities 
```


### Top-10 Injuries by Weather Event
```{r}
Injuries <- aggregate(INJURIES ~ EVTYPE, data = Filtered_StormData, FUN = sum)
Top10_Injuries <- Injuries[order(-Injuries$INJURIES), ][1:10, ] # Remove decreasing = T
Top10_Injuries 
```


### Top-10 Property Damage by Weather Event
```{r}
propdmg <- aggregate(Total_PROPDMG ~ EVTYPE, data = Filtered_StormData, FUN = sum)
Top10_Propdmg <- propdmg[order(-propdmg$Total_PROPDMG), ][1:10, ] # Remove decreasing = T
Top10_Propdmg 
```


### Top-10 Corp Damage by Weather Event
```{r}
cropdmg <- aggregate(Total_CROPDMG ~ EVTYPE, data = Filtered_StormData, FUN = sum)
Top10_Cropdmg <- cropdmg[order(-cropdmg$Total_CROPDMG), ][1:10, ] # Remove decreasing = T
Top10_Cropdmg
```


## Population Health Effects
## Plot of Top 10 Fatalities of Weather Event Types
```{r}
ggplot(data = Top10_Fatalities , aes(x = reorder(EVTYPE, FATALITIES), y = FATALITIES)) +
  geom_bar(stat = "identity", fill = "red") + coord_flip() +
  ggtitle("Top 10 Fatalitie Damages of Weather Event Types in USA") +
  labs(x = "Weather Event Types", y = "Total Fatalitie Damage Expenses (US$) ")
```

```{r}



## Plot of Top 10 Injuries of Weather Event Types
```{r}
ggplot(data = Top10_Injuries, aes(x = reorder(EVTYPE, INJURIES), y = INJURIES)) +
  geom_bar(stat = "identity", fill = "red") + coord_flip() +
  ggtitle("Top 10 Property Damages of Weather Event Types in USA") +
  labs(x = "Weather Event Types", y = "Total Property Damage Expenses (US$) ")
```
```{r}

# Ok try another way, see wether it works if I merge two dataset
# Merge Fatalities dataset with Injuries dataset into Health Damage Expense
```{r}
Top10_HealthDmg <- merge(x = Top10_Fatalities, y = Top10_Injuries, by = "EVTYPE", all = TRUE)
Top10_HealthDmg <- melt(Top10_HealthDmg, id.vars = 'EVTYPE')
Top10_HealthDmg 
```


```{r}
ggplot(Top10_HealthDmg, aes(EVTYPE, value)) +
  xlab("Event Type") + 
  ylab("Damage Expenses (US $)") +
  ggtitle("Impact on Top-10 Health Damage Per Event Type") +
  geom_bar(aes(fill = variable), position = "dodge", stat="identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) 
```

We could observe from the histograms,from 1995-2010, the Excessive hear and Tornade are the main cause of Fatalities;
and Tornado is the main cause of Injuries in the US, which both have the highest figures.

## 3.3-Impact on Economy
## Plot of Top 10 Property Damages of Weather Event Types
```{r}
Top10_Propdmg_Plot <- ggplot(data = Top10_Propdmg, aes(x = reorder(EVTYPE, Total_PROPDMG), y = Total_PROPDMG)) +
  geom_bar(stat = "identity", fill = "steel blue") + coord_flip() +
  ggtitle("Top 10 Property Damages of Weather Event Types in USA") +
  labs(x = "Weather Event Types", y = "Total Property Damage Expenses (US$) ")
Top10_Propdmg_Plot
```

## Plot of Top 10 Crop Damages of Weather Event Types
```{r}
Top10_Cropdmg_Plot <- ggplot(data = Top10_Cropdmg, aes(x = reorder(EVTYPE, Total_CROPDMG),
                              y = Total_CROPDMG)) +
  geom_bar(stat = "identity", fill = "red") + coord_flip() +
  ggtitle("Top 10 Crop Damages of Weather Event Types in USA") +
  labs(x = "Weather Event Types", y = "Total Crop Damage Expenses (US$) ")
Top10_Cropdmg_Plot
```


## Merge Crop Damage dataset with Property Damage dataset into Economic Damage Expense
```{r}
Top10_EconomicDmg <- merge(x = Top10_Propdmg, y = Top10_Cropdmg, by = "EVTYPE", all = TRUE)
Top10_EconomicDmg <- melt(Top10_EconomicDmg, id.vars = 'EVTYPE')
# Top10_EconomicDmg 
```

```{r}
ggplot(Top10_EconomicDmg, aes(EVTYPE, value)) +
  xlab("Event Weather Type") + 
  ylab("Damage Expenses (US $)") +
  ggtitle("Impact on Top-10 Ecomomic Damage Per Event Type") +
  geom_bar(aes(fill = variable), position = "dodge", stat="identity") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) 
```

According to the aboved histograms,from 1995-2010, the Flood and Hurricane/Typhoon lead to most of Property damages;
and Flood cause most of Crop damages in the US, which both have the highest damage expenses figures.

# Conlusion
From the cleaned data and merge graphics, we could conclure that Excessive Heat and tornado are most harmful to the population health, while Flood, Drought, and Hurricane/Typhoon have the greatest impact on economic damages .