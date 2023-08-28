




#메모리정리하기
gc()
rm(list=ls())
#한글깨짐현상
#한글 인코딩 문제 해결
#맥
Sys.setlocale(category = "LC_CTYPE", locale = "ko_KR.UTF-8")
#윈도우
options(encoding = "UTF-8")

#경로확인하기

setwd("/Users/seongminmun/Desktop/Class/Advanced/Data")
getwd()
dir()


newsDF_1 <-read.csv("newsDF_프랑스.csv",head=T)

str(newsDF_1)
head(newsDF_1)

library(stringr)

country_1 <- NULL
for (i in 1:length(newsDF_1$title)){
  textAll <- paste(newsDF_1$title[i],newsDF_1$contents[i],sep="")
  textAll <- str_replace_all(textAll, "[[:punct:]]", " ")
  textAll <- str_replace_all(textAll, "[[:digit:]]", " ")
  textAll <- str_replace_all(textAll, "\\s+", " ")
  textAll <- str_trim(textAll) 
  country_1 <- c(country_1, textAll)
}
print(country_1)




#tibble형태 사용하기
library(dplyr)
country_1_tb <- as_tibble(country_1)
country_1_tb



#tidytext를 활용한 정제
#install.packages("tidytext")
library(tidytext)
# 단어 기준 토큰화
country_1_tb_words <- country_1_tb %>%
  unnest_tokens(input = value,        # 토큰화할 텍스트
                output = word,        # 출력 변수명
                token = "words")  # 단어 기준
country_1_tb_words




country_1_tb_words_sort <- country_1_tb_words %>%
  count(word, sort = T)

country_1_tb_words_sort



# 두 글자 이상만 남기기
country_1_tb_words_sort_2 <- country_1_tb_words_sort %>%
  filter(str_count(word) > 1)

country_1_tb_words_sort_2


#최 상위 20개 빈출 단어 추출
country_1_tb_words_sort_2_top20 <- country_1_tb_words_sort_2 %>%
  head(20)

country_1_tb_words_sort_2_top20



#그림으로 나타내기
#install.packages("ggplot2")
library(ggplot2)

ggplot(country_1_tb_words_sort_2_top20, aes(x = reorder(word, n), y = n)) +  # 단어 빈도순 정렬
  geom_col() +
  coord_flip()   


#한글 사용 (에러 해결))
#install.packages("showtext")
library(showtext)
font_add_google(name = "Nanum Gothic", family = "nanumgothic")
showtext_auto()

#위의 순서 재실행



#그래프 수정하기
ggplot(country_1_tb_words_sort_2_top20, aes(x = reorder(word, n), y = n)) +
  geom_col() +
  coord_flip() +
  geom_text(aes(label = n), hjust = -0.3) +            # 막대 밖 빈도 표시
  
  labs(title = "프랑스 관련 기사 내 단어 빈도",  # 그래프 제목
       x = NULL, y = NULL) +                           # 축 이름 삭제
  
  theme(title = element_text(size = 12))               # 제목 크기




country_1_tb_words_sort_2_df <- as.data.frame(country_1_tb_words_sort_2)
head(country_1_tb_words_sort_2_df)




#워드 클라우드 생성하기
#install.packages("wordcloud")
library(wordcloud)
pal <- brewer.pal(8,"Dark2") ## 컬러 색채(palette) 지정
#pal <- brewer.pal(8, "Accent")#검 분 파 보초
#pal <- brewer.pal(12, "Paired")#갈노보초파
#pal <- brewer.pal(9, "Pastel1")#회노초파분
#pal <- brewer.pal(8, "Pastel2")#회노초주녹
#pal <- brewer.pal(9, "Set1")#회갈주초파빨
#pal <- brewer.pal(8, "Set2")#회노초파주녹
#pal <- brewer.pal(12, "Set3")#노회초빨보노녹
#pal <- brewer.pal(7,"Greens")#진초-연초


wordcloud(words=country_1_tb_words_sort_2_df$word, ## 단어 벡터
          freq=country_1_tb_words_sort_2_df$n, ## 단어별 빈도수
          min.freq=3,    ## 워드클라우드에 표현할 단어의 최소 빈도수
          random.order=F, ## 그려지는 순서 랜덤하게 결정
          random.color=T, ## 단어의 채색을 랜덤하게 결정
          colors=pal)  ## 컬러 팔레트 지정



