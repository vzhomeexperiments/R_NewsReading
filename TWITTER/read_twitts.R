# register for developer account via https://apps.twitter.com
# obtain keys by creating an App in from https://developer.twitter.com/en/apps
# encrypt your keys using script 'encrypt_api_key.R'

library(twitteR)
library(tidyverse)

# my account
account <- "vladdsm"  #my poor twitter account
account <- "elonmusk" #more serious account

# read and move it to the dataframe format
account.timeline_df <- userTimeline(user = account, n = 20, includeRts = TRUE) %>% 
  twListToDF()

