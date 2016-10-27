require(twitteR); require(dplyr); require(tidytext); require(readr)
source("rscripts/0_hidden.R")
source("rscripts/1_get_tweets_now_func.R")
source("rscripts/2_selected_trolls.R")

# BEGIN

hrc_tweets <- get_those_tweets_meow(sample_size = 150, term = '@hillaryclinton'); hrc_time <- Sys.time()
djt_tweets <- get_those_tweets_meow(sample_size = 150, term = '@donaldtrump'); djt_time <- Sys.time()
data <- dplyr::bind_rows(hrc_tweets, djt_tweets)
write.csv(data, "outputs/data1.csv")
x <- read.csv("outputs/data1.csv")
x <- x %>% 
  select(screenName, text1, text2, text3, text4, text5, text6, text7, text8, text9, text10)
write.csv(x, "outputs/classifyme.csv")
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



