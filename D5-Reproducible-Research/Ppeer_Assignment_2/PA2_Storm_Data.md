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

```{r}
## [1] 902297     38
```
## 2.3-Read the headtitle of StormData set
```{r}
#  STATE__          BGN_DATE BGN_TIME TIME_ZONE COUNTY COUNTYNAME STATE  EVTYPE BGN_RANGE BGN_AZI BGN_LOCATI END_DATE END_TIME COUNTY_END
# 1       1 4/18/1950 0:00:00     0130       CST     97     MOBILE    AL TORNADO         0                                               0
# 2       1 4/18/1950 0:00:00     0145       CST      3    BALDWIN    AL TORNADO         0                                               0
#   COUNTYENDN END_RANGE END_AZI END_LOCATI LENGTH WIDTH F MAG FATALITIES INJURIES PROPDMG PROPDMGEXP CROPDMG CROPDMGEXP WFO STATEOFFIC
# 1         NA         0                        14   100 3   0          0       15    25.0          K       0                          
# 2         NA         0                         2   150 2   0          0        0     2.5          K       0                          
#   ZONENAMES LATITUDE LONGITUDE LATITUDE_E LONGITUDE_ REMARKS REFNUM Year
# 1               3040      8812       3051       8806              1 1950
# 2               3042      8755          0          0              2 1950
```

```{r}
names(StormData)
```
```{r}
## [1] "STATE__"    "BGN_DATE"   "BGN_TIME"   "TIME_ZONE"  "COUNTY"     "COUNTYNAME" "STATE"      "EVTYPE"     "BGN_RANGE"  "BGN_AZI"   
## [11] "BGN_LOCATI" "END_DATE"   "END_TIME"   "COUNTY_END" "COUNTYENDN" "END_RANGE"  "END_AZI"    "END_LOCATI" "LENGTH"     "WIDTH"     
## [21] "F"          "MAG"        "FATALITIES" "INJURIES"   "PROPDMG"    "PROPDMGEXP" "CROPDMG"    "CROPDMGEXP" "WFO"        "STATEOFFIC"
## [31] "ZONENAMES"  "LATITUDE"   "LONGITUDE"  "LATITUDE_E" "LONGITUDE_" "REMARKS"    "REFNUM"     "Year"   
```

## 2.4-Retrieve datatable of StormData set
```{r}
DT_StromData<- data.table(StormData)
str(DT_StromData)
```
```{r}
## Classes ‘data.table’ and 'data.frame':	902297 obs. of  38 variables:
##  $ STATE__   : num  1 1 1 1 1 1 1 1 1 1 ...
##  $ BGN_DATE  : chr  "4/18/1950 0:00:00" "4/18/1950 0:00:00" "2/20/1951 0:00:00" "6/8/1951 0:00:00" ...
##  $ BGN_TIME  : chr  "0130" "0145" "1600" "0900" ...
##  $ TIME_ZONE : chr  "CST" "CST" "CST" "CST" ...
##  $ COUNTY    : num  97 3 57 89 43 77 9 123 125 57 ...
##  $ COUNTYNAME: chr  "MOBILE" "BALDWIN" "FAYETTE" "MADISON" ...
##  $ STATE     : chr  "AL" "AL" "AL" "AL" ...
##  $ EVTYPE    : chr  "TORNADO" "TORNADO" "TORNADO" "TORNADO" ...
##  $ BGN_RANGE : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ BGN_AZI   : chr  "" "" "" "" ...
##  $ BGN_LOCATI: chr  "" "" "" "" ...
##  $ END_DATE  : chr  "" "" "" "" ...
##  $ END_TIME  : chr  "" "" "" "" ...
##  $ COUNTY_END: num  0 0 0 0 0 0 0 0 0 0 ...
##  $ COUNTYENDN: logi  NA NA NA NA NA NA ...
##  $ END_RANGE : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ END_AZI   : chr  "" "" "" "" ...
##  $ END_LOCATI: chr  "" "" "" "" ...
##  $ LENGTH    : num  14 2 0.1 0 0 1.5 1.5 0 3.3 2.3 ...
##  $ WIDTH     : num  100 150 123 100 150 177 33 33 100 100 ...
##  $ F         : int  3 2 2 2 2 2 2 1 3 3 ...
##  $ MAG       : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ FATALITIES: num  0 0 0 0 0 0 0 0 1 0 ...
##  $ INJURIES  : num  15 0 2 2 2 6 1 0 14 0 ...
##  $ PROPDMG   : num  25 2.5 25 2.5 2.5 2.5 2.5 2.5 25 25 ...
##  $ PROPDMGEXP: chr  "K" "K" "K" "K" ...
##  $ CROPDMG   : num  0 0 0 0 0 0 0 0 0 0 ...
##  $ CROPDMGEXP: chr  "" "" "" "" ...
##  $ WFO       : chr  "" "" "" "" ...
##  $ STATEOFFIC: chr  "" "" "" "" ...
##  $ ZONENAMES : chr  "" "" "" "" ...
##  $ LATITUDE  : num  3040 3042 3340 3458 3412 ...
##  $ LONGITUDE : num  8812 8755 8742 8626 8642 ...
##  $ LATITUDE_E: num  3051 0 0 0 0 ...
##  $ LONGITUDE_: num  8806 0 0 0 0 ...
##  $ REMARKS   : chr  "" "" "" "" ...
##  $ REFNUM    : num  1 2 3 4 5 6 7 8 9 10 ...
##  $ Year      : num  1950 1950 1951 1951 1951 ...
##  - attr(*, ".internal.selfref")=<externalptr> 
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
```{r}
## [1] 681500     38

