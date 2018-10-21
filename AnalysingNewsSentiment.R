# Financial News reading and sentiment Analysis
# Lazy Trading Course: Read news and Sentiment Analysis
# (C) 2018 Vladimir Zhbanko
# https://www.udemy.com/forex-news-and-sentiment-analysis/?couponCode=LAZYTRADE1-10

# analysing log files
# plot the obtained average polarity scores over time

library(tidyverse)
library(lubridate)
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

ggplot(S_LOG, aes(x = day, y = ave_pol)) + geom_line()+facet_grid(country~.)+
  geom_hline(aes(yintercept = 0, col = "zero"))+
  ggtitle("Average Polarity Scores of News Headers by Country in 2018",
          "sourced from yahoo.ca, yahoo.us, yahoo.uk 3x day")

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


## ================ Trying to investigate //DRAFT// ===================
# bringing trading results to this graph
# terminal 2 path *** make sure to customize this path
path_T2 <- "C:/Program Files (x86)/FxPro - Terminal2/MQL4/Files/"

# -------------------------
# read data from trades in terminal 1
# -------------------------
DFT2 <- try(read_csv(file = file.path(path_T2, "OrdersResultsT2.csv"), 
                     col_names = c("MagicNumber", "TicketNumber", "OrderStartTime", 
                                   "OrderCloseTime", "Profit", "Symbol", "OrderType"),
                     col_types = "iiccdci"), 
            silent = TRUE)

DF1 <- DFT2 %>% 
  #filter to have only results from FALCON_S
  filter(MagicNumber >= 8136204, MagicNumber <= 8136205) %>% 
  select(MagicNumber, OrderStartTime, Profit, Symbol, OrderType)

DF1$MagicNumber <- as.factor(DF1$MagicNumber)
DF1$OrderStartTime <- ymd_hms(DF1$OrderStartTime)
DF1$Symbol <- as.factor(DF1$Symbol)
DF1$OrderType <- as.factor(DF1$OrderType)


# round the dates in both frames
df1 <- S_LOG_Diff %>% select(day, uk_us, us_ca, uk_ca) %>% 
  gather(key = pairing, difference, uk_us, us_ca, uk_ca)
df1$day <- round_date(df1$day, unit = "hour")
df1$day <- df1$day + 3600

DF1$OrderStartTime <- round_date(DF1$OrderStartTime, unit = "hour")

# rename the values to match symbol
library(plyr)


df1$pairing <-  mapvalues(df1$pairing, from = c("uk_us", "us_ca", "uk_ca"), to = c("GBPUSD", "USDCAD", "GBPCAD"))

# join
DF3 <- DF1 %>% inner_join(df1, by = c("OrderStartTime" = "day"))

library(dplyr)

df4 <- DF3 %>% filter(difference > 0.1) %>% 
  # after applying changes
  filter(OrderStartTime > "2018-04-19") %>% 
  group_by(MagicNumber) %>% 
  arrange(MagicNumber) %>% 
  summarise(pnl = sum(Profit),
            ntr = n())


