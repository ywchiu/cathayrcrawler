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


# Apple News Retrieval

library(stringr)

# 建立函式
getArticle <- function(url, category){
  
  detail <- read_html(url) 
  
  # 取得內文
  article <- detail   %>% 
    html_nodes('.trans') %>%
    html_text()
  
  # 取得標題
  title <- detail   %>% 
    html_nodes('#h1') %>%
    html_text()
  
  # 取得時間
  dt <- detail %>%
    html_nodes('.gggs time') %>%
    html_text()
  
  # 取得人氣
  clicked <- detail %>%
    html_nodes('.clicked') %>%
    html_text()
  
  data.frame(title = title, article = article, category = category, dt = dt, clicked = clicked, stringsAsFactors = FALSE)
}

# 取得頁面函式
newsurl <- 'http://www.appledaily.com.tw/realtimenews/section/new/'
domain  <- 'http://www.appledaily.com.tw'

getUrl <- function(newsurl){
  rtddt <- read_html(newsurl) %>%
    html_nodes('.rtddt a')
  
  dfall <- data.frame()
  for (ele in rtddt){
    url       <- ele %>% html_attr('href') 
    #print(url)
    if (str_count(url, domain) == 0) {
      url       <- paste(domain, url , sep='')
      category  <- ele %>% html_nodes('h2') %>% html_text()   
      df        <- getArticle(url, category)
      dfall     <- rbind(dfall, df)
    }

  }
  dfall
}

applenews <- getUrl(newsurl)


## Use strsplit to segment words
strsplit(applenews[1,'article'], 'googletag')[[1]][1]

## use magrittr
applenews[1,'article'] %>% 
  strsplit('googletag') %>%
  .[[1]] %>%
  .[1] %>%
  trimws()

## Concatenate string 
paste('hello', 'world')
?paste
paste( 'hello', 'world', sep='')
paste0('hello', 'world')


a <- 'aaa@bbb@ccc'
strsplit(a, '@') %>% 
  .[[1]] %>% 
  paste(collapse='-')


## remove white space in between
applenews[1,'article'] %>% 
  strsplit('googletag') %>%
  .[[1]] %>%
  .[1] %>%
  trimws() %>%
  strsplit('[\n\r ]+') %>%
  .[[1]] %>%
  paste(collapse='')


## make clean string as a function
clearArticle <- function(article){
  article %>% 
  strsplit('googletag') %>%
  .[[1]] %>%
  .[1] %>%
  trimws() %>%
  strsplit('[\n\r ]+') %>%
  .[[1]] %>%
  paste(collapse='')
}
clearArticle(applenews[1,'article'])

## Regular Expression
a <- 'Hi, I am xxx, my phone number is 0912-345-678'

a <- 'Hi'
grep('H', a)

### Match Number
a <- '8'
grep('[0123456789]', a)  # 0 or 1 or 2 ... or 9
grep('[0-9]', a) # [0-9] => [0123456789]
grep('\\d', a) # \\d => [0-9]

### Match Alphabet
a <- 'y'
grep('[abcdefghijklmnopqrstuvwxyz]', a)  # a or b ... z
grep('[a-z]', a) # [a-z] => [abcde....z]

a <- 'Y'
grep('[a-zA-Z]', a) # [a-zA-Z] => [abcde....zA...Z]

### Match Alphanet and Numeric
grep('[a-zA-Z0-9]', a)
grep('\\w', a) # \\w => [a-zA-Z0-9]


a <- '$'
grep('.', a) # . Match any character


### Match multiple characters
a <- '0912345678'
grep('\\d{10}', a) # match exact 10 numeric


a <- '02111222'
grep('\\d{6,10}', a) # match 6 to 10 numerics

a <- '9487'
grep('\\d{1,}', a) # match 1 to Inf numerics
grep('\\d+', a) # + =? {1,}

grep('\\d{0,}', a) # match 0 to Inf numerics
grep('\\d*', a) # * =? {0,}


cell <- c('0912345678', 
          '0912-345678', 
          '0912-345-678', 
          '09123456789999999')

grep('\\d{10}', cell)
grep('\\d{4}-{0,1}\\d{3}-{0,1}\\d{3}', cell)
grep('\\d{4}-?\\d{3}-?\\d{3}', cell) # ? => {0,1}
grep('^09\\d{2}-?\\d{3}-?\\d{3}$', cell) # ^ match begin, $ match end


## match clicked
grep('.{2}\\(\\d+\\)', applenews[1,'clicked'])


a <- 'aaa@bbb@ccc'
gsub('(\\w+)@(\\w+)@\\w+', '\\2', a)

gsub('.{2}\\((\\d+)\\)', '\\1',applenews[1,'clicked'])
applenews[1,'clicked'] %>% gsub('.{2}\\((\\d+)\\)', '\\1', .)



