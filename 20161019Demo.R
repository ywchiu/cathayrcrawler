## Use Rvest to Get Apple Daily
library("rvest")
apple <- read_html('http://www.appledaily.com.tw/realtimenews/section/new/', encoding = 'UTF-8')
as.character(apple)


library("httr")
apple2 <- GET('http://www.appledaily.com.tw/realtimenews/section/new/', encoding = 'UTF-8')
content(apple2)


## Use httr GET to get Taobao
library("httr")
taobao <- GET('https://world.taobao.com/search/json.htm?navigator=all&cat=1512&_ksTS=1476846144748_41&spm=a21bp.7806943.banner_TW_cat.416.th4IfR&_input_charset=utf-8&json=on&callback=__jsonp_cb&abtest=_AB-LR517-LR854-LR895-PR517-PR854-PR895&nid=&type=&uniqpid=')
content(taobao)

## Use httr POST to get High Speed Rails
library("httr")
url     <- 'https://www.thsrc.com.tw/tw/TimeTable/SearchResult'
payload <- list(
  StartStation = '977abb69-413a-4ccf-a109-0272c24fd490',
  EndStation   = 'fbd828d8-b1da-4b06-a3bd-680cdca4d2cd',
  SearchDate   = '2016/10/19',
  SearchTime   = '12:00',
  SearchWay    = 'DepartureInMandarin'
  
) 
hsr <- POST(url, body = payload, encode = "form")
## magrittr
hsr %>% iconv(from='UTF-8', to='UTF-8')

## normal use
iconv(hsr, from='UTF-8', to='UTF-8')




sample_html <- '
<html>
  <body>
    <h1 id="title">Hello World</h1>
    <a href="#"class="link">This is link1</a>
    <a href="# link2"class="link">This is link2</a>
  </body>
</html>
'

page <- read_html(sample_html)

# Based on tag name
html_text(html_nodes(page, 'h1'))
html_text(html_nodes(page, 'a' ))



# Based on ID => Begins with #
html_text(html_nodes(page, '#title' ))

# Based on CLASS => Begins with .
html_text(html_nodes(page, '.link' ))



# Without Magrittr
sum(tail(head(iris),3)$Sepal.Length)

# With Magrittr
iris %>% 
  head() %>% 
  tail(3) %>% 
  .$Sepal.Length %>% 
  sum()


# Based on tag name, revise with Magrittr
## html_text(html_nodes(page, 'h1'))
page %>% html_nodes('h1') %>% html_text()

## html_text(html_nodes(page, 'a' ))
page %>% html_nodes('a') %>% html_text()



library("rvest")
# 讀取蘋果網頁
apple <- read_html('http://www.appledaily.com.tw/realtimenews/section/new/', encoding = 'UTF-8')

# 取得列表 class="rtddt" 下的 a 連結
rtddt <- apple %>% html_nodes('.rtddt a')

# 查詢列表第一列抓取到的內容
as.character(rtddt[1])

'<a href=\"/realtimenews/article/international/20161019/970976/Note7用戶集體控告三星　要求損失賠償金\" target=\"_blank\">
   <time>14:54</time>
   <h2>國際</h2>
   <h1><font color=\"#383c40\">Note7用戶集體控告三星　要求損失賠償...(0)</font></h1>
 </a>'

# 分別取得 time, h2, h1
dt        <- rtddt %>% html_nodes('time') %>% html_text()
category  <- rtddt %>% html_nodes('h2')   %>% html_text()
title     <- rtddt %>% html_nodes('h1')   %>% html_text()

# 將資料合併為 data.frame
applenews <- data.frame(dt = dt, category = category, title = title)
View(applenews)

# 抽出連結
link   <- rtddt %>% html_attr('href')

domain <- 'http://www.appledaily.com.tw'
link   <-  paste(domain, link, sep = '')

# 將資料合併為 data.frame
applenews <- data.frame(dt = dt, category = category, title = title, link = link)
View(applenews)

# 使用DataFrame 處理、分析資料
applenews[applenews$category == '娛樂','title']

# 抽出屬性範例
read_html("<a qoo=123 age=12 href='#'></a>") %>%
     html_nodes('a') %>% 
     html_attr('href')


# 取得內文資訊
appleurl <- 'http://www.appledaily.com.tw/realtimenews/article/entertainment/20161019/970743/【驚嚇片】Note7完換蘋果？！郭書瑤爆「iPhone耳機漏電」'
detail <- read_html(appleurl) 

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


# 使用函式存萃取資料
appleurl <- 'http://www.appledaily.com.tw/realtimenews/article/entertainment/20161019/970743/【驚嚇片】Note7完換蘋果？！郭書瑤爆「iPhone耳機漏電」'
df <- getArticle(appleurl, '娛樂')



# 取得頁面函式
newsurl <- 'http://www.appledaily.com.tw/realtimenews/section/new/'
domain  <- 'http://www.appledaily.com.tw'

getUrl <- function(newsurl){
  rtddt <- read_html(newsurl) %>%
    html_nodes('.rtddt a')
  
  dfall <- data.frame()
  for (ele in rtddt){
       url       <- ele %>% html_attr('href') 
       url       <- paste(domain, url , sep='')
       category  <- ele %>% html_nodes('h2') %>% html_text()   
       df        <- getArticle(url, category)
       dfall     <- rbind(dfall, df)
  }
  dfall
}


applenews <- getUrl(newsurl)
View(applenews)