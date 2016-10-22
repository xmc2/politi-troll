# visuals
library(ggplot2); library(rpart); library(boot); library(sm); library(lubridate); library(rpart.plot)
library(e1071)

source('rscripts/editing.R')
set.seed(1993)

#### EXPLORE

hist(data[data$troll == T, ]$t_sent, col="blue", xlab="Troll", ylab="sentiment score",
        main="most recent tweet")
plot(density(data[data$troll == T, ]$t_sent, bw=0.25))
plot(density(data[data$troll == F, ]$t_sent, bw=0.25))

ggplot(data, aes(t_sent, colour = troll)) +
        geom_density( bw=0.3) +
        ggtitle("sentiment score") +
        xlim(-3.5, 3.5) + labs(x="sentiment") +
        theme(legend.text=element_text(size=14), 
              axis.text=element_text(size=16),
              legend.title=element_text(size=16),
              axis.title=element_text(size=20,face="bold"),
              plot.title = element_text(size=22)) 


sm.density.compare(data$t_sent, data$troll, xlab="Sentiment Score",col=c("blue", "red"))
legend(x="topleft", col = c("red", "blue"), c("Troll", "Not a Troll"),lty=c(1,1))
title(main="Average tweet sentiment")
colnames(data)


sm.density.compare(as.numeric(data$created), data$troll, xlab="Date Created",col=c("blue", "red"))
legend(x="topleft", col = c("red", "blue"), c("troll", "not"),lty=c(1,1), lwd=2)
title(main="Twitter Account Birth")


hist(data[data$troll == F, ]$t_sent, col="blue", xlab="Troll", ylab="sentiment score",
     main="tweets")

# define a test and a non test set
test_obs <- sample(1:nrow(data), size = 25, replace=F)
test_set <- data[test_obs,]
train_set <- data[-test_obs,]


###
#### REGRESSION TREES 
###

colnames(data)
fit <- rpart(troll~t_sent+created+followersCount+listedCount+statusesCount+favoritesCount+friendsCount+
                     lang+badwords+user_w+user_a+user_m + angry + imagedefault, data=data, method="class")
plotcp(fit)
rpart.plot(fit)

###
pfit <- prune(fit, cp=fit$cptable[which.min(fit$cptable[,"xerror"]),"CP"])
printcp(pfit)
plotcp(pfit)

summary(pfit)
par(mfrow=c(1, 1))

# plot the pruned tree 
rpart.plot(pfit, type = 3,uniform=TRUE, 
     main="Pruned Classification Tree for Troll", digits=2, tweak =1.5)
pfit$cptable
#?rpart.plot
#text(pfit, use.n=TRUE, all=TRUE, cex=.5, offset=0)

plot(pfit, uniform=TRUE, 
     main="Classification Tree for Kyphosis")
text(pfit, use.n=TRUE, all=TRUE, cex=.8)

plot(fit, uniform=TRUE, 
     main="Regression Tree for Mileage ")
text(fit, use.n=TRUE, all=TRUE, cex=.8)

###
#### LOGISTIC REGRESSION 
### 

logistic_fit1 <- glm(troll ~ t_sent, family = binomial(link = "logit"), data=data)
logistic_fit1_cv <- cv.glm(data, logistic_fit1)
logistic_fit1_cv$delta[1]

logistic_fit2 <- glm(troll~t_sent+followersCount+listedCount+favoritesCount+
                             badwords+user_m  + imagedefault, 
                     family = binomial(link = "logit"), data=data)
logistic_fit2_cv <- cv.glm(data, logistic_fit2)
logistic_fit2_cv$delta[1]
summary(logistic_fit2)

###
#### SVM
### 

svmfit=svm(troll~t_sent+created+followersCount+listedCount+
                   statusesCount+favoritesCount+friendsCount, data=data , kernel ="linear", cost=10,
           scale=FALSE, type="C")
tune.out.svm = tune(svm, troll~t_sent+created+followersCount+listedCount+
                            statusesCount+favoritesCount+friendsCount,data=data ,kernel ="linear",
     ranges=list(cost=c(0.001, 0.01, 0.1, 1,5,10,100) ))
bestmod=tune.out.svm$best.model
summary(bestmod)


plot(svmfit, data=data)

###
#### FOREST - removed
### 


###
#### KNN -removed
###



###
#### CNN -removed
###
