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


