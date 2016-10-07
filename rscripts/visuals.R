# visuals
library(ggplot2)
source('rscripts/editing.R')


boxplot(t1_sent ~ data$troll, data=data, col="blue", xlab="Troll", ylab="sentiment score",
        main="most recent tweet")


