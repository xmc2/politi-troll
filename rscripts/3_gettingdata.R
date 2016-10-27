require(twitteR); require(dplyr); require(tidytext); require(readr)
source("rscripts/hidden.R")
source("rscripts/get_tweets_now_func.R")
source("rscripts/selected_trolls.R")

# BEGIN

hrc_tweets <- get_those_tweets_meow(sample_size = 150, term = '@hillaryclinton'); hrc_time <- Sys.time()
djt_tweets <- get_those_tweets_meow(sample_size = 150, term = '@donaldtrump'); djt_time <- Sys.time()
data <- dplyr::bind_rows(hrc_tweets, djt_tweets)
write.csv(data, "outputs/data2.csv")
x <- read.csv("outputs/data2.csv")
x <- x %>% 
  select(screenName, text1, text2, text3, text4, text5, text6, text7, text8, text9, text10)
write.csv(x, "outputs/classifyme1.csv")
rm(x)
# END
# 
# 
# #####
# ##### Hand harvested trolls
# #####
# #####
# #####
# 
# #####

existing_trolls <- select(read.csv("outputs/selected_trolls.csv"), -X)



