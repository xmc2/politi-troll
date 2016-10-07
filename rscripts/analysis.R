# building data
library(rpart)
data <- read_csv("data/dataE.r")
fit <-rpart(troll~t1_sent + t2_sent +t3_sent + t4_sent + t5_sent +  statusesCount +
                    followersCount, data=data, method='class') 


printcp(fit)
plotcp(fit)
colnames(data)

lfit <- glm(troll~t_sent + statusesCount,data=data, family = "binomial")
summary(lfit)

