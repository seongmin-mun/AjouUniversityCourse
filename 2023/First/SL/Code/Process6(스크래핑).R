
#참고자료
#R
#https://insightteller.tistory.com/entry/R%EB%A1%9C-%ED%81%AC%EB%A1%A4%EB%A7%81%ED%95%98%EA%B8%B0-%EB%B3%B4%EB%B0%B0%EB%93%9C%EB%A6%BC-%EC%98%88%EC%A0%9C

#참고 사이트
#python
#http://astralworld58.tistory.com/75
#https://beomi.github.io/2017/01/20/HowToMakeWebCrawler-With-Login/

#R
#http://henryquant.blogspot.com/2018/07/r-kospi-pbr.html
#http://www.rpubs.com/mannerist/93601




# 웹에 있는 데이터를 가져오는 단계
# HTTP(Hyper Text Transfer Protocol)은 사용자와 웹서버 사이에 정보를 주고 받는 규약
# HTTP에 의한 웹서버를 호출하는 통신방식은 시작, 헤더, 본문으로 구성됨
# 주 요청방식: GET과 POST 방식
# GET: 모든 정보를 URL주소 (웹브라우저의 주소창을 이용)를 이용, 즉 헤더에 모든 정보를 담아 요청
# POST: 본문(body)에 요청정보를 추가하여 숨김
# 추출 및 저장
# 파싱(parsing): 웹문서에서 필요 부분만 추출하는 과정
# 비구조화된 웹문서를 가공하여 구조화된 데이터를 만들기 위함


































#allocine에서 영화 리뷰수집하기

#rvest와 dplyr를 사용하여 기사 가져오기
#memory & previous_works
gc()
rm(list=ls())
#Encoding_mac
Sys.setlocale(category = "LC_CTYPE", locale = "ko_KR.UTF-8")
#Window운영체제
#options(Encoding = "UTF-8")

#install.packages("rvest")
library(rvest)

#내가 수집하길 원하는 페이지 주소 
url <- "https://www.allocine.fr/film/aucinema/" 
aucinemaPage<- read_html(url) #해당 url 페이지의 html tag를 가져와서 parsing함. 
aucinemaPage


#parsing한 newsPage에서 css가 "news_tit" 인 것을 찾아라. 
movieInfos <- html_nodes(aucinemaPage, css=".gd-col-left") 
head(movieInfos)

# install.packages("dplyr")
library(dplyr)

# 내일 자세하게 다루어질 예정이다.

# %>% (파이프 연산자)의 형식으로 영화 제목에 접근할 수 있게 해준다.
movieTitle <- movieInfos[1] %>% html_nodes("ul") %>% html_nodes("li") %>% html_nodes("a.meta-title-link") %>% html_text(); movieTitle 

# 영화 링크
movieLinks <- movieInfos[1] %>% html_nodes("ul") %>% html_nodes("li") %>% html_nodes("a.meta-title-link") %>% html_attr('href'); movieLinks

# 영화들에 대한 HTML list
movies <- movieInfos[1] %>% html_nodes("ul") %>% html_nodes("li") %>% html_nodes("div.meta-body-item.meta-body-info")




for(i in 1:length(movies)){
  eachMovie <- movies[i] %>% html_children() %>% html_text()
  print(eachMovie)
}



moviesInfo <- NULL
for(i in 1:length(movies)){
  eachMovie <- movies[i] %>% html_children() %>% html_text()
  eachMovieInfo <- NULL
  for(j in 1:length(eachMovie)){
    eachMovieInfo <- paste(eachMovieInfo,eachMovie[j],sep=" ")
  }
  moviesInfo <- c(moviesInfo,eachMovieInfo)
}
print(moviesInfo)



setwd("/Users/seongminmun/Desktop/Class/Advanced/Data")
getwd()
dir()

moviesInfoDF <- data.frame(title=movieTitle, info=moviesInfo, links=movieLinks); moviesInfoDF


















for(i in 1:length(movieLinks)){
  print(movieLinks[i])
}


for(i in 1:length(movieLinks)){
  print(paste("https://www.allocine.fr",movieLinks[i],sep=""))
}

