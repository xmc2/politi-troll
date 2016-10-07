# visuals
library(ggplot2)
source('editing.R')


boxplot(t1_sent ~ data$troll, data=data, col="blue", xlab="Troll", ylab="sentiment score",
        main="most recent tweet")



colnames(data)
?boxplot


summary(data$troll)

colnames(data)
ggplot(reviews_sentiment, aes(stars, sentiment, group = stars)) +
        geom_boxplot() +
        ylab("Average sentiment score")
