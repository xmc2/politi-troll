# hand harvesting trolls
require(twitteR); require(dplyr); require(tidytext); require(readr)

source("rscripts/1_get_tweets_now_func.R")
source("rscripts/2_selected_trolls.R")

hand_trolls <- c() # put troll usernames here to make a character vector!!!

# this is all of the already collected data
data <- read_csv('data/api_data_troll.csv') %>%
        mutate(screenName = tolower(screenName))

# we will remove duplicates fr om the dataset
hand_trolls <- hand_trolls %>%
        tolower() %>%
        as.data.frame() %>%
        distinct()
hand_trolls$screenName <- hand_trolls[,1]
hand_trolls <- hand_trolls %>%
        select(screenName)

# this checks to see if any hand selected trolls are already in the data
hand_trolls <- hand_trolls %>%
        dplyr::anti_join(data, by = "screenName") # all rows in a that dont have a match in b
user_names <- as.vector(hand_trolls$screenName)


rm(hand_trolls)
hand_trolls_data <- trolls(user_names)

# to classify 
hand_trolls_data %>%
        select(screenName, text1, text2, text3, text4, text5, text6, text7, text8, 
        text9, text10) %>%
        write_csv('outputs/classifyme_handtroll.csv')

## CLASSIFY THESE

classified_trolls <- read_csv('outputs/classifyme_handtroll.csv') %>%
        select(screenName, troll)

hand_trolls_classified <- hand_trolls_data %>% 
        full_join(classified_trolls)
        
data <- data %>%
        rbind(hand_trolls_classified) # this is our completed troll 'database'

write_csv(data, 'data/data.csv')
