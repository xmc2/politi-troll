library(rvest); library(readr)
library(dplyr)


table_url = "http://unicode.org/emoji/charts/full-emoji-list.html"
population <- table_url %>%
        read_html() %>%
        html_nodes(xpath='/html/body/div[3]/table') %>%
        html_table() %>% as.data.frame()

head(population)

# getting rid of weird headings in the middle of the dataframe...
population <- population[!(population$X. == "№"), ]
population <- select(population, -Chart, -Apple, -Goog., -Twtr., -One, -FBM, -Wind., -Sams., -GMail,
                     -SB, -DCM, -KDDI, -Name) %>%
        write_csv("dictionaries/emoji.csv")