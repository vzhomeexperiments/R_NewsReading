## =============================================================================
##
## Code to esplore the idea of correlate sentiment pattern to asset price change
## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
## Use on your own risk: experimentation only!!!
## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
##
## Part 2 - Train deep learning model using sentiment pattern and known price change
##
## define path of the repository
path_repository <- "C:/Users/fxtrams/Documents/000_TradingRepo/R_NewsReading/TWITTER_FINSEN"

# or use repository path if just using sample data
#path_repository <- "TWITTER_FINSEN"

library(tidyverse)
library(h2o)
source(file.path(path_repository, "Functions/train_sentiment_model.R"))

## =================================================================

# read data for modeling
joined_dataset <- read_rds(file.path(path_repository, "Logs/Sent_price.rds"))

# path to the model
path_model <- file.path(path_repository, "Model")

# initialize h2o deep learning machine
h2o.init()

# train deep learning model using function
train_sentiment_model(joined_dataset, path_model)

# shut down h2o deep learning machine
h2o.shutdown(prompt = F)