#https://www.allocine.fr/film/fichefilm_gen_cfilm=300.html
#->
#실제 리뷰를 확인하는 사이트
#https://www.allocine.fr/film/fichefilm-300/critiques/spectateurs/


#영화의 번호를 추출
movieNumbers <- NULL
for(i in 1:length(movieLinks)){
  cleaningStep1 <- gsub("/film/fichefilm_gen_cfilm=","",movieLinks[i])
  cleaningStep2 <- gsub(".html","",cleaningStep1)
  print(cleaningStep2)
  movieNumbers <- c(movieNumbers, cleaningStep2)
}
print(movieNumbers)


moviesInfoDF_2 <- cbind(moviesInfoDF,movieNumbers); moviesInfoDF_2 



#영화 리뷰만을 정리해서 보여주는 링크
reviewLinks <- NULL
for(i in 1:length(moviesInfoDF_2$movieNumbers)){
  reviewLink <- paste("https://www.allocine.fr/film/fichefilm-",moviesInfoDF_2$movieNumbers[i],"/critiques/spectateurs/",sep="")
  print(reviewLink)
  reviewLinks <- c(reviewLinks,reviewLink)
}
print(reviewLinks)

moviesInfoDF_3 <- cbind(moviesInfoDF_2,reviewLinks); moviesInfoDF_3

#페이지 확인
#https://www.allocine.fr/film/fichefilm-300/critiques/spectateurs/
#https://www.allocine.fr/film/fichefilm-300/critiques/spectateurs/?page=2


url <- "https://www.allocine.fr/film/fichefilm-173087/critiques/spectateurs/" 
aucinemaPage<- read_html(url) #해당 url 페이지의 html tag를 가져와서 parsing함. 
aucinemaPage


movieHTML <- html_nodes(aucinemaPage, css="#content-layout") 
head(movieHTML)

# install.packages("dplyr")
library(dplyr)
library(stringr)

# 영화제목
movieTitle <- movieHTML[1] %>% html_nodes("div.titlebar") %>% html_text(); movieTitle[1]

# 평점
movieScore <- movieHTML[1] %>% html_nodes("span.note") %>% html_text(); movieScore

#영화리뷰
movieReviws <- movieHTML[1] %>% html_nodes("section.section") %>% html_nodes("div.content-txt.review-card-content") %>% html_text(); movieReviws



moviePages <- movieHTML[1] %>% html_nodes("div.pagination-item-holder") %>% html_text(); moviePages

# moviePages
# 
# str_replace_all(moviePages , "[^1-9]", " ")
# 
# str_replace_all(str_trim(str_replace_all(moviePages , "[^1-9]", " ")), "\\s+", " ")
# 
# strsplit(str_replace_all(str_trim(str_replace_all(moviePages , "[^1-9]", " ")), "\\s+", " ")," ")[[1]][-1]

lastPageNumber <- strsplit(str_replace_all(str_trim(str_replace_all(moviePages , "[^1-9]", " ")), "\\s+", " ")," ")[[1]]; lastPageNumber
lastPageNumber <- lastPageNumber[length(lastPageNumber)]; lastPageNumber
# lastPageNumber <- unlist(str_split(str_replace_all(moviePages , "[^1-9]", " "), "    ", 2))[2]

# lastPageNumber <- strsplit(moviePages,split="...")[[1]][length(strsplit(moviePages,split="...")[[1]])]





movieReviewAll = NULL
for(i in 1:lastPageNumber){
  Sys.sleep(1) 
  url <- paste("https://www.allocine.fr/film/fichefilm-300/critiques/spectateurs/?page=", as.character(i), sep="")
  aucinemaPage<- read_html(url) #해당 url 페이지의 html tag를 가져와서 parsing함. 
  aucinemaPage
  movieHTML <- html_nodes(aucinemaPage, css="#content-layout") 
  head(movieHTML)
  # install.packages("dplyr")
  library(dplyr)
  movieReviws <- movieHTML[1] %>% html_nodes("section.section") %>% html_nodes("div.content-txt.review-card-content") %>% html_text(); movieReviws
  movieReviewAll <- c(movieReviewAll, gsub("\n","",movieReviws))
}
print(movieReviewAll)



