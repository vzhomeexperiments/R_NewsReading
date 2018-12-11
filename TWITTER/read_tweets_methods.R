# register for developer account via https://apps.twitter.com
# obtain keys by creating an App in from https://developer.twitter.com/en/apps
# encrypt your keys using script 'encrypt_api_key.R'

library(twitteR)
library(tidyverse)
source("TWITTER/decrypt_mykeys.R")
source("TWITTER/establish_twitter_connection.R")

# establish twitter connection: function will insure the connection
establish_twitter_connection()

# read tweets by searching hashtags (examples)
search_hash <- "#tesla"
search_hash <- "#Facebook+FB"
search_hash <- "Coca Cola"
search_hash <- "Pepsi"
search_hash <- "Alibaba"
search_hash <- "Amazon"
search_hash <- "Nasdaq"
search_hash <- "Greece"
search_hash <- "Swiss"
search_hash <- "Crypto"
# more terms
search_hash <- "#tesla+$TSLA"

## =================================================================

# --------- get a list of tweets with searched term
tweets_df <- searchTwitter(searchString = search_hash,
                           n = 1500,
                           #lang = "en",
                           since = NULL,
                           until = NULL) %>%
  twListToDF() 

#tweets_df_noretweet <- tweets_df %>% filter()

# --------- get a list of tweets with searched term and specific date
tweets_df <- searchTwitter(searchString = "#tesla+$TSLA",
                           n = 5000,
                           lang = 'en',
                           since='2018-11-25', 
                           until='2018-12-11') %>%
  twListToDF()

# searching in the past [requires premium subscription]. 
# Standard subscription is 7 days only see: https://developer.twitter.com/en/pricing
tweets_df <- searchTwitter(searchString = "#tesla",
                           n = 5000,
                           lang = 'en',
                           since='2017-05-25', 
                           until='2017-11-25') %>%
  twListToDF()


# --------- get a list of tweets with searched terrm and geocode
tweets_df <- searchTwitter(searchString = 'wef',
                           geocode='46.8027,9.8360,10mi',
                           n = 100) %>%
  twListToDF()

# --------- get a list of tweets with searched terrm and geocode
tweets_df <- searchTwitter(searchString = 'tesla',
                           geocode='35.6895,139.6917,10mi',
                           n = 100) %>%
  twListToDF() #%>% write_csv("TWITTER/TeslaTokyo.csv")

## ==================================================================

