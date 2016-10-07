library(readr); library(stringr); library(dplyr); library(tidytext)
#### to obtain data we can either re generate
# source("gettingdata.R")
#### or we can collect what we have already produced
data <- read_csv('data/data.csv')



tweet_words <- data %>% select(screenName, text1, text2) %>%
        group_by(screenName) %>%
        unnest_tokens(word, text1) %>%
        filter(!word %in% stop_words$word, str_detect(word, "^[a-z']+$"))

AFINN <- sentiments %>%
        filter(lexicon == "AFINN") %>%
        select(word, afinn_score = score)

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

colnames(data)

data <- data %>% mutate(t_sent = (t1_sent + t2_sent + t3_sent + t4_sent +
        t5_sent + t6_sent + t7_sent + t8_sent + t9_sent + t10_sent)/10 )



######### BELOW IS V TERRIBLE #####

badwords <- as.vector(paste(readLines("dictionaries/badwords.txt")))

db <- data
x <- vector()
list_of_cammnds <- vector()


for (i in 1:10){ # this is terrible for readability .... 
        x <- paste("db <- mutate(db, reply", i," = !is.na(replyToSN", i, "))", sep="")
        list_of_cammnds <- append(list_of_cammnds, x)
        eval(parse(text=x))
        x <- paste("db <- mutate(db, tweet_location", i," = !is.na(latitude", i, "))", sep="")
        eval(parse(text=x))
        list_of_cammnds <- append(list_of_cammnds, x)
        x <- paste("db <- select(db, -truncated", i, ", -latitude", i, ", -longitude",i,"
                   , -id",i, ", -created",i, ", -replyToSID",i, ", -replyToSN", i,
                ", -replyToSID",i, ")"
                   , sep="")
        list_of_cammnds <- append(list_of_cammnds, x)
        eval(parse(text=x))
}
db[,]$text1 <- iconv(db[,]$text1, from="UTF-8", to="latin1")
db[,]$text2 <- iconv(db[,]$text2, from="UTF-8", to="latin1")
db[,]$text3 <- iconv(db[,]$text3, from="UTF-8", to="latin1")
db[,]$text4 <- iconv(db[,]$text4, from="UTF-8", to="latin1")
db[,]$text5 <- iconv(db[,]$text5, from="UTF-8", to="latin1")
db[,]$text6 <- iconv(db[,]$text6, from="UTF-8", to="latin1")
db[,]$text7 <- iconv(db[,]$text7, from="UTF-8", to="latin1")
db[,]$text8 <- iconv(db[,]$text8, from="UTF-8", to="latin1")
db[,]$text9 <- iconv(db[,]$text9, from="UTF-8", to="latin1")
db[,]$text10 <- iconv(db[,]$text10, from="UTF-8", to="latin1")




db$bdtxt1 <- 0; db$bdtxt2 <- 0; db$bdtxt3 <- 0; db$bdtxt4 <- 0; db$bdtxt5 <- 0
db$bdtxt6 <- 0; db$bdtxt7 <- 0; db$bdtxt8 <- 0; db$bdtxt9 <- 0; db$bdtxt10 <- 0


