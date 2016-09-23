require(twitteR); require(dplyr)
source("hidden.R")
system('bash set_dir.sh')
getwd()

# lets look for tweets at hillary clinton
sample_size = 100
tweets <- searchTwitter('@hillaryclinton', n=sample_size); tweets_time <- Sys.time()

# lets generate a list (vector) of all of the observed users

user_names <- vector(length = sample_size)
for (i in 1:sample_size){
        user_names[i] <- tweets[[i]]$screenName
}
user_names <- as.vector(user_names)

# lets get info from these users 
sample_users <- lookupUsers(user_names)
sample_users_df <- twListToDF(sample_users)
sample_users_df$screenName
# save (write to csv)
write.csv(sample_users_df, "outputs/users.csv")


# lets make a data frame of the tweets we got
tweets_df <- twListToDF(tweets)
head(tweets_df)
#export this
write.csv(tweets_df, "outputs/tweets.csv")

# making a list of all users and one tweet (not particularly usefull)
tester <- full_join(sample_users_df, tweets_df, by='screenName')

#####
#####
#####
#####
#####

# defining this function to allow for easier data frame construction
normalize <- function(w){
        w$replyToSN <- as.character(w$replyToSN) 
        w$replyToSID <- as.character(w$replyToSID) 
        w$replyToUID <- as.character(w$replyToUID)
        w
}

list_dim <- data.frame()
for (i in 1:length(user_names)){
        if (identical(userTimeline(user_names[i],n=10), list()) == FALSE){
                tempor <- twListToDF(userTimeline(user_names[i],n=10))
                tempor <- normalize(tempor)
                list_dim <- bind_rows(tempor, list_dim)
        }

}


t.first <- match(unique(list_dim$screenName), list_dim$screenName)
t.first ####### this is what we want, extracting uniques

to_add(tweets_df)        

to_add(tweets_df)


colnames(sample_users_df)
colnames(list_dim)


y <- twListToDF(userTimeline('mattcol3',n=3))
x <- twListToDF(lookupUsers('mattcol3'))
z <- full_join(x, y, by = "screenName")



paste("Data was generated from twitter on", tweets_time)

# test 

fulldata <- sample_users_df
for (i in 1:3){
        if (identical(userTimeline(user_names[i],n=10), list()) == FALSE){
                tempor <- twListToDF(userTimeline(user_names[i],n=10))
                tempor <- normalize(tempor)
                
                for (j in 1:nrow(tempor)){
                        fulldata <- full_join(fulldata, tempor[j,], "screenName")
                }
        }
}
