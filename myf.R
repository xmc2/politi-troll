require(twitteR)
source("hidden.R")

# ### looking at users ###
# me <- getUser('mattcol3')
# as.list('mattcol3')
# me$getDescription()
# me$getFollowersCount()
# df <- twListToDF(me$getFollowers())
# summary(df)
# head(df)
# 
# ### looking at clinton ###
# clinton <- getUser('HillaryClinton')
# clinton$getDescription()
# clinton$getFollowersCount()
# 
# ## data_frame <- do.call("rbind", lapply(rdmTweets, as.data.frame))
# 
# vec <- vector(mode="list", length=length(MyFollowers))
# for (i in 1:length(MyFollowers)){
#         vec[i] <- getUser(MyFollowers[i])
# }
# summary(vec)
# 
# getUser(MyFollowers[4])


# lets look for tweets at hillary clinton
sample_size = 500
tweets <- searchTwitter('@hillaryclinton', n=sample_size)
class(tweets)
str(tweets[[1]])
for (i in 1:100){
        print(tweets[[i]]$replyToSN)
}

tweets[[1]]$getScreenName() # these are the same command.
tweets[[1]]$screenName

user_names <- vector(length = sample_size)
for (i in 1:sample_size){
        user_names[i] <- tweets[[i]]$screenName
}
user_names

sample_users <- lookupUsers(user_names)

str(sample_users[[1]])

sample_usersdf <- twListToDF(sample_users)
sample_usersdf$screenName
colnames(sample_usersdf)
