require(twitteR); require(dplyr)
source("hidden.R")
system('bash set_dir.sh')

# lets look for tweets at hillary clinton
sample_size = 150
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
# sample_users_df$screenName # looking at screenNames
# save (write to csv)
write.csv(sample_users_df, "outputs/users.csv")


# lets make a data frame of the tweets we got
tweets_df <- twListToDF(tweets)
#head(tweets_df)
#colnames(tweets_df)
#export this
write.csv(tweets_df, "outputs/tweets.csv")

# making a list of all users and one tweet (not particularly usefull)
tester <- full_join(sample_users_df, tweets_df, by='screenName')
tester <- select(tester, -id.y, -id.x)
#colnames(tester)

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

reduce_tweet <- function(x){
        x <- select(x, -id, -replyToUID)
        x
}

list_dim <- data.frame()
tweet_count <- 20
for (i in 1:length(user_names)){ 
        w <- userTimeline(user_names[i],n=tweet_count, includeRts=TRUE)
        if (identical(w, list()) == FALSE){
                tempor <- twListToDF(w) # this is a new line... 
                tempor <- normalize(tempor)
                list_dim <- bind_rows(tempor, list_dim)
                Sys.sleep(0)
        }
}

tweet_observations <- list_dim
# lets say that our data is in list_dim
# we will now attempt to add tweet info to our data rows

tweetno <- 10
print(paste("There are", tweet_count, "tweets per user available."))
print(paste("We will collect the most recent", tweetno))

for (i in 1:tweetno){
        if (i == 1){
                to_add <- match(unique(tweet_observations$screenName), tweet_observations$screenName)
                #tweet_observations <- reduce_tweet(tweet_observations)

                add_me <- tweet_observations[to_add,]
                colnames(add_me) <- ifelse(colnames(tweet_observations) == "screenName", # TEST
                          colnames(tweet_observations), paste(colnames(tweet_observations),i,sep=""))# TEST
                
#                 colnames(add_me) <- ifelse(colnames(add_me) == "screenName",# PRESERVED
#                         colnames(add_me), paste(colnames(add_me),i,sep="")) # PRESERVED
                db <- full_join(sample_users_df, add_me, by='screenName') #changing tweet_observations[to_add,] to add_me
        } else {
                # removing those observations already added
                tweet_observations <- tweet_observations[-to_add,]
                
                # finding new unique observations to add
                to_add <- match(unique(tweet_observations$screenName), tweet_observations$screenName)
                # storing these
                add_me <- tweet_observations[to_add,]
                # renaming
                colnames(add_me) <- ifelse(colnames(tweet_observations) == "screenName",
                                           colnames(tweet_observations), paste(colnames(tweet_observations),i,sep=""))
                db <- full_join(db, add_me, by='screenName')
        }
}
# colnames(db)
bu <- db
write.csv(db, "outputs/db.csv")


paste("Data was generated from twitter on", tweets_time)