write.csv(movieReviewAll, paste("movies_",movieTitle[1],".txt",sep=""), fileEncoding="UTF-8")










# 
# # 더 많은 영화 수집하기
# 
# movieTitleAll <- NULL
# movieLinksAll <- NULL
# moviesDateAll <- NULL
# moviesGenreAll <- NULL
# movieNumbersAll <- NULL
# reviewLinksAll <- NULL
# 
# for(i in 1:10){
#   url <- paste("https://www.allocine.fr/film/aucinema/?page=",as.character(i),sep="")
#   aucinemaPage<- read_html(url)
#   movieInfos <- html_nodes(aucinemaPage, css=".gd-col-left") 
#   movieTitle <- movieInfos[1] %>% html_nodes("ul") %>% html_nodes("li") %>% html_nodes("a.meta-title-link") %>% html_text(); movieTitle 
#   movieLinks <- movieInfos[1] %>% html_nodes("ul") %>% html_nodes("li") %>% html_nodes("a.meta-title-link") %>% html_attr('href'); movieLinks
#   movies <- movieInfos[1] %>% html_nodes("ul") %>% html_nodes("li") %>% html_nodes("div.meta-body-item.meta-body-info")
#   
#   moviesDate <- NULL
#   moviesGenre <- NULL
#   for(j in 1:length(movies)){
#     eachMovie <- movies[j] %>% html_children() %>% html_text()
#     eachMovieInfo <- NULL
#     for(k in 1:length(eachMovie)){
#       eachMovieInfo <- paste(eachMovieInfo,eachMovie[k],sep=" ")
#     }
#     eachMovieInfoSplit <- strsplit(eachMovieInfo," / / ")
#     moviesDate <- c(moviesDate,eachMovieInfoSplit[[1]][1])
#     moviesGenre <- c(moviesGenre,eachMovieInfoSplit[[1]][2])
#   }
#   
#   cleaningStep1 <- gsub("/film/fichefilm_gen_cfilm=","",movieLinks)
#   cleaningStep2 <- gsub(".html","",cleaningStep1)
#   
#   reviewLink <- paste("https://www.allocine.fr/film/fichefilm-",cleaningStep2,"/critiques/spectateurs/",sep="")
#   
#   movieTitleAll <- c(movieTitleAll,movieTitle)
#   moviesDateAll <- c(moviesDateAll,moviesDate)
#   moviesGenreAll <- c(moviesGenreAll,moviesGenre)
#   movieNumbersAll <- c(movieNumbersAll, cleaningStep2)
#   movieLinksAll <- c(movieLinksAll,movieLinks)
#   reviewLinksAll <- c(reviewLinksAll,reviewLink)
#   
# }
# 
# setwd("/Users/seongminmun/Desktop/Class/Advanced/Data")
# getwd()
# dir()
# 
# moviesInfoAllDF <- data.frame(title=movieTitleAll, date=moviesDateAll, genre=moviesGenreAll, number=movieNumbersAll, link=movieLinksAll, reviewLink=reviewLinksAll); moviesInfoAllDF
# 
# write.csv(moviesInfoDF, "moviesInfoAllDF_10.csv", fileEncoding="UTF-8")
# dir()












