# visuals
library(ggplot2); library(rpart); library(boot); library(sm)

source('rscripts/editing.R')


hist(data[data$troll == T, ]$t_sent, col="blue", xlab="Troll", ylab="sentiment score",
        main="most recent tweet")
plot(density(data[data$troll == T, ]$t_sent, bw=0.25))
plot(density(data[data$troll == F, ]$t_sent, bw=0.25))

sm.density.compare(data$t_sent, data$troll, xlab="Sentiment Score",col=c("blue", "red"))
legend(x="topleft", col = c("red", "blue"), c("troll", "not"),lty=c(1,1))
title(main="Sentiment Score by group")
colnames(data)


sm.density.compare(as.numeric(data$created), data$troll, xlab="Sentiment Score",col=c("blue", "red"))
legend(x="topleft", col = c("red", "blue"), c("troll", "not"),lty=c(1,1))
title(main="Sentiment Score by group")


hist(data[data$troll == F, ]$t_sent, col="blue", xlab="Troll", ylab="sentiment score",
     main="most recent tweet")

fit <- rpart(troll~t_sent+created+followersCount+listedCount+statusesCount, data=data, method="class")
plotcp(fit)
plot(fit)
text(fit)

###
pfit <- prune(fit, cp=fit$cptable[which.min(fit$cptable[,"xerror"]),"CP"])
summary(pfit)
# plot the pruned tree 
plot(pfit, uniform=TRUE, 
     main="Pruned Classification Tree for Troll")
text(pfit, use.n=TRUE, all=TRUE, cex=.5, offset=8)


##### logistic regression
logistic_fit1 <- glm(troll ~ t_sent, family = binomial(link = "logit"), data=data)
logistic_fit1_cv <- cv.glm(data, logistic_fit1)
logistic_fit1_cv$delta[1]

logistic_fit2 <- glm(troll ~ t_sent+created+followersCount+listedCount+statusesCount, family = binomial(link = "logit"), data=data)
logistic_fit2_cv <- cv.glm(data, logistic_fit2)
logistic_fit2_cv$delta[1]
