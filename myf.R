require(twitteR)

tweets <- searchTwitter('#test', n=500)
?searchTwitter
?do.call
## df <- do.call("rbind", lapply(rdmTweets, as.data.frame))

me <- getUser('mattcol3')
lookupUsers('mattcol3')
MyFriends <- me$getFriends()
MyFollowers <- me$getFollowers()
lookupUsers(MyFollowers)
