# Financial News reading and sentiment Analysis
# Lazy Trading Course: Read news and Sentiment Analysis
# (C) 2018 Vladimir Zhbanko
# https://www.udemy.com/draft/1482436/?couponCode=LAZYTRADE5-20

# libraries
library(rvest)
library(qdap)

# url of websites (choose your own)
urlUS <- "https://www.yahoo.com/news/us/"
urlCA <- "https://ca.news.yahoo.com/canada/"
urlGB <- "https://uk.news.yahoo.com/uk/"
pairs <- c("USDCAD", "GBPCAD", "GBPUSD")

# get the raw data from web
USD <- urlUS %>% read_html() 
CAD <- urlCA %>% read_html()
GBP <- urlGB %>% read_html()

# get the headers into the vectors
heads_US <- USD %>% html_nodes("h3") %>% html_text()
heads_CA <- CAD %>% html_nodes("h3") %>% html_text()
heads_UK <- GBP %>% html_nodes("h3") %>% html_text()

# get the polarity scores
pol_US <- heads_US %>% c() %>% polarity()
pol_CA <- heads_CA %>% c() %>% polarity()
pol_UK <- heads_UK %>% c() %>% polarity()

# extract average values
ave_US <- pol_US$group$ave.polarity
ave_CA <- pol_CA$group$ave.polarity
ave_UK <- pol_UK$group$ave.polarity

# decision function
decision <- function(pair, based, quoted, diff, sb_path){
  # evaluate direction (0 - buy, 1 - sell)
  if(based > quoted) flag <- 0
  if(quoted < based) flag <- 1
  # evaluate difference (too little will mean no effect)
  if(abs(abs(based)- abs(quoted) > diff)) flag <- -1
  # write to the file
  write.csv(flag, paste0(sb_path, "/", pair, ".csv"))
}

# decisions
decision("GBPUSD", ave_UK, ave_US, 0.02, getwd())
decision("USDCAD", ave_UK, ave_US, 0.02, getwd()) #sell
decision("GBPCAD", ave_UK, ave_US, 0.02, getwd()) # 
