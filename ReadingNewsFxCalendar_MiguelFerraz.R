# Forex News Reading from R and limit the tradings

# load libraries
library(rvest) # package for web scrapping
library(lubridate)
library(tidyverse)
library(stringr)
library(magrittr)

# summary of actions
# import events list subjected to trade restrictions from xls file
# get url data columns
# create data frame

# read restricted news events as strings
restrictedEvents <- read.csv("C:/Users/fxtrams/Documents/000_TradingRepo/R_NewsReading/RestrictedEvents.csv",
                             header = F)

# get url to access the data. URL shall be like this: "https://www.forexfactory.com/calendar?day=dec2.2016"

#http://www.forexfactory.com/calendar?day=
url <- paste("https://www.forexfactory.com/calendar?day=",
             month(Sys.Date(), label = TRUE),
             day(Sys.Date()), ".",
             year(Sys.Date()), sep = "")


# TEST URL
#url <- "http://www.forexfactory.com/calendar?day=dec6.2019"

# get the raw data from web
fxcal <- url %>% read_html() 

# get the currency column for the day
currency <- fxcal %>% html_nodes(".currency") %>% html_text()

# get the event info for the day
event <- fxcal %>% html_nodes(".calendar__event-title") %>% html_text()


# # get the event time
# time <- fxcal %>% html_nodes(".time") %>% html_text()
# 
# # get the event impact for the day
# impact <- fxcal %>% html_nodes(".calendar__impact-icon--screen") %>% html_text()

# Join previous info in data frame
todaysEvents <- data.frame( currency, event, stringsAsFactors = FALSE) #%>% View()

# add new column in this frame
todaysEvents$trading <- 1


currencyL = c("AUD", "CAD", "EUR", "USD", "NZD", "CHF", "JPY")
flag <- 0

MacroEcoControlList <- data.frame(currencyL, flag, stringsAsFactors = FALSE)


  
# scrol through the data frame todaysEvents and match the strings to content of the event column,
# if match is found write to new column "0" that will be interpreted as a NO trade
for (j in 1:nrow(restrictedEvents))
{# j <- 1
  matchingterm <- restrictedEvents[j, 1] 
  
  for(i in 1:nrow(todaysEvents))
  {# i <- 1
    if(str_detect(todaysEvents[i, 2], matchingterm) == TRUE) 
    {
     for(f in 1:nrow(MacroEcoControlList))
      if( str_detect( todaysEvents[i, 1], MacroEcoControlList[f,1] )==TRUE )
      {# f <- 1
        if(MacroEcoControlList[f,2] == 0)
        {
          todaysEvents[i, 3] <- 0
          # when flag is 1 then no trading as macroeconomic event is detected
          MacroEcoControlList[f,2] <- 1
          break
        }
      }
    }
    
  }
}



# write the results of the all events (for user control purposes)
write.csv(todaysEvents, paste("C:/Users/fxtrams/Documents/000_TradingRepo/R_NewsReading/log/log-", Sys.Date(), ".csv", sep = ""))

# write obtained dataframe to all terminals!
#Terminal 1
write.table(MacroEcoControlList, "C:/Program Files (x86)/FxPro - Terminal1/MQL4/Files/02_MacroeconomicEvent.csv", sep=",", row.names = F,  col.names=F)
#Terminal 2
write.table(MacroEcoControlList, "C:/Program Files (x86)/FxPro - Terminal2/MQL4/Files/02_MacroeconomicEvent.csv", sep=",", row.names = F,  col.names=F)
#Terminal 3
write.table(MacroEcoControlList, "C:/Program Files (x86)/FxPro - Terminal3/MQL4/Files/02_MacroeconomicEvent.csv", sep=",", row.names = F,  col.names=F)
#Terminal 4
write.table(MacroEcoControlList, "C:/Program Files (x86)/FxPro - Terminal4/MQL4/Files/02_MacroeconomicEvent.csv", sep=",", row.names = F,  col.names=F)
































