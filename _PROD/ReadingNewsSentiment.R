# Financial News reading and sentiment Analysis
# Lazy Trading Course: Read news and Sentiment Analysis
# (C) 2018 Vladimir Zhbanko
# https://www.udemy.com/forex-news-and-sentiment-analysis/?couponCode=LAZYTRADE1-10

# Purpose: Read headers of the yahoo news and perform their sentiment analysis

# libraries
library(rvest)
library(qdap)
# you should also: install.packages("openssl")

# url of websites (choose your own) and variables
urlUS <- "https://www.yahoo.com/news/us/"
urlCA <- "https://ca.news.yahoo.com/canada/"
urlGB <- "https://uk.news.yahoo.com/uk/"
pairs <- c("USDCAD", "GBPCAD", "GBPUSD")

# get the headers into the vectors
heads_US <- urlUS %>% read_html() %>% html_nodes("h3") %>% html_text()
heads_CA <- urlCA %>% read_html() %>% html_nodes("h3") %>% html_text()
heads_UK <- urlGB %>% read_html() %>% html_nodes("h3") %>% html_text()

# get the polarity scores
pol_US <- heads_US %>% qdap::polarity() #plot(pol_US)
pol_CA <- heads_CA %>% qdap::polarity() #plot(pol_CA)
pol_UK <- heads_UK %>% qdap::polarity() #plot(pol_UK)

# extract average values
ave_US <- pol_US$group$ave.polarity
ave_CA <- pol_CA$group$ave.polarity
ave_UK <- pol_UK$group$ave.polarity

table(ave_US, ave_CA, ave_UK)
# summary
summmary_df <- data.frame(day = Sys.time(),
                          country = c('US', 'CA', 'UK'),
                          ave_pol = c(ave_US, ave_CA, ave_UK))

# hash of the time
id_hash <- Sys.time() %>% as.character.POSIXt() %>% openssl::sha1() %>% substr(1, 4)

# write the log
write.csv(summmary_df,
          paste0("C:/Users/fxtrams/Documents/000_TradingRepo/R_NewsReading/log/s_log-",
                 Sys.Date(), "-", id_hash, ".csv"),
          row.names = F)

# decision function
write_news_sentiment_decision <- function(pair_string, 
                                          base_curr_polarity,
                                          quot_curr_polarity,
                                          diff_thresh,
                                          sand_box_path){
  # evaluate direction (0 - buy, 1 - sell, -1 - do nothing)
  # pair_string <- "GBPUSD"
  # base_curr_polarity <- ave_UK
  # quot_curr_polarity <- ave_US
  # diff_thresh <- 0.02
  # sand_box_path <- getwd()
  if(base_curr_polarity > quot_curr_polarity) flag <- 0 #buy
  if(base_curr_polarity < quot_curr_polarity) flag <- 1
  # evaluate difference (too little will mean no effect)
  if(abs(abs(base_curr_polarity)- abs(quot_curr_polarity)) < diff_thresh) flag <- -1
  # write to the file
  write.csv(flag, paste0(sand_box_path, "/Sentiment_", pair_string, ".csv"),row.names = F)
}

# # decisions test (writing to the working directory)
# write_news_sentiment_decision("GBPUSD", ave_UK, ave_US, 0.02, getwd())
# write_news_sentiment_decision("USDCAD", ave_US, ave_CA, 0.02, getwd()) 
# write_news_sentiment_decision("GBPCAD", ave_UK, ave_CA, 0.02, getwd()) 

# decision to write in the sandbox of Terminal 2
path_T2 <- "C:/Program Files (x86)/FxPro - Terminal2/MQL4/Files"

# decisions writing to the sandbox
write_news_sentiment_decision("GBPUSD", ave_UK, ave_US, 0.1, path_T2)
write_news_sentiment_decision("USDCAD", ave_US, ave_CA, 0.1, path_T2) 
write_news_sentiment_decision("GBPCAD", ave_UK, ave_CA, 0.1, path_T2) 

# Result: DSS generates the file in the Sandbox. This file will be used in MQL by the Trading System

































