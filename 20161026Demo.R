## Use R to get 1111 positions
library(rvest)
link <-'http://www.1111.com.tw/job-bank/job-index.asp?ss=s&tt=1,2,4,16&wc=100100&t0=140100&si=1&ps=40&trans=1'
page <- read_html(link)

## Parse 1111 html
ul   <- page %>% html_nodes('dd ul')
datechange <- ul  %>% html_nodes('.showDatechangeCss') %>% html_text()
position   <- ul  %>% html_nodes('.showPositionCssA') %>% html_text()
organ      <- ul  %>% html_nodes('.showOrganCssA') %>% html_text()
workcity   <- ul  %>% html_nodes('.showWorkcityCss') %>% html_text()
recruit    <- ul  %>% html_nodes('.showGradeExperienceCssA a') %>% html_text()
link       <- ul  %>% html_nodes('.showPositionCssA a') %>% html_attr('href')

## Combine all vectors into a data frame
jobs       <- data.frame(datechange = datechange, 
                           position = position, 
                              organ = organ,
                           workcity = workcity,
                            recruit = recruit,
                               link = link)

## View crawled data from 1111
View(jobs)