#워드 클라우드 생성하기
#install.packages("ggwordcloud")
library(ggwordcloud)

ggplot(country_1_tb_words_sort_2, aes(label = word, size = n)) +
  geom_text_wordcloud(seed = 1234) +     
  scale_radius(limits = c(4, NA),     # 최소, 최대 단어 빈도
               range = c(2, 25))      # 최소, 최대 글자 크기




ggplot(country_1_tb_words_sort_2, 
       aes(label = word, 
           size = n, 
           col = n)) +                     # 빈도에 따라 색깔 표현
  geom_text_wordcloud(seed = 1234) +  
  scale_radius(limits = c(4, NA),
               range = c(2, 25)) +
  scale_color_gradient(low = "#66aaf2",     # 최소 빈도 색깔
                       high = "#004EA1") +  # 최고 빈도 색깔
  theme_minimal()                           # 배경 없는 테마 적용






font_add_google(name = "Nanum Gothic", family = "nanumgothic")
showtext_auto()



ggplot(country_1_tb_words_sort_2,
       aes(label = word,
           size = n,
           col = n)) +
  geom_text_wordcloud(seed = 1234,
                      family = "nanumgothic") +  # 폰트 적용
  scale_radius(limits = c(4, NA),
               range = c(2, 25)) +
  scale_color_gradient(low = "#66aaf2",
                       high = "#004EA1") +
  theme_minimal()










font_add_google(name = "Black Han Sans", family = "blackhansans")
showtext_auto()

ggplot(country_1_tb_words_sort_2,
       aes(label = word,
           size = n,
           col = n)) +
  geom_text_wordcloud(seed = 1234,
                      family = "blackhansans") +   # 폰트 적용
  scale_radius(limits = c(4, NA),
               range = c(2, 25)) +
  scale_color_gradient(low = "#66aaf2",
                       high = "#004EA1") +
  theme_minimal()















#Introduction to Part of Speech Tagging
#https://www.youtube.com/watch?v=WQYt3DRLpuQ&list=PLaZQkZp6WhWwqgrTakHF5I1WbVbgBC9bL&index=2
#0:51
#Closed words vs Open words

#형태소 분석을 활용해서 content words(명사: ncn, ncpa, nq, npd, nbu; 동사: pvg; 형용사: paa)만 사용하기
#udpipe를 활용
#install.packages("udpipe")
library(udpipe)
udmodel_kaist <- udpipe_download_model(language = "korean-kaist"); udmodel_kaist





contentWordsRefineder <- function(inputSentences){
  outSentence <- ""
  for (i in 1:length(inputWords)){
    # print(inputWords[i])
    words <- unlist(strsplit(inputWords[i], split="_"))[1]
    # print(words)
    posTags <- unlist(strsplit(inputWords[i], split="_"))[2]
    # print(posTags)
    innerWord <- ""
    if(str_detect(words, "\\+")==TRUE){
      wordEach <- unlist(strsplit(words, split="\\+"))
      posTagEach <- unlist(strsplit(posTags, split="\\+"))
      # print(wordEach)
      for (j in 1:length(wordEach)){
        try({
          if(str_detect(posTagEach[j], "ncn")==TRUE || str_detect(posTagEach[j], "ncpa")==TRUE || str_detect(posTagEach[j], "nq")==TRUE || str_detect(posTagEach[j], "npd")==TRUE || str_detect(posTagEach[j], "nbu")==TRUE || str_detect(posTagEach[j], "pvg")==TRUE || str_detect(posTagEach[j], "paa")==TRUE){
            innerWord <- paste(innerWord, wordEach[j], " ", collapse = " ", sep = "")
          }
        },silent = T)
      }
    } else {
      if(str_detect(posTags, "ncn")==TRUE || str_detect(posTags, "ncpa")==TRUE || str_detect(posTags, "nq")==TRUE || str_detect(posTags, "npd")==TRUE || str_detect(posTags, "nbu")==TRUE || str_detect(posTags, "pvg")==TRUE || str_detect(posTags, "paa")==TRUE){
        innerWord <- paste(words, " ", collapse = " ", sep = "")
      }
    }
    
    if (i == length(inputWords)){
      innerWord <- gsub("\\s$", "", innerWord)
    }
    
    outSentence <- paste(outSentence, innerWord, collapse = " ", sep = "")
  }
  return(outSentence[1])
}




