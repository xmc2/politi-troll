library(readr)
library(stringr)
library(dplyr)
#### to obtain data we can either re generate
# source("gettingdata.R")
#### or we can collect what we have already produced
db <- read_csv('outputs/db.csv')
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
                # check this... below...
        x <- paste("db <- mutate(db, txt",i," = iconv(db$text",i,", from='UTF-8', to='latin1'), sep='')")
        list_of_cammnds <- append(list_of_cammnds, x)
        eval(parse(text=x))

}

colnames(db)
str_count(tolower(db[,]$text1), "clinton")

iconv(db[,]$text1, from="UTF-8", to="latin1")

?iconv
