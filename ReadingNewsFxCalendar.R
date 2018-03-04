# Forex News Reading from R and limit the tradings
# Lazy Trading Course: Read news and Sentiment Analysis
# (C) 2018 Vladimir Zhbanko
# https:/www.udemy.com/draft/1482436/?couponCode=LAZYTRADE5-20


# load libraries
library(rvest)
library(lubridate)
library(readxl)
library(stringr)

# summary of actions
# import events list subjected to trade restrictions from xls file
# get url data columns
# create data frame

# read restricted news events as strings
restrictedEvents <- read_excel("C:/Users/fxtrams/Documents/000_TradingRepo/R_NewsReading/RestrictedEvents.xlsx",
                               col_names = F)

# get url to access the data. URL shall be like this: "http://www.forexfactory.com/calendar.php?day=dec2.2016"
url <- paste("http://www.forexfactory.com/calendar.php?day=",
             month(Sys.Date(), label = TRUE),
             day(Sys.Date()), ".",
             year(Sys.Date()), sep = "")

# TEST URL
#url <- "http://www.forexfactory.com/calendar.php?day=dec12.2016"

# get the raw data from web
fxcal <- url %>% read_html() 

# get the currency column for the day
currency <- fxcal %>% html_nodes(".currency") %>% html_text()

# get the event info for the day
event <- fxcal %>% html_nodes(".calendar__event-title") %>% html_text()

# create data frame
todaysEvents <- data.frame(currency, event, stringsAsFactors = FALSE) #%>% View()

# add new column in this frame
todaysEvents$trading <- 1
flag <- 0

# scrol through the data frame todaysEvents and match the strings to content of the event column,
# if match is found write to new column "0" that will be interpreted as a NO trade
for (j in 1:nrow(restrictedEvents))
  {
    
    matchingterm <- restrictedEvents[j, ] 
    matchingterm.v <- matchingterm$X__1
    
    for(i in 1:nrow(todaysEvents))
        {
          
          if(str_detect(todaysEvents[i, 2], matchingterm.v) == TRUE) 
             {
                todaysEvents[i, 3] <- 0
                flag <- 1
                break
             }
      
        }
}

# write the results of the all events (for user control purposes)
write.csv(todaysEvents, paste("C:/Users/fxtrams/Documents/000_TradingRepo/R_NewsReading/log/log-", Sys.Date(), ".csv", sep = ""))

# write obtained dataframe to all terminals!
#Terminal 1
write.csv(flag, "C:/Program Files (x86)/FxPro - Terminal1/MQL4/Files/01_MacroeconomicEvent.csv", row.names = F)
#Terminal 2
write.csv(flag, "C:/Program Files (x86)/FxPro - Terminal2/MQL4/Files/01_MacroeconomicEvent.csv", row.names = F)
#Terminal 3
write.csv(flag, "C:/Program Files (x86)/FxPro - Terminal3/MQL4/Files/01_MacroeconomicEvent.csv", row.names = F)
#Terminal 4
write.csv(flag, "C:/Program Files (x86)/FxPro - Terminal4/MQL4/Files/01_MacroeconomicEvent.csv", row.names = F)
