# 
# reviewLinksAll6_10 <- reviewLinksAll[6:10]; reviewLinksAll6_10
# 
# 
# for (i in 1:length(reviewLinksAll)){
#   url <- paste(reviewLinksAll[i],"?page=",as.character(i),sep="") 
#   aucinemaPage<- read_html(url) 
#   
#   movieHTML <- html_nodes(aucinemaPage, css="#content-layout") 
#   
#   # install.packages("dplyr")
#   library(dplyr)
#   
#   movieTitle <- movieHTML[1] %>% html_nodes("div.titlebar") %>% html_text(); movieTitle[1]
#   
#   movieScore <- movieHTML[1] %>% html_nodes("span.note") %>% html_text(); movieScore
#   
#   movieReviws <- movieHTML[1] %>% html_nodes("section.section") %>% html_nodes("div.content-txt.review-card-content") %>% html_text(); movieReviws
#   
#   moviePages <- movieHTML[1] %>% html_nodes("div.pagination-item-holder") %>% html_text(); moviePages
#   
#   lastPageNumber <- strsplit(str_replace_all(str_trim(str_replace_all(moviePages , "[^1-9]", " ")), "\\s+", " ")," ")[[1]][-1]
#   lastPageNumber <- lastPageNumber[length(lastPageNumber)]
#   # lastPageNumber <- unlist(str_split(str_replace_all(moviePages , "[^1-9]", " "), "    ", 2))[2]
#   
#   # lastPageNumber <- strsplit(moviePages,split="...")[[1]][length(strsplit(moviePages,split="...")[[1]])]
#   
#   movieReviewAll = NULL
#   for(j in 1:lastPageNumber){
#     url <- paste("https://www.allocine.fr/film/fichefilm-",movieNumbersAll[i],"/critiques/spectateurs/?page=", as.character(j), sep="")
#     aucinemaPage<- read_html(url) #해당 url 페이지의 html tag를 가져와서 parsing함. 
#     aucinemaPage
#     movieHTML <- html_nodes(aucinemaPage, css="#content-layout") 
#     head(movieHTML)
#     # install.packages("dplyr")
#     library(dplyr)
#     movieReviws <- movieHTML[1] %>% html_nodes("section.section") %>% html_nodes("div.content-txt.review-card-content") %>% html_text(); movieReviws
#     movieReviewAll <- c(movieReviewAll, gsub("\n","",movieReviws))
#   }
#   
#   write.csv(movieReviewAll, paste("movies_",movieTitle[1],".txt",sep=""), fileEncoding="UTF-8")
#   
#   close(aucinemaPage)
# }












































# 생각하기
# 크롤링은 불법인가?















#카카오맵 데이터 가져오기

#참고자료
#R
#https://cran.r-project.org/web/packages/RSelenium/RSelenium.pdf

#selenium standalone server: http://selenium-release.storage.googleapis.com/index.html 
#gecko driver: https://github.com/mozilla/geckodriver/releases/tag/v0.17.0 
#chrome driver: https://sites.google.com/a/chromium.org/chromedriver/
#java -Dwebdriver.chrome.driver="chromedriver" -jar selenium-server-standalone-4.0.0-alpha-1.jar -port 4445
#java -Dwebdriver.gecko.driver="geckodriver" -jar selenium-server-standalone-4.0.0-alpha-1.jar -port 4445
#memory & previous_works
gc()
rm(list=ls())
#Encoding_mac
Sys.setlocale(category = "LC_CTYPE", locale = "ko_KR.UTF-8")
#Window운영체제
#options(Encoding = "UTF-8")

# dyn.load('/Library/Java/JavaVirtualMachines/jdk1.8.0_241.jdk/Contents/Home/jre/lib/server/libjvm.dylib')

# install.packages("RSelenium")
library(RSelenium) 
library(rvest) 



binman::rm_platform("phantomjs")
pJS <- wdman::phantomjs(port = 4567L)
remDr <- remoteDriver(remoteServerAddr = 'localhost',
                      port =4567L, # 포트번호 입력
                      browserName = "chrome")
remDr$open()

remDr$setWindowSize(1280L, 1024L)

#메인 페이지로 접속하기
remDr$navigate("https://map.kakao.com/")
remDr$screenshot(display = T)
Sys.sleep(1) 



#텍스트 입력하기
webElem <- remDr$findElement(using = "xpath", value='//*[@id="search.keyword.query"]')
webElem$clickElement()
remDr$screenshot(display = T)
Sys.sleep(1) 



# webElem <- remDr$findElement(using = "xpath", value='//*[@id="search.tab2"]/a')
# webElem$clickElement()
# remDr$screenshot(display = T)
# Sys.sleep(1) 


webElem$sendKeysToElement(list("아주대 맛집"))
remDr$screenshot(display = T)
Sys.sleep(1) 


