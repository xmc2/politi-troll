library(readr)
library(stringr)
library(dplyr)
#### to obtain data we can either re generate
# source("gettingdata.R")
#### or we can collect what we have already produced
db <- read_csv('outputs/db.csv')
badwords<-as.vector(paste(readLines("badwords.txt")))

db1 <- db
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
