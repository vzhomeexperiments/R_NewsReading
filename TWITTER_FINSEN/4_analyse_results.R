# 20190208 - Analysing Twitter Sentiment Model results predicting #TeslaMotors stock

library(tidyverse)
library(lubridate)

## read files with predicted price changes
# file names
filesToAnalyse <-list.files("C:/Users/fxtrams/Documents/000_TradingRepo/R_NewsReading/TWITTER_FINSEN/Logs/",
                            pattern="predicted_at_",
                            full.names=TRUE)
# extract details from those files
for (FILE in filesToAnalyse) {
  # use tryCatch for errors
      tryCatch({
      # extract date of prediction from the file name
        #FILE <- filesToAnalyse[1]
      # remove the left part of the string
        DateTime <- str_remove(FILE, 
                               pattern = "C:/Users/fxtrams/Documents/000_TradingRepo/R_NewsReading/TWITTER_FINSEN/Logs/predicted_at_")
      # remove the right part .csv
        DateTime <- DateTime %>% str_remove(pattern = '.csv')
      # make this as date
        DateTime <- DateTime %>% ymd_hms() 
        #class(DateTime)
      
      # read content of the file
        prediction <- read_csv(file = FILE, col_types = 'd')
        
      # create a dataframe with current observation
        prediction_DF <- prediction %>% mutate(date_time = DateTime)
        
      # combine into new dataframe or bind rows if already exists
        if(!exists('df_all_predictions')){df_all_predictions <- prediction_DF} else {
          df_all_predictions <- df_all_predictions %>% bind_rows(prediction_DF)
        }
        
    }, error=function(e){cat("ERROR :",conditionMessage(e), "\n")})
}

# manipulate and visualize predictions
df1 <- df_all_predictions %>% 
  # create column with cumulative values of predictions
  mutate(pred_cumsum = cumsum(predict))

# plot results
ggplot(df1, aes(x = date_time, y = pred_cumsum)) + geom_line()

# round time of predictions to correspond to the real prices changes
# round the hours in sentiment data to match hourly values
df1_round <- df1 %>% 
  mutate(DateTimeR = round_date(df1$date_time, unit = "30 minutes")) %>% 
  # add 300 to the value for visualization purposes
  mutate(pred_simulate = pred_cumsum + 300) %>% 
  mutate(X2 = pred_simulate) %>% 
  mutate(Type_price = "predicted") %>% 
  #select only relevant columns
  select(DateTimeR, X2, Type_price) 

# get real prices

# read data for modeling
path_repository <- "C:/Users/fxtrams/Documents/000_TradingRepo/R_NewsReading/TWITTER_FINSEN"
joined_dataset <- read_rds(file.path(path_repository, "Logs/Sent_price.rds")) %>% 
  mutate(Type_price = "real") %>% 
  select(DateTimeR, X2, Type_price)

## join predicted to real prices
joined_df1 <- df1_round %>% bind_rows(joined_dataset)

# visualize together
ggplot(joined_df1, aes(x = DateTimeR, y = X2, col = Type_price))+geom_line()

# visualize at facets
ggplot(joined_df1, aes(x = DateTimeR, y = X2, col = Type_price))+
  geom_line()+
  facet_grid(Type_price ~ .)


