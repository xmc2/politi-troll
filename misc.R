# misc

y <- twListToDF(userTimeline('mattcol3',n=3))
x <- twListToDF(lookupUsers('mattcol3'))

colnames(x) <- ifelse(colnames(x) == "screenName",colnames(x), paste(colnames(x),1,sep=""))
z <- full_join(y, x, by = "screenName")
colnames(z)