# webElem$sendKeysToElement(list(key = "enter"))
# remDr$screenshot(display = T)
# 
# webElem <- remDr$findElement(using = "xpath", value='//*[@id="search.keyword.submit"]')
# webElem$clickElement()
# remDr$screenshot(display = T)
# # Sys.sleep(1) 




























































#네이버 뉴스 수집하기
#rvest와 dplyr를 사용하여 기사 가져오기
#memory & previous_works
gc()
rm(list=ls())
#Encoding_mac
Sys.setlocale(category = "LC_CTYPE", locale = "ko_KR.UTF-8")
#Window운영체제
#options(Encoding = "UTF-8")

#install.packages("rvest")
library(rvest)

#내가 수집하길 원하는 페이지 주소 
url <- "https://search.naver.com/search.naver?where=news&sm=tab_jum&query=프랑스" 
newsPage<- read_html(url) #해당 url 페이지의 html tag를 가져와서 parsing함. 
newsPage


#parsing한 newsPage에서 css가 "news_tit" 인 것을 찾아라. 
newsInfos <- html_nodes(newsPage, css=".group_news") 
head(newsInfos)

# install.packages("dplyr")
library(dplyr)

# 내일 자세하게 다루어질 예정이다.

# %>% (파이프 연산자)의 형식으로 뉴스 제목에 접근할 수 있게 해준다.
newsTitle <- newsInfos[1] %>% html_nodes("ul") %>% html_nodes("li") %>% html_nodes("a.news_tit") %>% html_text()

# 뉴스 보도사
newsMedium <- newsInfos[1] %>% html_nodes("ul") %>% html_nodes("li") %>% html_nodes("div.info_group") %>% html_nodes("a.info.press") %>% html_text()

# 보도 일자
newsDate <- newsInfos[1] %>% html_nodes("ul") %>% html_nodes("li") %>% html_nodes("div.info_group") %>% html_nodes("span.info") %>% html_text()

# 뉴스 기사 링크
newsLinks <- newsInfos[1] %>% html_nodes("ul") %>% html_nodes("li") %>% html_nodes("a.news_tit") %>% html_attr('href')

# 뉴스 기사 요약
newsContents <- newsInfos[1] %>% html_nodes("ul") %>% html_nodes("li") %>% html_nodes("div.news_dsc") %>% html_text()


setwd("/Users/seongminmun/Desktop/Class/Advanced/Data")

newsDF <- data.frame(title=newsTitle, medium=newsMedium, date=newsDate, links=newsLinks, contents=newsContents); newsDF 

write.csv(newsDF, "newsDF_프랑스.csv", fileEncoding="UTF-8")
dir()




newsDFCsv <- read.csv("newsDF_프랑스.csv", header=TRUE, fileEncoding="UTF-8")
newsDFCsv





















# 유럽 나라별 수도 기사 최대한 많이 가져오기

#rvest와 dplyr를 사용하여 기사 가져오기
#memory & previous_works
gc()
rm(list=ls())
#Encoding_mac
Sys.setlocale(category = "LC_CTYPE", locale = "ko_KR.UTF-8")
#Window운영체제
#options(Encoding = "UTF-8")

library(stringr)

setwd("/Users/seongminmun/Desktop/Class/Advanced/Data")

dir()

EuropeCapital <- read.table("EuropeCapitalSplit.txt")


countryList <- NULL
capitalList <- NULL
continentClassList <- NULL
for(i in 1:length(EuropeCapital$V1)){
  countryList <- c(countryList, strsplit(EuropeCapital[i,1],"-")[[1]][1])
  capitalList <- c(capitalList, strsplit(EuropeCapital[i,1],"-")[[1]][2])
  continentClassList <- c(continentClassList, strsplit(EuropeCapital[i,1],"-")[[1]][3])
}
print(countryList)
print(capitalList)
print(continentClassList)


EuropeCapital <- cbind(EuropeCapital,countryList,capitalList,continentClassList); EuropeCapital













#install.packages("rvest")
library(rvest)
library(dplyr)


#내가 수집하길 원하는 페이지 주소 
url <- paste("https://search.naver.com/search.naver?where=news&sm=tab_jum&query=",countryList[2],sep="")
newsPage<- read_html(url) #해당 url 페이지의 html tag를 가져와서 parsing함. 
newsPage


