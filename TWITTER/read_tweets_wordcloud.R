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
search_hash <- "#microsoft"

# more terms
search_hash <- "#tesla+$TSLA"

## =================================================================

# --------- get a list of tweets with searched term
tweets_df <- searchTwitter(searchString = search_hash,
                           n = 1500,
                           lang = "en",
                           since = NULL,
                           until = NULL) %>%
  twListToDF()


# --------- get a list of tweets with searched term and specific date
tweets_df <- searchTwitter(searchString = search_hash,
                           n = 1000,
                           lang = 'en',
                           since='2017-10-25', 
                           until='2018-11-26') %>%
  twListToDF()


# --------- get a list of tweets with searched terrm and geocode
tweets_df <- searchTwitter('Davos', geocode='46.8027,9.8360,10mi',
                           n = 100) %>%
  twListToDF()



## ==================================================================

# Building corpus

corpus <- Corpus(VectorSource(tweets_df$text))
inspect(corpus[1:3])

# Cleaning
remove_url <- function(x) gsub('https*', '', x)
corpus <- tm_map(corpus, content_transformer(remove_url))
inspect(corpus[1:3])

corpus <- tm_map(corpus, tolower)
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)
clean_corpus <- tm_map(corpus, removeWords, stopwords('english'))

inspect(corpus[1:3])





inspect(corpus[1:3])

# remove specific words
corpus <- tm_map(corpus, removeWords, c('and', 'the', 'microsoft', 'you', 'for'))
clean_corpus <- tm_map(corpus, removeWords, stopwords('english'))
corpus <- tm_map(corpus, removePunctuation)

corpus <- tm_map(corpus, stripWhitespace)

# TDM
tdm <- TermDocumentMatrix(corpus)

tdm <- as.matrix(tdm)

#view
tdm[1:10, 1:20]

# bar plot
words_freq <- rowSums(tdm)

# only most frequent words
words_freq <- subset(words_freq, words_freq > 20)

barplot(words_freq,
        las = 2, 
        col = rainbow(50))

# wordcloud


wo <- sort(rowSums(tdm), decreasing = TRUE)



library(wordcloud2)

wo <- data.frame(names(wo), wo)

colnames(wo) <- c('word', 'freq')


wordcloud2(wo, size = 0.8,
           shape = 'circle')


wordcloud2(wo, size = 0.8,
           shape = 'star',
           rotateRatio = 0.5)


wordcloud2(wo, size = 0.8,
           shape = 'triangle',
           rotateRatio = 0.5)



wordcloud2(wo, size = 0.8,
           shape = 'A',
           rotateRatio = 0.5)


