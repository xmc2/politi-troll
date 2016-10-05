# classify data
# hand classified, gluten free, artesian ...

library(readr)
library(stringr)
library(dplyr)

db <- read_csv('outputs/db.csv') %>% select(tweet1, tweet2, tweet3, tweet4, tweet5, 
        tweet6, tweet7, tweet8, tweet9, tweet10, screenName)
to_classify <- select(db, text1, text2, text3, text4, text5, text6, text7,
            text8, text9, text10, screenName)

# don't overwrite the hand classification. 
#write.csv(to_classify, "outputs/to_classify.csv")

classified <- read_csv("outputs/to_classify.csv")
db2 = classified %>% select(screenName, troll) %>% full_join( db, by = 'screenName') %>%
        select(-X1)

