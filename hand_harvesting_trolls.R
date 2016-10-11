# hand harvesting trolls
require(twitteR); require(dplyr); require(tidytext); require(readr)
source("rscripts/hidden.R")
source("rscripts/get_tweets_now_func.R")
source("rscripts/selected_trolls.R")

hand_trolls <- c("Robertgreiner71", "analiensaturn", "katecove11", "MushroomThrowad",
                 "offensive_jake", "Dlhg35G", "545_6589", "patrioticpepe", "hpufo", "Parker9_", 
                 "MagicRoyalty", "qbjsu300", "rapidrunnr", "AustinOnSocial", "KlayVolk", 
                 "patrioticpepe", "TWTWsports", "MagicRoyalty", "EnemyWithinn", "idvck", 
                 "_MaryAli", "Twitteshia", "2Bgreatagain", "golffanatic98", "Epic_OverKill",
                 "Terry4DonTrump", "Cuck_Fighter300", "Mikesteph5507", "immigrant4trump",
                 "GreenLeafPub", "SWEETmawdusa", "ymlehnen", "Kittensrule36", "Nani194347",
                 "tess_deville", "KodakCuck", "qbjsu300",
                 "JhbTeam", "assbot", "Blob_Fish", "at_maggiemac", "themightylayman", 
                 "keksec__org", "New1000AD", "rsweat52", "HilaryClintin", "CarlKenner", 
                 "Blob_Fish", "mass_mont", "Bigsby_Jenkins", "VeraVanzetti", "mass_mont", 
                 "ThePepEra", "emilio_delgado", "sweetatertot2", 'TrumpBoySwag', 
                 "BarbMuenchen", "BucketOfLosers", "mrsh0neybee", "RapinBill", 
                 "jenilynn1001", "ConstanceQueen8", "Darren32895836", "SueSuli9", 
                 "MelanieMonroee", "EJKTwit", "terrymendozer", "YoungDems4Trump", 
                 "GirlyDarnelle", "dacw10", "SalubriousMind", "4JL2010", "LeahRBoss",
                 "jd_Constitution", "DeplorableChri1", "fulmen56", "EthanStew", "Trillvybe",
                 "BishopDawsom", "ElizabethDaQuee", "Tjsweetsong", 
                 "chrismar822", "debnam_lee", "GielauA","jenifercolins",
                 "janegarcia92", "normaturner912", "shadowjago101", "insertName49",
                 "katecove11", "whoshvnter", "alexrcarson", "MorganLsneed", "1mykfed",
                 "Robertgreiner71", "analiensaturn", "katecove11", "MushroomThrowad",
                 "offensive_jake", "Dlhg35G", "545_6589", "patrioticpepe", "NeilTurner_")

# this is all of the already collected data
data <- read_csv('data/data.csv') %>%
        mutate(screenName = tolower(screenName))

# we will remove duplicates from the dataset
hand_trolls <- hand_trolls %>%
        tolower() %>%
        as.data.frame() %>%
        distinct()
hand_trolls$screenName <- hand_trolls[,1]
hand_trolls <- hand_trolls %>%
        select(screenName)

# this checks to see if any hand selected trolls are already in the data
hand_trolls <- hand_trolls %>%
        dplyr::anti_join(data, by = "screenName") # all rows in a that dont have a match in b
user_names <- as.vector(hand_trolls$screenName)


rm(hand_trolls)
hand_trolls_data <- trolls(user_names)

# to classify 
hand_trolls_data %>%
        select(screenName, text1, text2, text3, text4, text5, text6, text7, text8, 
        text9, text10) %>%
        write_csv('outputs/classify1010.csv')

classified_trolls <- read_csv('outputs/classify1010.csv') %>%
        select(screenName, troll)

hand_trolls_classified <- hand_trolls_data %>% 
        full_join(classified_trolls)
        
data <- data %>%
        rbind(hand_trolls_classified)

write_csv(data, 'data/data1010.csv')
mean(data$troll)