## Clean Data
applenews$view_cnt <- applenews$clicked %>%
     gsub('.{2}\\((\\d+)\\)', '\\1', .) %>%
     as.numeric()


contentclean <- function(article){
  article %>% 
  strsplit('googletag') %>%
  .[[1]] %>%
  .[1] %>%
  trimws() %>%
  strsplit('[\n\r ]+') %>%
  .[[1]] %>%
  paste(collapse='')
}

applenews$clean_content <- 
  sapply(applenews$article, contentclean)


## Convert string to datetime
ds <-c("August 18, 2014 12:00")
x <-strptime(ds, "%B %d, %Y %H:%M")
x

b <- '2014-08-15'
x1 <- as.POSIXlt(as.Date(b))
x - x1
as.numeric(x - x1)


class(applenews[1, 'dt'])
strptime( applenews[1, 'dt'], '%Y年%m月%d日%H:%M')

applenews$dt1 <-
  strptime(applenews$dt, "%Y年%m月%d日%H:%M")
str(applenews)


## 取得分頁資訊

### get news for one page
applenews <- getUrl(newsurl)

### use for loop to get page of three pages
appledf <- data.frame()
for (i in 1:3){
  appleurl <- 'http://www.appledaily.com.tw/realtimenews/section/new/'
  df <- getUrl(paste0(appleurl,i))
  appledf <- rbind(appledf, df)
}


### use lapply to get page of three pages
apple_dfs <- lapply(1:10, function(i){
  appleurl <- 'http://www.appledaily.com.tw/realtimenews/section/new/'
  df <- getUrl(paste0(appleurl,i))
  df
})

applenews <- do.call('rbind', apple_dfs)

###  Convert Time
applenews$dt <-
  strptime(applenews$dt, "%Y年%m月%d日%H:%M")

###  Convert view_cnt from string to numeric
applenews$view_cnt <- applenews$clicked %>%
     gsub('.{2}\\((\\d+)\\)', '\\1', .) %>%
     as.numeric()

### clean main article
contentclean <- function(article){
  article %>% 
  strsplit('googletag') %>%
  .[[1]] %>%
  .[1] %>%
  trimws() %>%
  strsplit('[\n\r ]+') %>%
  .[[1]] %>%
  paste(collapse='')
}

applenews$content <- 
  sapply(applenews$article, contentclean)



### rbind
a <- c(1,2,3)
b <- c(2,3,4)
rbind(a,b)
cbind(a,b)


a.frame <-data.frame(x=c(1,2,3), b =c(2,3,4))
b.frame <-data.frame(x=c(3,3,2), b =c(1,2,3))
c.frame <-data.frame(x=c(3,3,2), b =c(1,2,3))

rbind(a.frame, b.frame, c.frame)
cbind(a.frame, b.frame, c.frame)

li <- list(a.frame, b.frame, c.frame)
do.call('rbind', li) #　rbind(a.frame, b.frame, c.frame)
do.call('cbind', li) #  cbind(a.frame, b.frame, c.frame)


## Save Applenews
save(x=applenews, file='applenews.RData')
write.csv(x=applenews, file='applenews.csv')

# Connect to Database
library(RSQLite)

con <-dbConnect(SQLite(), 'test.sqlite')
data(iris)
dbWriteTable(con, 'iris', iris)
dbListTables(con)
dbDisconnect(con)

### SendQuery
con <-dbConnect(SQLite(), 'test.sqlite')
dbListTables(con)
rs  <-dbSendQuery(con, 'SELECT * FROM iris')
d1  <-fetch(rs, n =10)
dbHasCompleted(rs)
#?dbHasCompleted
d2  <-fetch(rs, n =3)
d3  <-fetch(rs, n =-1)
dbHasCompleted(rs)
dbClearResult(rs)
dbDisconnect(con)

### GetQuery
con <-dbConnect(SQLite(), 'test.sqlite')
res <-dbGetQuery(con, 
      "SELECT Species, COUNT(*) 
         FROM iris 
     GROUP BY Species")
dbDisconnect(con)

### Write applenews into sqlite
applenews$dt <- as.POSIXct(applenews$dt)
con <-dbConnect(SQLite(), 'apple2.sqlite')
dbWriteTable(con, 'applenews', applenews)
dbListTables(con)
dbDisconnect(con)


con <-dbConnect(SQLite(), 'apple2.sqlite')
res <- dbGetQuery(con, 
        'SELECT category, AVG(view_cnt)
           FROM applenews
       GROUP BY category
       ORDER BY AVG(view_cnt) DESC')
View(res)


res2 <- dbGetQuery(con, 
        'SELECT title, view_cnt
           FROM applenews
       ORDER BY view_cnt DESC')
View(res2)
dbDisconnect(con)
