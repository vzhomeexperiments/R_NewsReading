# Financial News reading and sentiment Analysis
# Lazy Trading Course: Read news and Sentiment Analysis
# (C) 2018,2022 Vladimir Zhbanko
# https://www.udemy.com/course/forex-news-and-sentiment-analysis/?referralCode=2B76F54F1D33CF06B79C

# 2022.07.18 using SentimentAnalysis
# https://cran.r-project.org/web/packages/SentimentAnalysis/vignettes/SentimentAnalysis.html

# Purpose: Read headers of the yahoo news and perform their sentiment analysis

# libraries
library(rvest)
library(SentimentAnalysis)
library(SnowballC)
library(magrittr)
#library(openssl)
# you should also: install.packages("openssl")

# url of websites (choose your own) and variables
urlUS <- "https://www.yahoo.com/news/us/"
urlCA <- "https://ca.news.yahoo.com/canada/"
urlGB <- "https://uk.news.yahoo.com/uk/"
pairs <- c("USDCAD", "GBPCAD", "GBPUSD")

#absolute path with the data (choose MT4 directory where files are generated)
path_terminal <- normalizePath(Sys.getenv('PATH_T1'), winslash = '/')

#path to user repo:
path_repo <- normalizePath(Sys.getenv('PATH_DSS_Repo'), winslash = '/')

#path with the data
path_data <- file.path(path_repo, "R_NewsReading","log")

# check if the directory exists or create
if(!dir.exists(path_data)){dir.create(path_data)}

# get the headers into the vectors
heads_US <- urlUS %>% read_html() %>% html_nodes("h3") %>% html_text()
heads_CA <- urlCA %>% read_html() %>% html_nodes("h3") %>% html_text()
heads_UK <- urlGB %>% read_html() %>% html_nodes("h3") %>% html_text()

# get the polarity scores
pol_US <- heads_US %>% analyzeSentiment()
pol_CA <- heads_CA %>% analyzeSentiment() 
#plotSentimentResponse(pol_CA$SentimentQDAP, pol_CA$WordCount)

pol_UK <- heads_UK %>% analyzeSentiment()

# extract average values
ave_US <- pol_US$SentimentQDAP %>% mean()
ave_CA <- pol_CA$SentimentQDAP %>% mean()
ave_UK <- pol_UK$SentimentQDAP %>% mean()

table(ave_US, ave_CA, ave_UK)
# summary
summmary_df <- data.frame(day = Sys.time(),
                          country = c('US', 'CA', 'UK'),
                          ave_pol = c(ave_US, ave_CA, ave_UK))

# hash of the time
id_hash <- Sys.time() %>% as.character.POSIXt() %>% openssl::sha1() %>% substr(1, 4)

# write the log
write.csv(summmary_df,
          paste0(file.path(path_repo, "R_NewsReading/log/s_log-"),
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


# decisions writing to the sandbox
write_news_sentiment_decision("GBPUSD", ave_UK, ave_US, 0.1, path_terminal)
write_news_sentiment_decision("USDCAD", ave_US, ave_CA, 0.1, path_terminal) 
write_news_sentiment_decision("GBPCAD", ave_UK, ave_CA, 0.1, path_terminal) 

# Result: DSS generates the file in the Sandbox. This file will be used in MQL by the Trading System