```
We now narrow down our dataset to 681500 row and 38 columns

```{r}
names(StormData_ST)
```
```{r}
## [1] "STATE__"    "BGN_DATE"   "BGN_TIME"   "TIME_ZONE"  "COUNTY"     "COUNTYNAME" "STATE"      "EVTYPE"     "BGN_RANGE"  "BGN_AZI"   ## [11] "BGN_LOCATI" "END_DATE"   "END_TIME"   "COUNTY_END" "COUNTYENDN" "END_RANGE"  "END_AZI"    "END_LOCATI" "LENGTH"     "WIDTH"     
## [21] "F"          "MAG"        "FATALITIES" "INJURIES"   "PROPDMG"    "PROPDMGEXP" "CROPDMG"    "CROPDMGEXP" "WFO"        "STATEOFFIC"
## [31] "ZONENAMES"  "LATITUDE"   "LONGITUDE"  "LATITUDE_E" "LONGITUDE_" "REMARKS"    "REFNUM"     "Year"    
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
## [1] ""  "B" "M" "K" "m" "+" "0" "5" "6" "?" "4" "2" "3" "7" "H" "-" "1" "8"
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
# Warning message: NAs introduced by coercion 
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
## [1] ""  "M" "m" "K" "B" "?" "0" "k" "2"
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
##                 BGN_DATE                    EVTYPE FATALITIES INJURIES PROPDMG PROPDMGEXP CROPDMG CROPDMGEXP Year Total_PROPDMG
## 187560  1/6/1995 0:00:00             FREEZING RAIN          0        0     0.0          0       0          0 1995         0e+00
## 187561 1/22/1995 0:00:00                      SNOW          0        0     0.0          0       0          0 1995         0e+00
## 187563  2/6/1995 0:00:00                  SNOW/ICE          0        0     0.0          0       0          0 1995         0e+00
## 187565 2/11/1995 0:00:00                  SNOW/ICE          0        0     0.0          0       0          0 1995         0e+00
## 187566 10/4/1995 0:00:00 HURRICANE OPAL/HIGH WINDS          2        0     0.1          9      10          6 1995         1e+08
## 187575 3/20/1995 0:00:00                      HAIL          0        0     0.0          0       0          0 1995         0e+00
##        Total_CROPDMG
## 187560         0e+00
## 187561         0e+00
## 187563         0e+00
## 187565         0e+00
## 187566         1e+07
## 187575         0e+00
```

```{r}
names(Filtered_StormData)
```
```{r}
## [1] "BGN_DATE"      "EVTYPE"        "FATALITIES"    "INJURIES"      "PROPDMG"       "PROPDMGEXP"    "CROPDMG"       "CROPDMGEXP"   
## [9] "Year"          "Total_PROPDMG" "Total_CROPDMG"
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
```{r}
##             EVTYPE FATALITIES
## 112 EXCESSIVE HEAT       1903
## 666        TORNADO       1545
## 134    FLASH FLOOD        934
## 231           HEAT        924
## 358      LIGHTNING        729
## 144          FLOOD        423
## 461    RIP CURRENT        360
## 288      HIGH WIND        241
## 683      TSTM WIND        241
## 16       AVALANCHE        223
```

### Top-10 Injuries by Weather Event
```{r}
Injuries <- aggregate(INJURIES ~ EVTYPE, data = Filtered_StormData, FUN = sum)
Top10_Injuries <- Injuries[order(-Injuries$INJURIES), ][1:10, ] # Remove decreasing = T
Top10_Injuries 
```
```{r}
##                EVTYPE INJURIES
## 666           TORNADO    21765
## 144             FLOOD     6769
## 112    EXCESSIVE HEAT     6525
## 358         LIGHTNING     4631
## 683         TSTM WIND     3630
## 231              HEAT     2030
## 134       FLASH FLOOD     1734
## 607 THUNDERSTORM WIND     1426
## 787      WINTER STORM     1298
## 313 HURRICANE/TYPHOON     1275
```

