# register for developer account via https://apps.twitter.com
# obtain keys by creating an App in from https://developer.twitter.com/en/apps
# encrypt your keys using script 'encrypt_api_key.R'

library(twitteR)
library(openssl)
library(tidyverse)
source("TWITTER/decrypt_mykeys.R")

# private and public key path - replace paths with those of your computer
path_private_key <- file.path("C:/Users/fxtrams/.ssh", "id_api")

# Consumer API keys
ConsumerAPIkeys <- decrypt_mykeys(path_encrypted_content = "TWITTER/Keys/ConsumerAPIkeys.enc.rds",
                                  path_private_key = path_private_key)
# 
# API secret key)
APIsecretkey <- decrypt_mykeys(path_encrypted_content = "TWITTER/Keys/APIsecretkey.enc.rds",
                                  path_private_key = path_private_key)

# Access token & access token secret
Accesstoken <- decrypt_mykeys(path_encrypted_content = "TWITTER/Keys/Accesstoken.enc.rds",
                                  path_private_key = path_private_key) 
# 
# Access token secret)
Accesstokensecret <- decrypt_mykeys(path_encrypted_content = "TWITTER/Keys/Accesstokensecret.enc.rds",
                                  path_private_key = path_private_key)

# creating twitter connection using function from twitterR
setup_twitter_oauth(consumer_key = ConsumerAPIkeys,
                    consumer_secret = APIsecretkey,
                    access_token = Accesstoken,
                    access_secret = Accesstokensecret)

# my account
account <- "vladdsm"

# read and move it to the dataframe format
account.timeline_df <- userTimeline(user = account, n = 20, includeRts = TRUE) %>% 
  twListToDF()