#parsing한 newsPage에서 css가 "news_tit" 인 것을 찾아라. 
newsInfos <- html_nodes(newsPage, css=".group_news") 
head(newsInfos)

# install.packages("dplyr")
library(dplyr)

# %>% (파이프 연산자)의 형식으로 뉴스 제목에 접근할 수 있게 해준다.
newsTitle <- newsInfos[1] %>% html_nodes("ul") %>% html_nodes("li") %>% html_nodes("a.news_tit") %>% html_text()
# 뉴스 기사 요약
newsContents <- newsInfos[1] %>% html_nodes("ul") %>% html_nodes("li") %>% html_nodes("div.news_dsc") %>% html_text()

newsDF <- data.frame(title=newsTitle, contents=newsContents); newsDF 


















# 새로운 페이지 크롤링
newsPageInfos <- html_nodes(newsPage, css=".sc_page_inner") 
head(newsPageInfos)
# 페이지 링크
newsLinks <- newsPageInfos[1] %>% html_nodes("a") %>% html_attr('href')

newsLinks

url <- paste("https://search.naver.com/search.naver",newsLinks[2],sep="")
newsPage<- read_html(url) #해당 url 페이지의 html tag를 가져와서 parsing함. 
newsPage

#parsing한 newsPage에서 css가 "news_tit" 인 것을 찾아라. 
newsInfos <- html_nodes(newsPage, css=".group_news") 
head(newsInfos)

# 뉴스 제목
newsTitle <- newsInfos[1] %>% html_nodes("ul") %>% html_nodes("li") %>% html_nodes("a.news_tit") %>% html_text(); newsTitle

# 뉴스 기사 요약
newsContents <- newsInfos[1] %>% html_nodes("ul") %>% html_nodes("li") %>% html_nodes("div.news_dsc") %>% html_text(); newsContents















#유럽 나라별 기사 전체 수집하기

for(i in 1:length(countryList)){#length(capitalList
  Sys.sleep(1) 
  
  #내가 수집하길 원하는 페이지 주소 
  url <- paste("https://search.naver.com/search.naver?where=news&sm=tab_jum&query=",countryList[i],sep="")
  newsPage<- read_html(url) #해당 url 페이지의 html tag를 가져와서 parsing함. 
  newsPage
  
  # 새로운 페이지 크롤링
  newsPageInfos <- html_nodes(newsPage, css=".sc_page_inner") 
  head(newsPageInfos)
  # 페이지 링크
  newsPageLinks <- newsPageInfos[1] %>% html_nodes("a") %>% html_attr('href')
  
  newsTitleList <- NULL
  newsContentList <- NULL
  
  for(j in 1:length(newsPageLinks)){
    Sys.sleep(1) 
    
    url <- paste("https://search.naver.com/search.naver",newsPageLinks[j],sep="")
    newsPage<- read_html(url) #해당 url 페이지의 html tag를 가져와서 parsing함. 
    newsPage
    
    #parsing한 newsPage에서 css가 "news_tit" 인 것을 찾아라. 
    newsInfos <- html_nodes(newsPage, css=".group_news") 
    head(newsInfos)
    
    # 뉴스 제목
    newsTitle <- newsInfos[1] %>% html_nodes("ul") %>% html_nodes("li") %>% html_nodes("a.news_tit") %>% html_text()
    
    # 뉴스 기사 요약
    newsContents <- newsInfos[1] %>% html_nodes("ul") %>% html_nodes("li") %>% html_nodes("div.news_dsc") %>% html_text()
    
    for(k in 1:length(newsTitle)){
      newsTitleList <- c(newsTitleList, newsTitle[k]) 
      newsContentList <- c(newsContentList, newsContents[k])
    }
    
    
  }
  
  newsDF <- data.frame(title=newsTitleList, contents=newsContentList); newsDF 
  
  outputName <- paste("newsDF_",countryList[i],".csv",sep="")
  
  write.csv(newsDF, outputName, fileEncoding="UTF-8")
  
}

dir()












