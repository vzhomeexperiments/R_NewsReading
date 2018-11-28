# register for developer account via https://apps.twitter.com
# obtain keys by creating an App in from https://developer.twitter.com/en/apps
# encrypt your keys using script 'encrypt_api_key.R'

library(twitteR)
library(tidyverse)
source("TWITTER/decrypt_mykeys.R")
source("TWITTER/establish_twitter_connection.R")
library(qdap)
library(magrittr)

# establish twitter connection: function will insure the connection
establish_twitter_connection()

# read tweets by searching hashtags
search_hash <- "#tesla"

# get a list of tweets with searched term
tweets_df <- searchTwitter(searchString = search_hash,
                           n = 1500,
                           lang = "en",
                           since = NULL,
                           until = NULL) %>%
  twListToDF()

# Building corpus
library(tm)

corpus <- Corpus(VectorSource(tweets_df$text))
inspect(corpus[1:3])

# Cleaning
corpus <- tm_map(corpus, tolower)
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)
clean_corpus <- tm_map(corpus, removeWords, stopwords('english'))

inspect(corpus[1:3])

remove_url <- function(x) gsub('http[[:alnum:]]*', '', x)

clean_corpus <- tm_map(clean_corpus, content_transformer(remove_url))

inspect(corpus[1:3])

# remove specific words
clean_corpus <- tm_map(clean_corpus, removeWords, c('tesla', 'elonmusk'))

clean_corpus <- tm_map(clean_corpus, stripWhitespace)

# TDM
tdm <- TermDocumentMatrix(clean_corpus)

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
library(wordcloud)

wo <- sort(rowSums(tdm), decreasing = TRUE)

wordcloud(words = names(wo),
          freq = wo,
          max.words = 150,
          min.freq = 5,
          random.order = F,
          colors = brewer.pal(8, 'Dark2'),
          scale = c(7, 0.3),
          rot.per = 0.7)

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


## Sentiment analysis
library(syuzhet)
library(lubridate)
library(scales)
library(reshape2)
library(tidyverse)

#obtain setniment scorres
sent_scores <- get_nrc_sentiment(tweets_df$text)
head(sent_scores)

#we can check sentiment of any word
get_nrc_sentiment('disaster')

get_nrc_sentiment('trust')

#bar plot
barplot(colSums(sent_scores),
        las = 2, 
        col = rainbow(10),
        ylab = 'Count',
        main = 'Tweet')

