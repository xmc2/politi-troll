# visuals

set.seed(100)
source('rscripts/7_Editing.R')

data$followersCount0 <- data$followersCount / 10
data$listedCount0 <- data$listedCount / 10
data$friendsCount0 <- data$friendsCount / 10

data$followersCount00 <- data$followersCount / 100
data$listedCount00 <- data$listedCount / 100
data$friendsCount00 <- data$friendsCount / 100

data$english <- grepl("en",data$lang)

data$days_2015 <- (seconds(data$created) - 1420088400) / 60 / 60 / 24

data$AFINN_sent <- data$t_sent
### define a training and a testing set
set.seed(15)
test <- sample_frac(data,0.20)
train <- anti_join(data,test)

####
# hist(data[data$troll == T, ]$t_sent, col="blue", xlab="Troll", ylab="sentiment score",
#         main="most recent tweet")
# plot(density(data[data$troll == T, ]$t_sent, bw=0.25))
# plot(density(data[data$troll == F, ]$t_sent, bw=0.25))
# 
# ggplot(data, aes(t_sent, colour = troll)) +
#         geom_density( bw=0.3) +
#         ggtitle("sentiment score") +
#         xlim(-3.5, 3.5) + labs(x="sentiment") +
#         theme(legend.text=element_text(size=14), 
#               axis.text=element_text(size=16),
#               legend.title=element_text(size=16),
#               axis.title=element_text(size=20,face="bold"),
#               plot.title = element_text(size=22)) 
# 
# 
# sm.density.compare(train$t_sent, train$troll, xlab="Sentiment Score",col=c("blue", "red"))
# legend(x="topleft", col = c("red", "blue"), c("Troll", "Not a Troll"),lty=c(1,1))
# title(main="Average tweet sentiment")
# 
# 
# sm.density.compare(as.numeric(train$created), train$troll, xlab="Date Created",col=c("blue", "red"))
# legend(x="topleft", col = c("red", "blue"), c("troll", "not"),lty=c(1,1), lwd=2)
# title(main="Twitter Account Birth")
# 
# 
# hist(data[train$troll == F, ]$t_sent, col="blue", xlab="Troll", ylab="sentiment score",
#      main="tweets")
# 

###
#### REGRESSION TREES 
###
weights = ifelse(train$troll == 1,(1-mean(train$troll))/mean(train$troll),1)

fit <- rpart(troll~AFINN_sent+days_2015+followersCount+listedCount+statusesCount+favoritesCount+friendsCount+
                     english+bdword+user_w+user_a+user_m + angry + imagedefault, 
             method = "class",
             weights=weights,
             data=train)
rpart.plot(fit)

###
set.seed(1)
pfit <- prune(fit, cp=fit$cptable[which.min(fit$cptable[,"xerror"]),"CP"])
# printcp(pfit)
plotcp(pfit)

# summary(pfit)
# par(mfrow=c(1, 1))



# plot the pruned tree 
par(mfrow=c(1,1)) 
tree_plot <- rpart.plot(pfit, type = 3,uniform=TRUE, 
      main="Pruned Classification Tree for Troll", digits=2, tweak =1.5)
# pfit$cptable


tree_pred <- predict(fit, test) %>% as.data.frame() %>% cbind(test$troll) %>% as.tbl()
tree_pred$p1 <- ifelse(tree_pred[,2] > 0.5,1,0)
colnames(tree_pred) <- c("prob0", "prob1", "troll", "predicted")

tree_err_rate <-1-mean(tree_pred[,3] == tree_pred[,4])
tree_sens <- mean(tree_pred[tree_pred$troll == 1,]$troll == tree_pred[tree_pred$troll == 1,]$predicted)
tree_spec <- mean(tree_pred[tree_pred$troll == 0,]$troll == tree_pred[tree_pred$troll == 0,]$predicted)

tree_auc <- roc(tree_pred$troll, tree_pred$prob1)$auc[1]
tree_err_rate; tree_sens; tree_spec;tree_auc

###
#### LOGISTIC REGRESSION 
### 

logistic_fit1 <- glm(troll ~ t_sent, family = quasibinomial(link = "logit"), 
                     data=train,
                     weights=weights)

log1_pred <- predict(logistic_fit1, test, type="response") %>% as.data.frame() %>% cbind(test$troll) %>% as.tbl()
log1_pred$p1 <- ifelse(log1_pred[,1] > 0.5,1,0)
colnames(log1_pred) <- c("prob1", "troll", "predicted")

log1_err_rate <- 1 - mean(log1_pred$predicted == log1_pred$troll)
log1_sens <- mean(log1_pred[log1_pred$troll == 1,]$troll == log1_pred[log1_pred$troll == 1,]$predicted)
log1_spec <- mean(log1_pred[log1_pred$troll == 0,]$troll == log1_pred[log1_pred$troll == 0,]$predicted)
log1_auc <- roc(log1_pred$troll, log1_pred$prob1)$auc[1]

plot(roc(log1_pred$troll, log1_pred$prob1))
# PART 2

weights2 = ifelse(train$troll == 1,2,1)
data$badwords

log2 <- glm(troll~t_sent+followersCount00+listedCount00+user_m+imagedefault+
                      friendsCount00+badwords+user_w, 
      data=train,
      weights=weights,
      family = quasibinomial(link = "logit")
)

summary(log2)

log2_pred <- predict(log2, test) %>% as.data.frame() %>% cbind(test$troll) %>% as.tbl()

colnames(log2_pred) <- c("predicted", "troll")

log2_err_rate <- 1 - mean(log2_pred$predicted == log2_pred$troll)
log2_sens <- mean(log2_pred[log2_pred$troll == 1,]$troll == log2_pred[log2_pred$troll == 1,]$predicted)
log2_spec <- mean(log2_pred[log2_pred$troll == 0,]$troll == log2_pred[log2_pred$troll == 0,]$predicted)
log2_auc <- roc(log2_pred$troll, predict(log2, test, type = "response"))$auc[1]



log2_residuals <- predict(log2, train, type="response") %>% 
        cbind(train$troll) %>% as.data.frame()
colnames(log2_residuals) <- c("prob", "troll")

log2_residuals <- log2_residuals %>%
        as.data.frame() %>% 
        mutate(residual = troll - prob) %>%
        arrange(prob)


plot(log2_residuals$prob, log2_residuals$residual,
     xlab="Predicted Probabilities", ylab = "Residuals",
     pch = 19, col = rgb(0.5,0,0,0.35))
loess_fit <- loess(log2_residuals$residual ~ log2_residuals$prob)
lines(log2_residuals$prob, predict(loess_fit), col = "steelblue", type='l', pch=19, lwd=5)

summary(log2)



#plot(logistic_fit1)[1]
names(log2)
summary(log2)$deviance # on 218 df
summary(log2)$df.residual
summary(logistic_fit1)$deviance
summary(logistic_fit1)$df.residual

1 - pchisq(summary(logistic_fit1)$deviance - summary(log2)$deviance, 
       summary(logistic_fit1)$df.residual - summary(log2)$df.residual)



str(summary(log2))

log2$deviance


###
#### SVM - removed
### 

###
#### FOREST - removed
### 

###
#### KNN -removed
###

###
#### CNN -removed
###

