list.of.packages <- c("ggplot2", "Rcpp", "readr", "stringr", "dplyr", "tidytext",
                     "rpart", "boot", "sm", "lubridate", "rpart.plot", "dplyr", "pROC", 
                     "lmtest", "caret", "e1071")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)


#### to obtain data we can either re generate
# source("gettingdata.R")
#### or we can collect what we have already produced
data <- read_csv('data/data1013.csv')


tweet_words <- data %>% select(screenName, text1) %>%
        group_by(screenName) %>%
        unnest_tokens(word, text1) %>%
        filter(!word %in% stop_words$word, str_detect(word, "^[a-z']+$"))

AFINN <- sentiments %>%
        filter(lexicon == "AFFIN") %>%
        dplyr::select(word, sentiment)

nrc <- sentiments %>%
        filter(lexicon == "nrc") %>%
        dplyr::select(word, sentiment)

tweet_sentiment <- tweet_words %>%
        inner_join(AFINN, by = "word") %>%
        group_by(screenName) %>%
        summarize(sentiment = mean(afinn_score))


t_sent <- function(dat){
        
        tweet_words <- dat %>%
                group_by(screenName) %>%
                unnest_tokens(word, text) %>%
                filter(!word %in% stop_words$word, str_detect(word, "^[a-z']+$"))
        
        AFINN <- sentiments %>%
                filter(lexicon == "AFINN") %>%
                select(word, afinn_score = score)
        
        tweet_sentiment <- tweet_words %>%
                inner_join(AFINN, by = "word") %>%
                group_by(screenName) %>%
                summarize(sentiment = mean(afinn_score))
        return(tweet_sentiment)
}
t1_sent <- t_sent(mutate(data, text = text1) %>% select(screenName, text)) %>% 
        mutate(t1_sent = sentiment) %>% select(-sentiment)
t2_sent <- t_sent(mutate(data, text = text2) %>% select(screenName, text)) %>% 
        mutate(t2_sent = sentiment) %>% select(-sentiment)
t3_sent <- t_sent(mutate(data, text = text3) %>% select(screenName, text)) %>% 
        mutate(t3_sent = sentiment) %>% select(-sentiment)
t4_sent <- t_sent(mutate(data, text = text4) %>% select(screenName, text)) %>% 
        mutate(t4_sent = sentiment) %>% select(-sentiment)
t5_sent <- t_sent(mutate(data, text = text5) %>% select(screenName, text)) %>% 
        mutate(t5_sent = sentiment) %>% select(-sentiment)
t6_sent <- t_sent(mutate(data, text = text6) %>% select(screenName, text)) %>% 
        mutate(t6_sent = sentiment) %>% select(-sentiment)
t7_sent <- t_sent(mutate(data, text = text7) %>% select(screenName, text)) %>% 
        mutate(t7_sent = sentiment) %>% select(-sentiment)
t8_sent <- t_sent(mutate(data, text = text8) %>% select(screenName, text)) %>% 
        mutate(t8_sent = sentiment) %>% select(-sentiment)
t9_sent <- t_sent(mutate(data, text = text9) %>% select(screenName, text)) %>% 
        mutate(t9_sent = sentiment) %>% select(-sentiment)
t10_sent <- t_sent(mutate(data, text = text10) %>% select(screenName, text)) %>% 
        mutate(t10_sent = sentiment) %>% select(-sentiment)

data <- data %>% full_join(t1_sent, by = "screenName") %>%
        full_join(t2_sent, by = "screenName") %>%
        full_join(t3_sent, by = "screenName") %>%
        full_join(t4_sent, by = "screenName") %>%
        full_join(t5_sent, by = "screenName") %>%
        full_join(t6_sent, by = "screenName") %>%
        full_join(t7_sent, by = "screenName") %>%
        full_join(t8_sent, by = "screenName") %>%
        full_join(t9_sent, by = "screenName") %>%
        full_join(t10_sent, by = "screenName")
rm(t1_sent, t2_sent, t3_sent, t4_sent, t5_sent, t6_sent, t7_sent, t8_sent, t9_sent, t10_sent)

data$t1_sent <- ifelse(is.na(data$t1_sent), 0, data$t1_sent)
data$t2_sent <- ifelse(is.na(data$t2_sent), 0, data$t2_sent)
data$t3_sent <- ifelse(is.na(data$t3_sent), 0, data$t3_sent)
data$t4_sent <- ifelse(is.na(data$t4_sent), 0, data$t4_sent)
data$t5_sent <- ifelse(is.na(data$t5_sent), 0, data$t5_sent)
data$t6_sent <- ifelse(is.na(data$t6_sent), 0, data$t6_sent)
data$t7_sent <- ifelse(is.na(data$t7_sent), 0, data$t7_sent)
data$t8_sent <- ifelse(is.na(data$t8_sent), 0, data$t8_sent)
data$t9_sent <- ifelse(is.na(data$t9_sent), 0, data$t9_sent)
data$t10_sent <- ifelse(is.na(data$t10_sent), 0, data$t10_sent)

