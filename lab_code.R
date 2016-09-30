process <- read_csv('process.csv')
for_lab <- process[1:10,]
write.csv(for_lab, "for_lab.csv")
