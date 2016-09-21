require(twitteR)
source("hidden.R")
system('bash set_dir.sh')


# lets look for tweets at hillary clinton
sample_size = 500
tweets <- searchTwitter('@hillaryclinton', n=sample_size); tweets_time <- Sys.time(); tweets_date <- Sys.Date()

# $replyToSN indicates if/to who the tweet was in reply to

# tweets[[1]]$getScreenName() # these are the same command.
# tweets[[1]]$screenName

# lets generate a list of all of the observed users

user_names <- vector(length = sample_size)
for (i in 1:sample_size){
        user_names[i] <- tweets[[i]]$screenName
}
user_names

sample_users <- lookupUsers(user_names)
sample_users_df <- twListToDF(sample_users)
sample_users_df$screenName
write.csv(tweets_df, "outputs/users.csv")


?searchTwitter
tweets_df <- twListToDF(tweets)
head(tweets_df)
write.csv(tweets_df, "outputs/tweets.csv")

list_dim <- list()
for (i in 1:length(user_names)){
        list_dim[i] <- userTimeline(user_names[i],n=10)
        
}

a_test <- userTimeline(user_names[1],n=10); a_test[1]

getCurRateLimitInfo()