outSentence <- NULL
for (i in 1:3){#length(country_1)
  # print(country_1[i][1])
  x_kaist <- udpipe(x = country_1[i][1],object = udmodel_kaist)
  text_postagged_kaist2 <- paste(x_kaist$lemma, "_", x_kaist$xpos, collapse = " ", sep = "")
  inputWords <- unlist(strsplit(as.character(text_postagged_kaist2), split=" "))
  outCome <- contentWordsRefineder(inputWords)
  outSentence <- c(outSentence, outCome)
}

print(outSentence)



#tibble형태 사용하기
library(dplyr)
country_1_tb <- as_tibble(outSentence)
country_1_tb



#tidytext를 활용한 정제
#install.packages("tidytext")
library(tidytext)
# 문장 기준 토큰화
country_1_tb_words <- country_1_tb %>%
  unnest_tokens(input = value,        # 토큰화할 텍스트
                output = word,        # 출력 변수명
                token = "words")  # 문장 기준
country_1_tb_words




country_1_tb_words_sort <- country_1_tb_words %>%
  count(word, sort = T)

country_1_tb_words_sort



# 두 글자 이상만 남기기
country_1_tb_words_sort_2 <- country_1_tb_words_sort %>%
  filter(str_count(word) > 1)

country_1_tb_words_sort_2


#최 상위 20개 빈출 단어 추출
country_1_tb_words_sort_2_top20 <- country_1_tb_words_sort_2 %>%
  head(20)

country_1_tb_words_sort_2_top20



#그림으로 나타내기
#install.packages("ggplot2")
library(ggplot2)

ggplot(country_1_tb_words_sort_2_top20, aes(x = reorder(word, n), y = n)) +  # 단어 빈도순 정렬
  geom_col() +
  coord_flip()   



#그래프 수정하기
ggplot(country_1_tb_words_sort_2_top20, aes(x = reorder(word, n), y = n)) +
  geom_col() +
  coord_flip() +
  geom_text(aes(label = n), hjust = -0.3) +            # 막대 밖 빈도 표시
  
  labs(title = "프랑스 관련 기사 내 단어 빈도",  # 그래프 제목
       x = NULL, y = NULL) +                           # 축 이름 삭제
  
  theme(title = element_text(size = 12))               # 제목 크기




country_1_tb_words_sort_2_df <- as.data.frame(country_1_tb_words_sort_2)
head(country_1_tb_words_sort_2_df)




#워드 클라우드 생성하기
#install.packages("wordcloud")
library(wordcloud)
#pal <- brewer.pal(8,"Dark2") ## 컬러 색채(palette) 지정
pal <- brewer.pal(8, "Accent")#검 분 파 보초
#pal <- brewer.pal(12, "Paired")#갈노보초파
#pal <- brewer.pal(9, "Pastel1")#회노초파분
#pal <- brewer.pal(8, "Pastel2")#회노초주녹
#pal <- brewer.pal(9, "Set1")#회갈주초파빨
#pal <- brewer.pal(8, "Set2")#회노초파주녹
#pal <- brewer.pal(12, "Set3")#노회초빨보노녹
#pal <- brewer.pal(7,"Greens")#진초-연초


wordcloud(words=country_1_tb_words_sort_2_df$word, ## 단어 벡터
          freq=country_1_tb_words_sort_2_df$n, ## 단어별 빈도수
          min.freq=1,    ## 워드클라우드에 표현할 단어의 최소 빈도수
          random.order=F, ## 그려지는 순서 랜덤하게 결정
          random.color=T, ## 단어의 채색을 랜덤하게 결정
          colors=pal)  ## 컬러 팔레트 지정




#install.packages("ggwordcloud")
library(ggwordcloud)


font_add_google(name = "Black Han Sans", family = "blackhansans")
showtext_auto()


ggplot(country_1_tb_words_sort_2,
       aes(label = word,
           size = n,
           col = n)) +
  geom_text_wordcloud(seed = 1234,
                      family = "blackhansans") +  # 폰트 적용
  scale_radius(limits = c(1, NA),
               range = c(4, 25)) +
  scale_color_gradient(low = "#66aaf2",
                       high = "#004EA1") +
  theme_minimal()













