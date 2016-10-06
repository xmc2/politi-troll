require(twitteR); require(dplyr); require(tidytext)
source("rscripts/hidden.R")
source("rscripts/get_tweets_now_func.R")
source("rscripts/selected_trolls.R")

# BEGIN

hrc_tweets <- get_those_tweets_meow(sample_size = 150, term = '@hillaryclinton'); hrc_time <- Sys.time()
djt_tweets <- get_those_tweets_meow(sample_size = 150, term = '@donaldtrump'); djt_time <- Sys.time()
data <- dplyr::bind_rows(hrc_tweets, djt_tweets)
write.csv(data, "outputs/data2.csv")
x <- read.csv("outputs/data2.csv")
x <- x %>% select(screenName, text1, text2, text3, text4, text5, text6, text7, text8, text9, text10)
write.csv(x, "outputs/classifyme.csv")
rm(x)
# END


#####
##### Hand harvested trolls
#####
#####
#####
#####

existing_trolls <- select(read.csv("outputs/selected_trolls.csv"), -X)

user_names <- c()

x <- trolls(user_names)
x$created <- as.character(x$created)
updated_troll <-  rbind(x, existing_trolls)

write.csv(updated_troll, "outputs/selected_trolls.csv")
classify2 <- updated_troll %>% 
        select(screenName, text1, text2, text3, text4, text5, text6, text7, text8, text9, text10) 
write.csv(classify2, "outputs/classify2.csv")


#####
##### Hand classifying 
#####
#####
#####
#####

# hand classify by hand
round1 <- read.csv("outputs/classifyme.csv") %>%
        select(-X, -X.1) %>%
        select(screenName, Troll)
round2 <- read.csv("outputs/to_classify.csv") %>%
        select(-X, -X.1) %>%
        select(screenName, Troll)
round3 <- read.csv("outputs/classify_3.csv") %>%
        select(-X) %>%
        select(screenName, Troll)
classified <- rbind(round1, round2) %>% rbind(round3)


