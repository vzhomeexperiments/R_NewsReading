## =============================================================================
##
## Code to esplore the idea of correlate sentiment pattern to asset price change
## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
## Use on your own risk: experimentation only!!!
## !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
##
## Part 3 - Predict price change of the asset
##
## define path of the repository
path_repository <- "C:/Users/fxtrams/Documents/000_TradingRepo/R_NewsReading/TWITTER_FINSEN"

# or use repository path if just using sample data
#path_repository <- "TWITTER_FINSEN"

library(tidyverse)
library(h2o)
source(file.path(path_repository, "Functions/predict_price_change.R"))

## =================================================================

# read data for prediction
topic_scores_last <- read_rds(file.path(path_repository, "Logs/topic_scores_last.rds"))

# initialize h2o deep learning machine
h2o.init(nthreads = 1)

# predict using the function
price_change <- predict_price_change(last_dataset = topic_scores_last,
                                     path_model = file.path(path_repository, "Model/DL_Regression"))
# shut down h2o deep learning machine
h2o.shutdown(prompt = F)

# write prediction to the file (e.g. for MT4 usage)
file_name <- paste0("predicted_at_", as.character(Sys.time()), ".csv") %>% str_replace_all(":", "-")
write_csv(price_change, file.path(path_repository, "Logs", file_name))

          