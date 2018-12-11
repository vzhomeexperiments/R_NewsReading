# register for developer account via https://apps.twitter.com
# obtain keys by creating an App in from https://developer.twitter.com/en/apps
# encrypt your keys using script 'encrypt_api_key.R'

library(twitteR)
library(tidyverse)
source("TWITTER/decrypt_mykeys.R")
source("TWITTER/establish_twitter_connection.R")
library(tm)


# establish twitter connection: function will insure the connection
establish_twitter_connection()

# read tweets by searching hashtags
search_hash <- "tesla"

## =================================================================

# --------- get a list of tweets with searched term
tweets <- searchTwitter(searchString = search_hash,
                           n = 10000,
                           lang = "en",
                           since = NULL,
                           until = NULL) %>%
  twListToDF() 
# --------- many tweets requires filtering!
tweets_df <- tweets %>% 
                      # apply filters
                      filter(retweetCount > 10) %>% 
                      # and remove retweets! 
                      filter(isRetweet == FALSE) 

# --------- example unique and not popular tweets
tweets_df <- tweets %>% 
  # apply filters
  filter(favoriteCount == 0) %>% 
  # and remove retweets! 
  filter(isRetweet == FALSE)                     


## ==================================================================

# Building corpus

corpus <- VectorSource(tweets_df$text) %>% Corpus()
inspect(corpus[1:3])

# custom function to remove specific strings
remove_url <- function(x) gsub('https*', '', x)

# Cleaning
clean_corpus <- function(corpus){
  # place here different functions
  corpus <- tm_map(corpus, content_transformer(remove_url))
  corpus <- tm_map(corpus, tolower)
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, removeNumbers)
  corpus <- tm_map(corpus, removeWords, c('tesla', 'tsla', 'the', 'musk', 'you', 'rt', 'for', 'elon', 'model'))
  corpus <- tm_map(corpus, removeWords, stopwords('english'))
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, stripWhitespace)
  
}

corpus <- clean_corpus(corpus)
inspect(corpus[1:3])


## ==================================================================
# TDM
tdm <- TermDocumentMatrix(corpus)

tdm <- as.matrix(tdm)

#view
tdm[1:10, 1:20]

# bar plot
words_freq <- rowSums(tdm)

# only most frequent words
words_freq <- subset(words_freq, words_freq > 30)

barplot(words_freq,
        las = 2, 
        col = rainbow(50))

## ==================================================================
# wordcloud
library(wordcloud2)
wo <- sort(rowSums(tdm), decreasing = TRUE)
wo <- data.frame(names(wo), wo) 
wo <- wo[1:150, ] # to limit number of words
colnames(wo) <- c('word', 'freq')


wordcloud2(wo, size = 0.8,
           shape = 'circle')


wordcloud2(wo, size = 0.8,
           shape = 'star',
           rotateRatio = 0.5)


wordcloud2(wo, size = 0.8,
           shape = 'triangle',
           rotateRatio = 0.5)

