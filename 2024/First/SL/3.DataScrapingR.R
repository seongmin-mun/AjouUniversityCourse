


# 웹에 있는 데이터를 가져오는 단계
# HTTP(Hyper Text Transfer Protocol)은 사용자와 웹서버 사이에 정보를 주고 받는 규약
# HTTP에 의한 웹서버를 호출하는 통신방식은 시작, 헤더, 본문으로 구성됨
# 주 요청방식: GET과 POST 방식
# GET: 모든 정보를 URL주소 (웹브라우저의 주소창을 이용)를 이용, 즉 헤더에 모든 정보를 담아 요청
# POST: 본문(body)에 요청정보를 추가하여 숨김
# 추출 및 저장
# 파싱(parsing): 웹문서에서 필요 부분만 추출하는 과정
# 비구조화된 웹문서를 가공하여 구조화된 데이터를 만들기 위함




# 생각하기
# 크롤링은 불법인가?




#네이버 검색 결과 수집하기
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
url <- "https://search.naver.com/search.naver?nso=&page=2&query=수원총선결과&sm=tab_pge&start=1&where=web" 
searchPage<- read_html(url) 
searchPage


searchInfos <- html_nodes(searchPage, css=".lst_total") 
head(searchInfos)

# install.packages("dplyr")
library(dplyr)


# 제목
infoTitle <- searchInfos[1] %>% html_nodes("li") %>% html_nodes("div.total_tit") %>% html_nodes("a.link_tit") %>% html_text()

# 결과 링크
infoLinks <- searchInfos[1] %>% html_nodes("li") %>% html_nodes("a.link_tit") %>% html_attr('href')

# 정보 요약
infoContents <- searchInfos[1] %>% html_nodes("li") %>% html_nodes("div.total_dsc_wrap") %>% html_nodes("a.api_txt_lines") %>% html_text()


setwd("/Users/seongminmun/Desktop/SL_FD/Data")

infoDF <- data.frame(title=infoTitle, links=infoLinks, contents=infoContents); infoDF

write.csv(infoDF, "infoDF_수원총선결과.csv", fileEncoding="UTF-8")
dir()




infoDFCsv <- read.csv("infoDF_수원총선결과.csv", header=TRUE, fileEncoding="UTF-8")
infoDFCsv





















# 도시별 정보 최대한 많이 가져오기

#rvest와 dplyr를 사용하여 기사 가져오기
#memory & previous_works
gc()
rm(list=ls())
#Encoding_mac
Sys.setlocale(category = "LC_CTYPE", locale = "ko_KR.UTF-8")
#Window운영체제
#options(Encoding = "UTF-8")

library(stringr)

setwd("/Users/seongminmun/Desktop/SL_FD/Data")

dir()


cityList <- c("서울","대전","대구","부산","광주","제주도","춘천","인천")


#install.packages("rvest")
library(rvest)
library(dplyr)


#내가 수집하길 원하는 페이지 주소 
url <- paste("https://search.naver.com/search.naver?nso=&page=2&query=",cityList[1],"총선결과&sm=tab_pge&start=1&where=web",sep="")
searchPage<- read_html(url)  
searchPage


searchInfos <- html_nodes(searchPage, css=".lst_total") 
head(searchInfos)

# install.packages("dplyr")
library(dplyr)


# 제목
infoTitle <- searchInfos[1] %>% html_nodes("li") %>% html_nodes("div.total_tit") %>% html_nodes("a.link_tit") %>% html_text()

# 결과 링크
infoLinks <- searchInfos[1] %>% html_nodes("li") %>% html_nodes("a.link_tit") %>% html_attr('href')

# 정보 요약
infoContents <- searchInfos[1] %>% html_nodes("li") %>% html_nodes("div.total_dsc_wrap") %>% html_nodes("a.api_txt_lines") %>% html_text()


infoDF <- data.frame(title=infoTitle, links=infoLinks, contents=infoContents); infoDF















# 새로운 페이지 크롤링
searchPageInfos <- html_nodes(searchPage, css=".sc_page_inner") 
head(searchPageInfos)
# 페이지 링크
searchLinks <- searchPageInfos[1] %>% html_nodes("a") %>% html_attr('href')

searchLinks

url <- paste("https://search.naver.com/search.naver",searchLinks[3],sep="")
searchPage<- read_html(url) 
searchPage



searchInfos <- html_nodes(searchPage, css=".lst_total") 
head(searchInfos)

# install.packages("dplyr")
library(dplyr)


# 제목
infoTitle <- searchInfos[1] %>% html_nodes("li") %>% html_nodes("div.total_tit") %>% html_nodes("a.link_tit") %>% html_text()

# 결과 링크
infoLinks <- searchInfos[1] %>% html_nodes("li") %>% html_nodes("a.link_tit") %>% html_attr('href')

# 정보 요약
infoContents <- searchInfos[1] %>% html_nodes("li") %>% html_nodes("div.total_dsc_wrap") %>% html_nodes("a.api_txt_lines") %>% html_text()


infoDF <- data.frame(title=infoTitle, links=infoLinks, contents=infoContents); infoDF




















setwd("/Users/seongminmun/Desktop/SL_FD/Data")

dir()


cityList <- c("서울","대전","대구","부산","광주","제주도","춘천","인천")


for(i in 1:length(cityList)){#length(capitalList
  Sys.sleep(1) 
  
  #내가 수집하길 원하는 페이지 주소 
  url <- paste("https://search.naver.com/search.naver?nso=&page=2&query=",cityList[1],"총선결과&sm=tab_pge&start=1&where=web",sep="")
  searchPage<- read_html(url)  
  searchPage
  
  # 새로운 페이지 크롤링
  searchPageInfos <- html_nodes(searchPage, css=".sc_page_inner") 
  head(searchPageInfos)
  # 페이지 링크
  searchLinks <- searchPageInfos[1] %>% html_nodes("a") %>% html_attr('href')
  
  searchTitleList <- NULL
  searchContentList <- NULL
  
  for(j in 1:length(searchLinks)){
    Sys.sleep(1) 
    
    url <- paste("https://search.naver.com/search.naver",searchLinks[j],sep="")
    searchPage<- read_html(url) 
    
    
    
    searchInfos <- html_nodes(searchPage, css=".lst_total") 
    head(searchInfos)
    
    
    # 제목
    searchTitle <- searchInfos[1] %>% html_nodes("li") %>% html_nodes("div.total_tit") %>% html_nodes("a.link_tit") %>% html_text()
    
    # 정보 요약
    searchContents <- searchInfos[1] %>% html_nodes("li") %>% html_nodes("div.total_dsc_wrap") %>% html_nodes("a.api_txt_lines") %>% html_text()
    
  
    for(k in 1:length(searchTitle)){
      searchTitleList <- c(searchTitleList, searchTitle[k]) 
      searchContentList <- c(searchContentList, searchContents[k])
    }
    
    
  }
  
  searchDF <- data.frame(title=searchTitleList, contents=searchContentList); searchDF 
  
  outputName <- paste("searchDF_",cityList[i],".csv",sep="")
  
  write.csv(searchDF, outputName, fileEncoding="UTF-8")
  
}

dir()



















