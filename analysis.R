# building data
source(gettingdata.R)
# db
getwd()
summary(db)

badwords<-as.vector(paste(readLines("badwords.txt")))




