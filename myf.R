require(twitteR)

rdmTweets <- searchTwitter('#test', n=500)

df <- do.call("rbind", lapply(rdmTweets, as.data.frame))

summary(df)

head(df)

df[1,]
?searchTwitter
# Note that the Twitter search API only goes back 1500 tweets (I think?)

#Create a dataframe based around the results
df <- do.call("rbind", lapply(rdmTweets, as.data.frame))
#Here are the columns
names(df)
#And some example content
head(df,3)