### Top-10 Property Damage by Weather Event
```{r}
propdmg <- aggregate(Total_PROPDMG ~ EVTYPE, data = Filtered_StormData, FUN = sum)
Top10_Propdmg <- propdmg[order(-propdmg$Total_PROPDMG), ][1:10, ] # Remove decreasing = T
Top10_Propdmg 
```
```{r}
##                EVTYPE Total_PROPDMG
## 144             FLOOD  144022037057
## 313 HURRICANE/TYPHOON   69305840000
## 519       STORM SURGE   43193536000
## 666           TORNADO   24925439556
## 134       FLASH FLOOD   16047794571
## 206              HAIL   15043822108
## 306         HURRICANE   11812819010
## 677    TROPICAL STORM    7653335550
## 288         HIGH WIND    5259785375
## 773          WILDFIRE    4759064000
```

### Top-10 Corp Damage by Weather Event
```{r}
cropdmg <- aggregate(Total_CROPDMG ~ EVTYPE, data = Filtered_StormData, FUN = sum)
Top10_Cropdmg <- cropdmg[order(-cropdmg$Total_CROPDMG), ][1:10, ] # Remove decreasing = T
Top10_Cropdmg
```
```{r}
##                EVTYPE Total_CROPDMG
## 84            DROUGHT   13922066000
## 144             FLOOD    5422810400
## 306         HURRICANE    2741410000
## 206              HAIL    2613777420
## 313 HURRICANE/TYPHOON    2607872800
## 134       FLASH FLOOD    1343915000
## 121      EXTREME COLD    1292473000
## 179      FROST/FREEZE    1094086000
## 241        HEAVY RAIN     728399800
## 677    TROPICAL STORM     677836000
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
# Error in reorder(EVTYPE, FATALITIES) : object 'EVTYPE' not found
# Don't know why, I've tried more than 50 times
# And I didn't change anything, but the plot works now, Don't know why, weird!
```


## Plot of Top 10 Injuries of Weather Event Types
```{r}
ggplot(data = Top10_Injuries, aes(x = reorder(EVTYPE, INJURIES), y = INJURIES)) +
  geom_bar(stat = "identity", fill = "red") + coord_flip() +
  ggtitle("Top 10 Property Damages of Weather Event Types in USA") +
  labs(x = "Weather Event Types", y = "Total Property Damage Expenses (US$) ")
```
```{r}
# Error in reorder(EVTYPE, FATALITIES) : object 'EVTYPE' not found
# Don't know why, I've tried more than 50 times
# And I didn't change anything, but the plot works now, Don't know why, weird!
```

# Ok try another way, see wether it works if I merge two dataset
# Merge Fatalities dataset with Injuries dataset into Health Damage Expense
```{r}
Top10_HealthDmg <- merge(x = Top10_Fatalities, y = Top10_Injuries, by = "EVTYPE", all = TRUE)
Top10_HealthDmg <- melt(Top10_HealthDmg, id.vars = 'EVTYPE')
Top10_HealthDmg 
```
```{r}
##               EVTYPE   variable value
## 1          AVALANCHE FATALITIES   223
## 2     EXCESSIVE HEAT FATALITIES  1903
## 3        FLASH FLOOD FATALITIES   934
## 4              FLOOD FATALITIES   423
## 5               HEAT FATALITIES   924
## 6          HIGH WIND FATALITIES   241
## 7  HURRICANE/TYPHOON FATALITIES    NA
## 8          LIGHTNING FATALITIES   729
## 9        RIP CURRENT FATALITIES   360
## 10 THUNDERSTORM WIND FATALITIES    NA
## 11           TORNADO FATALITIES  1545
## 12         TSTM WIND FATALITIES   241
## 13      WINTER STORM FATALITIES    NA
## 14         AVALANCHE   INJURIES    NA
## 15    EXCESSIVE HEAT   INJURIES  6525
## 16       FLASH FLOOD   INJURIES  1734
## 17             FLOOD   INJURIES  6769
## 18              HEAT   INJURIES  2030
## 19         HIGH WIND   INJURIES    NA
## 20 HURRICANE/TYPHOON   INJURIES  1275
## 21         LIGHTNING   INJURIES  4631
## 22       RIP CURRENT   INJURIES    NA
## 23 THUNDERSTORM WIND   INJURIES  1426
## 24           TORNADO   INJURIES 21765
## 25         TSTM WIND   INJURIES  3630
## 26      WINTER STORM   INJURIES  1298
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