require(twitteR); require(dplyr); require(tidytext); require(readr)
source("rscripts/0_hidden.R")
source("rscripts/1_get_tweets_now_func.R")
source("rscripts/2_selected_trolls.R")

# BEGIN

hrc_tweets <- get_those_tweets_meow(sample_size = 150, term = '@hillaryclinton'); hrc_time <- Sys.time()
djt_tweets <- get_those_tweets_meow(sample_size = 150, term = '@donaldtrump'); djt_time <- Sys.time()
data <- dplyr::bind_rows(hrc_tweets, djt_tweets)
write.csv(data, "outputs/data_api.csv")
x <- read.csv("outputs/data_api.csv")
x <- x %>% 
  select(screenName, text1, text2, text3, text4, text5, text6, text7, text8, text9, text10)
x$troll <- ifelse(0 == 0 , 0 , 0)
write.csv(x, "outputs/classifyme_api.csv")
rm(x)

Classify!

read.csv("outputs/classifyme_api.csv") %>%
  select(screenName, troll) %>%
  full_join(data) %>%
  write.csv('outputs/api_data_troll.csv')

