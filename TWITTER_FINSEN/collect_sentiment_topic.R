## =============================================================================
##
## Code to esplore the idea of correlate sentiment pattern to asset price change
## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
## Use on your own risk: experimentation only!!!
## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
##
## Part 1 - Collect Sentiment Data for a Topic
##
# register for developer account via https://apps.twitter.com
# obtain keys by creating an App in from https://developer.twitter.com/en/apps
# encrypt your keys using script 'encrypt_api_key.R'

library(twitteR)
library(tidyverse)
source("C:/Users/fxtrams/Documents/000_TradingRepo/R_NewsReading/TWITTER_FINSEN/Functions/decrypt_mykeys.R")
source("C:/Users/fxtrams/Documents/000_TradingRepo/R_NewsReading/TWITTER_FINSEN/Functions/establish_twitter_connection.R")
source("C:/Users/fxtrams/Documents/000_TradingRepo/R_NewsReading/TWITTER_FINSEN/Functions/get_twitter_sentiment.R")
library(syuzhet)
library(lubridate)
library(scales)
library(reshape2)

# establish twitter connection: function will insure the connection
establish_twitter_connection(path_encrypted_keys = "C:/Users/fxtrams/Documents/000_TradingRepo/R_NewsReading/TWITTER_FINSEN/Keys",
                             path_private_key = file.path("C:/Users/fxtrams/.ssh", "id_api"))


## =================================================================

# Get sentiment summary of the topic
topic_sentiment <- get_twitter_sentiment(search_term = "#tesla",
                                         n_tweets = 3000,
                                         output_df = T)

# calculate vector of latest scores
latest_scores <- colSums(topic_sentiment)

# convert to dataframe
topic_scores <- latest_scores %>% as.list() %>% as.data.frame() %>% 
  # collect the date
  mutate(DateTime = Sys.time() %>% as.character())

# write file to the log object
if(!dir.exists("C:/Users/fxtrams/Documents/000_TradingRepo/R_NewsReading/TWITTER_FINSEN/Logs")){
    dir.create("C:/Users/fxtrams/Documents/000_TradingRepo/R_NewsReading/TWITTER_FINSEN/Logs")
  }

# append new record to the data base
if(!file.exists("C:/Users/fxtrams/Documents/000_TradingRepo/R_NewsReading/TWITTER_FINSEN/Logs/Sent.rds")){
  write_rds(topic_scores, "C:/Users/fxtrams/Documents/000_TradingRepo/R_NewsReading/TWITTER_FINSEN/Logs/Sent.rds")
} else {
  read_rds("C:/Users/fxtrams/Documents/000_TradingRepo/R_NewsReading/TWITTER_FINSEN/Logs/Sent.rds") %>% 
    bind_rows(topic_scores) %>% 
    write_rds("C:/Users/fxtrams/Documents/000_TradingRepo/R_NewsReading/TWITTER_FINSEN/Logs/Sent.rds")
}

debug <- read_rds("C:/Users/fxtrams/Documents/000_TradingRepo/R_NewsReading/TWITTER_FINSEN/Logs/Sent.rds")
## ==================================================================

## Price data of the asset
path_price <- "C:/Program Files (x86)/FxPro - Terminal2/MQL4/Files/AI_CP60-333.csv"
topic_price <- read_csv(path_price,col_names = F)
# convert to time format 
topic_price$X1 <- ymd_hms(topic_price$X1)
# same for sentiment data
debug$DateTime <- ymd_hms(debug$DateTime)

# round the hours in sentiment data to match hourly values
debug_round <- debug %>% 
  mutate(DateTimeR = round_date(debug$DateTime, unit = "30 minutes")) %>% 
  # add 1 hour to the column DateTimeR
  mutate(DateTimePlus1h = DateTimeR + 3600) 
  
# joined data: sentiment values with price values. NB: time is 'aligned' by Broker Server Time!
sent_price_joined <- debug_round %>% inner_join(topic_price, by = c("DateTimePlus1h" = "X1"))

## ====================================================================

# TDL: Shift data -> train regression model -> etc