### NRC
nrc <- sentiments %>%
        filter(lexicon == "nrc") %>%
        dplyr::select(word, sentiment)

nrc_sent = tweet_words %>% inner_join(nrc)

nrc_sent %>% group_by(sentiment,screenName) %>% summarize(n=n())

bad = nrc_sent %>%  #mutate(hour = hour(created)) %>% 
        group_by(screenName) %>% summarize(angry = mean(sentiment=="anger" | sentiment=="fear" | sentiment =="disgust")) %>% ungroup()

###
data <- data %>% mutate(t_sent = (t1_sent + t2_sent + t3_sent + t4_sent +
        t5_sent + t6_sent + t7_sent + t8_sent + t9_sent + t10_sent)/10 )


data <- data %>% full_join(bad) 
data$angry <- ifelse(is.na(data$angry),0,data$angry)

# is the profile image the 'egg'?
data$imagedefault <- grepl("default_profile_images", data$profileImageUrl)

#####
##### now we will look at what sources the data are
#####

mobile_user <- function(tweet_source){
        x <- grepl("Android",tweet_source) + 
                grepl("phone",tweet_source) + 
                grepl("iPad",tweet_source) != 0
        return(x)
}

automate_user <- function(tweet_source){
        grepl("withher3", data$statusSource8) + grepl("bot", data$statusSource8) + 
        grepl("www.keksec.org", data$statusSource8) != 0
}

web_user <- function(tweet_source){
        x <- grepl("TweetDeck", data$statusSource8) != 0
        return(x)
}

data$user_m1 <- mobile_user(data$statusSource1)
data$user_m2 <- mobile_user(data$statusSource2)
data$user_m3 <- mobile_user(data$statusSource3)
data$user_m4 <- mobile_user(data$statusSource4)
data$user_m5 <- mobile_user(data$statusSource5)
data$user_m6 <- mobile_user(data$statusSource6)
data$user_m7 <- mobile_user(data$statusSource7)
data$user_m8 <- mobile_user(data$statusSource8)
data$user_m9 <- mobile_user(data$statusSource9)
data$user_m10 <- mobile_user(data$statusSource10)

data <- data %>% mutate(user_m = user_m1 + user_m2 + user_m3 + user_m4+ user_m5+ user_m6 +
                         user_m7 + + user_m8 +  user_m9 +  user_m10)

data$user_a1 <- automate_user(data$statusSource1)
data$user_a2 <- automate_user(data$statusSource2)
data$user_a3 <- automate_user(data$statusSource3)
data$user_a4 <- automate_user(data$statusSource4)
data$user_a5 <- automate_user(data$statusSource5)
data$user_a6 <- automate_user(data$statusSource6)
data$user_a7 <- automate_user(data$statusSource7)
data$user_a8 <- automate_user(data$statusSource8)
data$user_a9 <- automate_user(data$statusSource9)
data$user_a10 <- automate_user(data$statusSource10)

data <- data %>% mutate(user_a = user_a1 + user_a2 + user_a3 + user_a4+ user_a5+ user_a6 +
                        user_a7 + + user_a8 +  user_a9 +  user_a10)

data$user_w1 <- web_user(data$statusSource1)
data$user_w2 <- web_user(data$statusSource2)
data$user_w3 <- web_user(data$statusSource3)
data$user_w4 <- web_user(data$statusSource4)
data$user_w5 <- web_user(data$statusSource5)
data$user_w6 <- web_user(data$statusSource6)
data$user_w7 <- web_user(data$statusSource7)
data$user_w8 <- web_user(data$statusSource8)
data$user_w9 <- web_user(data$statusSource9)
data$user_w10 <- web_user(data$statusSource10)

data <- data %>% mutate(user_w = user_w1 + user_w2 + user_w3 + user_w4+ user_w5+ user_w6 +
                        user_w7 + + user_w8 +  user_w9 +  user_w10)



###
### Loading bad words dictionary
###

badwords <- as.vector(paste(readLines("dictionaries/badwords.txt")))

## creating one vector with all the tweet texts smashed together

data$text <- paste(data$text1, data$text2, data$text3,data$text4,data$text5,data$text6,
              data$text7,data$text8,data$text9,data$text10, sep=" ")

tweet_dat <- unnest_tokens(data, output, text, token = "words", to_lower = TRUE,
              drop = FALSE) %>% select(output,screenName)
        
tweet_dat2 <- mutate(tweet_dat, bdword = output %in% badwords)  %>%
        group_by(bdword,screenName) %>% 
        filter(bdword == TRUE) %>%
        summarize(n=n()) %>% 
        mutate(badwords = n) %>% select(screenName, badwords)

data <- full_join(data,tweet_dat2, by="screenName")
data$badwords <- ifelse(is.na(data$badwords), 0, data$badwords)
write_csv(data, "data/dataE.csv")

# clean up, clean up

rm(AFINN, bad, nrc, nrc_sent, tweet_dat, tweet_dat2, tweet_sentiment, tweet_words,
   badwords)
