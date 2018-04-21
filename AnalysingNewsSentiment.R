# Financial News reading and sentiment Analysis
# Lazy Trading Course: Read news and Sentiment Analysis
# (C) 2018 Vladimir Zhbanko
# https://www.udemy.com/forex-news-and-sentiment-analysis/?couponCode=LAZYTRADE1-10

# analysing log files
# plot the obtained average polarity scores over time

library(tidyverse)
# create list of files
filesToAdd <-list.files("C:/Users/fxtrams/Documents/000_TradingRepo/R_NewsReading/log", pattern="s_log", full.names=TRUE)

# read one file
read_csv(filesToAdd[1])

# we read each file and add content to one dataframe S_LOG
for (FILE in filesToAdd) {
  if(!exists("S_LOG")){
    S_LOG <- read_csv(FILE)
  } else {
    S_LOG <- read_csv(FILE) %>% bind_rows(S_LOG)
  }
}

# plot it
ggplot(S_LOG, aes(x = day, y = ave_pol)) + geom_line()+facet_grid(~country)+
  geom_hline(aes(yintercept = 0, col = "zero"))

# some data manipulation?
S_LOG_W <- spread(S_LOG, key = country, value = ave_pol)

# relationship between values
ggplot(S_LOG_W, aes(CA, US))+geom_point()
ggplot(S_LOG_W, aes(UK, CA))+geom_point()
ggplot(S_LOG_W, aes(UK, US))+geom_point()

# absolute difference between values
S_LOG_Diff <- S_LOG_W %>% mutate(uk_us = abs(abs(UK)- abs(US)),
                                 us_ca = abs(abs(US)- abs(CA)),
                                 uk_ca = abs(abs(UK)- abs(CA)))

# make it long and plot it then see changed treshold value 2018-04-19
S_LOG_Diff %>% select(day, uk_us, us_ca, uk_ca) %>% 
  gather(key = pairing, difference, uk_us, us_ca, uk_ca) %>% 
  ggplot(aes(day, difference))+geom_line()+
  facet_grid(~pairing)+
  geom_hline(aes(yintercept = 0.02, col = "before"))+
  geom_hline(aes(yintercept = 0.1, col = "after"))

