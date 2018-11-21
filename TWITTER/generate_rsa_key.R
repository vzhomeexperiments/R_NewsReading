# generate rsa keys and store them locally on computer
# for more info on how to use RSA cryptography in R check my course
# https://www.udemy.com/keep-your-secrets-under-control/?couponCode=CRYPTOGRAPHY-GIT

# Generate your private key and write it to the folder,
# we assume you will save it to the folder C:/Users/UserName/.ssh/ mac users can adapt the path...

# if necessary install package
# install.packages("openssl"); install.packages("tidyverse")
# loads library open ssl and tidyverse
library(openssl)
library(tidyverse)

# private and public key path (adapt path for your computer)
path_private_key <- file.path("C:/Users/fxtrams/.ssh", "id_api")
path_public_key <- file.path("C:/Users/fxtrams/.ssh", "id_api.pub")

# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
### KNOW WHAT YOU DOING!!! DO NOT RUN THIS CODE UNNECESARRILY! IT WILL OVERWRITE YOUR KEYS!!!
### KNOW WHAT YOU DOING!!! DO NOT RUN THIS CODE UNNECESARRILY! IT WILL OVERWRITE YOUR KEYS!!!
# generate private key (feel free to customize bits lenght!)
rsa_keygen(bits = 5555) %>% write_pem(path = path_private_key)
# extract and write your public key
read_key(file = path_private_key, password = "") %>% `[[`("pubkey") %>% write_pem(path_public_key)
### KNOW WHAT YOU DOING!!! DO NOT RUN THIS CODE UNNECESARRILY! IT WILL OVERWRITE YOUR KEYS!!!
### KNOW WHAT YOU DOING!!! DO NOT RUN THIS CODE UNNECESARRILY! IT WILL OVERWRITE YOUR KEYS!!!
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!