library(httr)

# 1. Find OAuth settings for twitter:
#    https://dev.twitter.com/docs/auth/oauth
oauth_endpoints("twitter")

# 2. Register an application at https://apps.twitter.com/
#    Make sure to set callback url to "http://127.0.0.1:1410/"
#
#    Replace key and secret below
setup_twitter_oauth("ODkKP1rA44Iv8zidrvk3K3uZu", "gvb0Q6J6XS1gHdDNWoxnpRccxLfXwsXptBHkDxVMXe71y5fsb7", access_token=NULL, access_secret=NULL)


# 3. Get OAuth credentials
twitter_token <- oauth1.0_token(oauth_endpoints("twitter"), myapp)

# 4. Use API
req <- GET("https://api.twitter.com/1.1/statuses/home_timeline.json",
           config(token = twitter_token))
stop_for_status(req)
content(req)