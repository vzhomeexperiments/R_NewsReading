# register for developer account via https://apps.twitter.com
# obtain keys by creating an App in from https://developer.twitter.com/en/apps
# encrypt your keys using script 'encrypt_api_key.R'

library(twitteR)
library(tidyverse)
source("TWITTER/decrypt_mykeys.R")
source("TWITTER/establish_twitter_connection.R")
source("TWITTER/get_twitter_sentiment.R")
library(syuzhet)
library(lubridate)
library(scales)
library(reshape2)

# establish twitter connection: function will insure the connection
establish_twitter_connection()

# read tweets by searching hashtags (examples)
search_hash <- "#tesla"
#search_hash <- "#ford"
#search_hash <- "#Facebook+FB"
#search_hash <- "Alibaba"
#search_hash <- "Amazon"
#search_hash <- "Nasdaq"
#search_hash <- "Greece"
#search_hash <- "Swiss"
#search_hash <- "Crypto"
#search_hash <- "GOLD"
#search_hash <- "BITCOIN"
# more terms
#search_hash <- "#tesla+$TSLA"

## =================================================================

# --------- get a list of tweets with searched term
tweets_df <- searchTwitter(searchString = search_hash,
                           n = 1500,
                           lang = "en",
                           since = NULL,
                           until = NULL) %>%
  twListToDF()

## ==================================================================

## Sentiment analysis

#obtain sentiment scores
sent_scores <- get_nrc_sentiment(tweets_df$text)
head(sent_scores)
head(tweets_df$text, 3)

#we can check sentiment of any word
# 
#get_nrc_sentiment('disaster')
#
#get_nrc_sentiment('trust')

# example President Trump innagurational speech 
# source: https://www.belfasttelegraph.co.uk/news/world-news/donald-trump-inauguration-speech-full-transcript-35386639.html

s_scores <- read_tsv("TWITTER/trump_speech2017.txt") %>%  unlist(use.names = F) %>% as.vector() %>% get_nrc_sentiment()

#bar plot
barplot(colSums(s_scores),
        las = 2, 
        col = rainbow(10),
        ylab = 'Count',
        main = paste0('Tweet Sentiment Scores Trump Speech'))



#bar plot
barplot(colSums(sent_scores),
        las = 2, 
        col = rainbow(10),
        ylab = 'Count',
        main = paste0('Tweet Sentiment Scores ', search_hash))


### Perform simple comparison Gold vs Bitcoin
# Dollar
gold_sentiment <- get_twitter_sentiment(search_term = "GOLD",
                                        n_tweets = 1500,
                                        output_df = T)
# btc
btc_sentiment <- get_twitter_sentiment(search_term = "BITCOIN",
                                        n_tweets = 1500,
                                        output_df = T)

# comparison
gold_df <- gold_sentiment %>% mutate(Asset_Name = "GOLD")
btc_df <- btc_sentiment %>% mutate(Asset_Name = "BTC")
all_df <- gold_df %>% bind_rows(btc_df) %>% 
  group_by(Asset_Name) %>% 
  summarise(s_neg = sum(negative),
            s_pos = sum(positive)) %>% 
  mutate(ratio_neg = s_neg/(s_neg + s_pos),
         ratio_pos = 1-ratio_neg) %>% 
  select(Asset_Name, ratio_neg, ratio_pos)

all_long <- melt(all_df, id.vars = "Asset_Name")

ggplot(all_long,aes(x=variable,y=value,fill=factor(Asset_Name)))+
  geom_bar(stat="identity",position="dodge")+
  scale_y_continuous(limits = c(0,1))+
  xlab("Asset")+ylab("Rate")+facet_wrap(~ Asset_Name)


