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


## Make the parser as a function
parsePage <- function(link){
  
  page <- read_html(link)
  
  ul   <- page %>% html_nodes('dd ul')
  datechange <- ul  %>% html_nodes('.showDatechangeCss') %>% html_text()
  position   <- ul  %>% html_nodes('.showPositionCssA') %>% html_text()
  organ      <- ul  %>% html_nodes('.showOrganCssA') %>% html_text()
  workcity   <- ul  %>% html_nodes('.showWorkcityCss') %>% html_text()
  recruit    <- ul  %>% html_nodes('.showGradeExperienceCssA a') %>% html_text()
  link       <- ul  %>% html_nodes('.showPositionCssA a') %>% html_attr('href')
  
  jobs       <- data.frame(datechange = datechange, 
                           position = position, 
                           organ = organ,
                           workcity = workcity,
                           recruit = recruit,
                           link = link)
  jobs
}

### Get first page
link <- 'http://www.1111.com.tw/job-bank/job-index.asp?ss=s&tt=1,2,4,16&wc=100100&t0=140100&si=1&ps=40&trans=1'
df   <- parsePage(link)

### Get second page
link2 <- 'http://www.1111.com.tw/job-bank/job-index.asp?ss=s&tt=1,2,4,16&wc=100100&t0=140100&si=1&ps=40&trans=1&page=2'
df2   <- parsePage(link2)

#### for loop
for (i in seq(1,10)){
  print(i)
}

#### lapply, apply a function to every element within a vector
lapply(1:10, function(e){e})


a <- list(c(1,2,3,4), c(5,6,7))
lapply(a, sum)
sapply(a, sum)




### Use for loop to get 10 pages
dfall <- data.frame()
for (i in seq(1,10)){
  link  <- 'http://www.1111.com.tw/job-bank/job-index.asp?ss=s&tt=1,2,4,16&wc=100100&t0=140100&si=1&ps=40&trans=1&page='
  link  <- paste(link, i, sep='')
  df    <- parsePage(link)
  dfall <- rbind(dfall, df) 
}


### Use lapply to get 10 pages
dfall2 <- lapply(1:10, function(i){
  link  <- 'http://www.1111.com.tw/job-bank/job-index.asp?ss=s&tt=1,2,4,16&wc=100100&t0=140100&si=1&ps=40&trans=1&page='
  link  <- paste(link, i, sep='')
  df    <- parsePage(link)
  df
  })
dfs <- do.call('rbind', dfall2)

