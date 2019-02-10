# 20190208 - Analysing Twitter Sentiment Model results predicting #TeslaMotors stock

library(tidyverse)
library(lubridate)


## Analyse model quality
# file names
filesToAnalyse <-list.files("C:/Users/fxtrams/Documents/000_TradingRepo/R_NewsReading/TWITTER_FINSEN/Logs/", pattern="model_quality_",
                            full.names=TRUE)
# extract details from those files
for (FILE in filesToAnalyse) {
  # use tryCatch for errors
  tryCatch({
    # extract date of prediction from the file name
    #FILE <- filesToAnalyse[1]
    # remove the left part of the string
    DateTime <- str_remove(FILE, pattern = "C:/Users/fxtrams/Documents/000_TradingRepo/R_NewsReading/TWITTER_FINSEN/Logs/model_quality_")
    # remove the right part .csv
    DateTime <- DateTime %>% str_remove(pattern = '.csv')
    # make this as date
    DateTime <- DateTime %>% ymd() 
    #class(DateTime)
    
    # read content of the file
    prediction <- read_csv(file = FILE) %>% select(AchievedPnL)
    
    # create a dataframe with current observation
    prediction_DF <- prediction %>% mutate(date_time = DateTime)
    
    # combine into new dataframe or bind rows if already exists
    if(!exists('df_all')){df_all <- prediction_DF} else {
      df_all <- df_all %>% bind_rows(prediction_DF)
    }
    
  }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
}

# can we trust this model?
if(sum(df_all$AchievedPnL) > 0) {print("We can trust!")} else {print("We can not trust! (yet?)")
                                                                     sum(df_all$AchievedPnL)}
