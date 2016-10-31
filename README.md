# PolitiTroll

Advanced Data Science

"Twitter Project"


If you would like to rerun the analysis you can run file 8 or alternatively re-run the lab_rmd.rmd file in the ~/reports subdirectory

If you yourself would like to collect trolls (using the twitter api) you must place a file called `hidden.r`
containing your Twitter API keys for the TwitteR API wrapper to work.



Most of the magic happens in the `~/rscripts` subdirectory, here is an overview:

`0_hidden.R`
  
  This file contains our API keys and authenticates our session for us.
  
`1_get_tweets_now_func.R`
  
  This file defines several functions, most importantly `get_those_tweets_meow()` which searches the Twitter API for tweets matching a particular string and collects information about the user who sent the tweet.

`2_selected_trolls.R`

This file collects the same information as `1_get_tweets_now_func.R`, but for pre-identified users.

`3_gettingdata.R`

This file utilizes functions from files 1 and 2 to collect data. You may specify which strings you may be looking for (eg. 'pizza hut isn't that good but what else am I going to eat in toledo'). A file  "outputs/classifyme_api.csv" will be created where a human can read the tweets and determine if the user is a troll or not. After saving the file with a troll column (with 1 being troll, 0 being non troll), the script will bind this troll column to the rest of the data.

`4_hand_harvesting_trolls.R`

This file serves the same function as file 3, but for pre-selected users (users  you'd like to add of which you already have their username). A file for classification is created (classify, 0 or 1 for troll status)  in ~/outputs/classifyme_handtroll.csv . the script binds troll status to the remainder of data and merges these data with the data from file 3 to crease a file ~/data/data.csv which contains all relevant data for our project.

` 	6_emoji.r`

This file scrapes and emoji database from the web.

`7_Editing.R`

This file preprocesses the data to meaningful information for the analysis and visualization.


`8_visuals.R`

this file runs visualization and analysis from EDA to models.
