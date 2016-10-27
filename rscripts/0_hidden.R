# setting up twitter API
require(twitteR)

setup_twitter_oauth("ODkKP1rA44Iv8zidrvk3K3uZu", "gvb0Q6J6XS1gHdDNWoxnpRccxLfXwsXptBHkDxVMXe71y5fsb7", access_token=NULL, access_secret=NULL)

# loading packages, just so we have them

list.of.packages <- c("ggplot2", "Rcpp", "readr", "stringr", "dplyr", "tidytext",
                     "rpart", "boot", "sm", "lubridate", "rpart.plot", "dplyr", "pROC", 
                     "lmtest", "caret", "e1071", "knitr", "boot", "devtools",
                     "base", "readr", "twitteR")
  
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages,repos = 'http://cran.us.r-project.org')
  
  
lapply(list.of.packages, library, character.only = TRUE)
require(twitteR)
