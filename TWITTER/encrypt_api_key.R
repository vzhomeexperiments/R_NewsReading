# encrypt api key
# for more info on how to use RSA cryptography in R check my course
# https://www.udemy.com/keep-your-secrets-under-control/?couponCode=CRYPTOGRAPHY-GIT

# encrypt my key (I am showing my API key because I will delete it anyhow after creating the course)
library(openssl)
library(tidyverse)

# private and public key path - replace paths with those of your computer
path_private_key <- file.path("C:/Users/fxtrams/.ssh", "id_api")
path_public_key <- file.path("C:/Users/fxtrams/.ssh", "id_api.pub")
if(!dir.exists("TWITTER/Keys")) {dir.create("TWITTER/Keys")}

## Encrypt with your public key - replace with your API key
## KEYS ARE PROVIDED FOR EXAMPLE ONLY ##
# -----
# Consumer API keys
# eGzXFHgw5UsOJcZMSiEvtJiw5 (API key)

"eGzXFHgw5UsOJcZMSiEvtJiw5" %>% 
  # serialize the object
  serialize(connection = NULL) %>% 
  # encrypt the object
  encrypt_envelope(path_public_key) %>% 
  # write encrypted data to File to your working directory
  write_rds("TWITTER/Keys/ConsumerAPIkeys.enc.rds")

# -----
# pG6fim4QRaP8BALY2ogMgplTkAXlxPzlgmnrREvqtGXaCrENZ6 (API secret key)

"pG6fim4QRaP8BALY2ogMgplTkAXlxPzlgmnrREvqtGXaCrENZ6" %>% 
  # serialize the object
  serialize(connection = NULL) %>% 
  # encrypt the object
  encrypt_envelope(path_public_key) %>% 
  # write encrypted data to File to your working directory
  write_rds("TWITTER/Keys/APIsecretkey.enc.rds")

# -----
# Access token & access token secret
# 925743196264640512-twrNoJOYSjDaxwRLxUm510ugFf4DySs (Access token)

"925743196264640512-twrNoJOYSjDaxwRLxUm510ugFf4DySs" %>% 
  # serialize the object
  serialize(connection = NULL) %>% 
  # encrypt the object
  encrypt_envelope(path_public_key) %>% 
  # write encrypted data to File to your working directory
  write_rds("TWITTER/Keys/Accesstoken.enc.rds")

# -----
# bW4kDHX3PrS4tXJIl8CMkDTkL9gROpRtnxbyFAeFCsvha (Access token secret)

"bW4kDHX3PrS4tXJIl8CMkDTkL9gROpRtnxbyFAeFCsvha" %>% 
  # serialize the object
  serialize(connection = NULL) %>% 
  # encrypt the object
  encrypt_envelope(path_public_key) %>% 
  # write encrypted data to File to your working directory
  write_rds("TWITTER/Keys/Accesstokensecret.enc.rds")