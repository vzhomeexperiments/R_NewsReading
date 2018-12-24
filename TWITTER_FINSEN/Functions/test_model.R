#' Test model function. Goal of the function is to verify how good predicted results are using trading strategy
#' It is assumed that trade is only opened and kept for the duration of 1 hour
#' 
#' 
#' @param test_dataset      Dataset containing the column 'X2' which will correspond to the real outcome
#' of Asset price change. This column will be used to verify the trading strategy
#' 
#' @param predictor_dataset  Dataset containing the column 'predict'. 
#' This column is corresponding to the predicted outcome of Asset 
#' 
#' @param trade_tax Fixed commission for every trade. Default value is very little just to test overall strategy
#' 
#' @param trigger_level Level on which trades will be opened. Can be used to filter values where predicted price change
#' is very low. Value set by default is 0, just to test overall strategy. Value must be > than 0!!!
#' 
#' @return Function will return a data frame with several quality score metrics for the model.
#'         In case quality score is positive or more than 1 the model would likely be working good.
#'         In case the score will be negative then the model is not predicting good.
#'         
#' @export
#'
#' @examples
#' 
test_model <- function(test_dataset, predictor_dataset, trigger_level = 0, trade_tax = 0.02){
  require(tidyverse)
  # arguments for debugging for regression
  #test_dataset <- read_rds("C:/Users/fxtrams/Documents/000_TradingRepo/R_NewsReading/TWITTER_FINSEN/Model/truth_res.rds")
  #predictor_dataset <- read_rds("C:/Users/fxtrams/Documents/000_TradingRepo/R_NewsReading/TWITTER_FINSEN/Model/predicted_res.rds")
  #trigger_level <- 0
  #trade_tax <- 0.02

  dat31 <- test_dataset %>% select(X2) %>% bind_cols(predictor_dataset) %>% 
    # add column risk that has +1 if buy trade and -1 if sell trade, 0 (no risk) if prediction is exact zero
    # mutate(Risk = if_else(predict > 0, 1, if_else(predict < 0, -1, 0))) %>% 
    mutate(Risk = if_else(predict > trigger_level, 1, if_else(predict < -trigger_level, -1, 0))) %>% 
    # calculate expected outcome of risking the 'Risk': trade according to prediction
    mutate(ExpectedGain = predict*Risk) %>% 
    # calculate 'real' gain or loss. X2 is how the price moved (ground truth) so the column will be real outcome
    mutate(AchievedGain = X2*Risk) %>% 
    # to account on spread
    mutate(Spread = if_else(AchievedGain > 0, -trade_tax, if_else(AchievedGain < 0, +trade_tax, 0))) %>% 
    # calculate 'net' gain
    mutate(NetGain = AchievedGain + Spread) %>% 
    # remove zero values to calculate presumed number of trades
    filter(AchievedGain != 0) %>% 
    # get the sum of both columns
    # Column Expected PNL would be the result in case all trades would be successful
    # Column Achieved PNL is the results achieved in reality
    summarise(ExpectedPnL = sum(ExpectedGain),
              AchievedPnL = sum(NetGain),
              TotalTrades = n(),
              Trigger_Level = trigger_level) %>% 
    # interpret the results
    mutate(FinalOutcome = if_else(AchievedPnL > 0, "VeryGood", "VeryBad"),
           FinalQuality = AchievedPnL/(0.0001+ExpectedPnL)) 
    

  
return(dat31)



}