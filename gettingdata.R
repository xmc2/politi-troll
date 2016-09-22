require(twitteR)
source("hidden.R")
system('bash set_dir.sh')
getwd()

# lets look for tweets at hillary clinton
sample_size = 100
tweets <- searchTwitter('@hillaryclinton', n=sample_size); tweets_time <- Sys.time(); tweets_date <- Sys.Date()

# lets generate a list (vector) of all of the observed users

user_names <- vector(length = sample_size)
for (i in 1:sample_size){
        user_names[i] <- tweets[[i]]$screenName
}
user_names <- as.vector(user_names)

sample_users <- lookupUsers(user_names)
sample_users_df <- twListToDF(sample_users)
sample_users_df$screenName
write.csv(tweets_df, "outputs/users.csv")


tweets_df <- twListToDF(tweets)
head(tweets_df)
write.csv(tweets_df, "outputs/tweets.csv")

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
for (i in 1:50){
        if (identical(userTimeline(user_names[i],n=10), list()) == FALSE){
                tempor <- twListToDF(userTimeline(user_names[i],n=10))
                tempor <- normalize(tempor)
                list_dim <- bind_rows(tempor, list_dim)
        }

}

nrow(list_dim)
ncol(list_dim)



paste("Data was generated from twitter on", tweets_time)
