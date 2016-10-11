require(twitteR); require(dplyr); require(tidytext); require(readr)
source("rscripts/hidden.R")
source("rscripts/get_tweets_now_func.R")
source("rscripts/selected_trolls.R")

# BEGIN

# hrc_tweets <- get_those_tweets_meow(sample_size = 150, term = '@hillaryclinton'); hrc_time <- Sys.time()
# djt_tweets <- get_those_tweets_meow(sample_size = 150, term = '@donaldtrump'); djt_time <- Sys.time()
# data <- dplyr::bind_rows(hrc_tweets, djt_tweets)
# #write.csv(data, "outputs/data2.csv")
# x <- read.csv("outputs/data2.csv")
# x <- x %>% select(screenName, text1, text2, text3, text4, text5, text6, text7, text8, text9, text10)
# #write.csv(x, "outputs/classifyme1.csv")
# rm(x)
# # END
# 
# 
# #####
# ##### Hand harvested trolls
# #####
# #####
# #####
# 
# #####
# 
# existing_trolls <- select(read.csv("outputs/selected_trolls.csv"), -X)
# 



#TO ADD :
        
hand_trolls <- c("Robertgreiner71", "analiensaturn", "katecove11", "MushroomThrowad",
        "offensive_jake", "Dlhg35G", "545_6589", "patrioticpepe", "hpufo", "Parker9_", 
        "MagicRoyalty", "qbjsu300", "rapidrunnr", "AustinOnSocial", "KlayVolk", 
        "patrioticpepe", "TWTWsports", "MagicRoyalty", "EnemyWithinn", "idvck", "_MaryAli", 
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


