require(twitteR)
source("hidden.R")

# lets look for tweets at hillary clinton
sample_size = 500
tweets <- searchTwitter('@hillaryclinton', n=sample_size)

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
sample_usersdf$screenName
colnames(sample_usersdf)