####
for (j in 1:nrow(db)){
w <- unlist(strsplit(tolower(strsplit(db[j,]$text1, split="\n", fixed = T)[[1]]), split = " "))
wct <- 0
        for (i in 1:length(w)){
                wct <- wct + w[i] %in% badwords
        }
        db[j,]$bdtxt1 <- wct
        #
}
db$bdtxt1
for (j in 1:nrow(db)){
w <- unlist(strsplit(tolower(strsplit(db[j,]$text2, split="\n", fixed = T)[[1]]), split = " "))
wct <- 0
        for (i in 1:length(w)){
                wct <- wct + w[i] %in% badwords
        }
db[j,]$bdtxt2 <- wct
        #
w <- unlist(strsplit(tolower(strsplit(db[j,]$text3, split="\n", fixed = T)[[1]]), split = " "))
wct <- 0
        for (i in 1:length(w)){
                wct <- wct + w[i] %in% badwords
        }
db[j,]$bdtxt3 <- wct
        #
w <- unlist(strsplit(tolower(strsplit(db[j,]$text4, split="\n", fixed = T)[[1]]), split = " "))
wct <- 0
        for (i in 1:length(w)){
                wct <- wct + w[i] %in% badwords
        }
db[j,]$bdtxt4 <- wct
        #
w <- unlist(strsplit(tolower(strsplit(db[j,]$text5, split="\n", fixed = T)[[1]]), split = " "))
wct <- 0
        for (i in 1:length(w)){
                wct <- wct + w[i] %in% badwords
        }
db[j,]$bdtxt5 <- wct
        #
w <- unlist(strsplit(tolower(strsplit(db[j,]$text6, split="\n", fixed = T)[[1]]), split = " "))
wct <- 0
        for (i in 1:length(w)){
                wct <- wct + w[i] %in% badwords
        }
db[j,]$bdtxt6 <- wct
        #
w <- unlist(strsplit(tolower(strsplit(db[j,]$text7, split="\n", fixed = T)[[1]]), split = " "))
wct <- 0
        for (i in 1:length(w)){
                wct <- wct + w[i] %in% badwords
        }
db[j,]$bdtxt7 <- wct
        #
w <- unlist(strsplit(tolower(strsplit(db[j,]$text8, split="\n", fixed = T)[[1]]), split = " "))
wct <- 0
        for (i in 1:length(w)){
                wct <- wct + w[i] %in% badwords
        }
        db[j,]$bdtxt8 <- wct
        #
        w <- unlist(strsplit(tolower(strsplit(db[j,]$text9, split="\n", fixed = T)[[1]]), split = " "))
        wct <- 0
        for (i in 1:length(w)){
                wct <- wct + w[i] %in% badwords
        }
        db[j,]$bdtxt9 <- wct
        #
        w <- unlist(strsplit(tolower(strsplit(db[j,]$text10, split="\n", fixed = T)[[1]]), split = " "))
        wct <- 0
        for (i in 1:length(w)){
                wct <- wct + w[i] %in% badwords
        }
        db[j,]$bdtxt10 <- wct
}


# would like a variable that is proportion of letters that are caps #

db$cap1 <- db$cap2 <- db$cap3 <- db$cap4 <- db$cap5 <- db$cap6 <- db$cap7 <- db$cap8 <- 0
db$cap9 <- db$cap10 <- 0

# loading the 'excited' vector up... #
excited<-as.vector(paste(readLines("excited.txt")))


# tweetletters <-unlist(strsplit(unlist(strsplit(strsplit(db[64,]$text2, split="\n", fixed = T)[[1]], split = " ")),split=""))
# for (i in 1:length(excited)){
#         print(excited[i])
# }

excited_text_reader <- function(text, dict = excited){
        x <- unlist(strsplit(unlist(strsplit(strsplit(text, split="\n", fixed = T)[[1]], split = " ")),split=""))
        count <- 0
        count = sum(x %in% dict)
        return(count)
}

db$cap1 <- sapply(db$text1, excited_text_reader)
db$cap2 <- sapply(db$text2, excited_text_reader)
db$cap3 <- sapply(db$text3, excited_text_reader)
db$cap4 <- sapply(db$text4, excited_text_reader)
db$cap5 <- sapply(db$text5, excited_text_reader)
db$cap6 <- sapply(db$text6, excited_text_reader)
db$cap7 <- sapply(db$text7, excited_text_reader)
db$cap8 <- sapply(db$text8, excited_text_reader)
db$cap9 <- sapply(db$text9, excited_text_reader)
db$cap10 <- sapply(db$text10, excited_text_reader)

#

write.csv(db, "processed.csv")
