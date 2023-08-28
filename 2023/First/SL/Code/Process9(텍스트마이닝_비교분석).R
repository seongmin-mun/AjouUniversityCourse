



#####두 도시 비교 분석



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




outSentence <- NULL
for (i in 1:length(country_1)){#length(capital_1)
  # print(capital_1[i][1])
  x_kaist <- udpipe(x = country_1[i][1],object = udmodel_kaist)
  text_postagged_kaist2 <- paste(x_kaist$lemma, "_", x_kaist$xpos, collapse = " ", sep = "")
  inputWords <- unlist(strsplit(as.character(text_postagged_kaist2), split=" "))
  outCome <- contentWordsRefineder(inputWords)
  outSentence <- c(outSentence, outCome)
}

print(outSentence)



#tibble형태 사용하기
library(dplyr)
france_tb <- as_tibble(outSentence) %>% mutate(country="france")
france_tb






newsDF_2 <-read.csv("newsDF_독일.csv",head=T)

str(newsDF_2)
head(newsDF_2)

library(stringr)

country_2 <- NULL
for (i in 1:length(newsDF_2$title)){
  textAll <- paste(newsDF_2$title[i],newsDF_2$contents[i],sep="")
  textAll <- str_replace_all(textAll, "[[:punct:]]", " ")
  textAll <- str_replace_all(textAll, "[[:digit:]]", " ")
  textAll <- str_replace_all(textAll, "\\s+", " ")
  textAll <- str_trim(textAll) 
  country_2 <- c(country_2, textAll)
}
print(country_2)



outSentence <- NULL
for (i in 1:length(country_2)){#length(capital_1)
  # print(capital_1[i][1])
  x_kaist <- udpipe(x = country_2[i][1],object = udmodel_kaist)
  text_postagged_kaist2 <- paste(x_kaist$lemma, "_", x_kaist$xpos, collapse = " ", sep = "")
  inputWords <- unlist(strsplit(as.character(text_postagged_kaist2), split=" "))
  outCome <- contentWordsRefineder(inputWords)
  outSentence <- c(outSentence, outCome)
}

print(outSentence)

#tibble형태 사용하기
germany_tb <- as_tibble(outSentence) %>% mutate(country="germany")
germany_tb




#두 도시 데이터 병합하기
bind_countries <- bind_rows(france_tb, germany_tb) %>%
  select(country, value)

head(bind_countries)
tail(bind_countries)




#tidytext를 활용한 정제
#install.packages("tidytext")
library(tidytext)

# 문장 기준 토큰화
bind_countries_words <- bind_countries %>%
  unnest_tokens(input = value,        # 토큰화할 텍스트
                output = word,        # 출력 변수명
                token = "words")  # 문장 기준
bind_countries_words



bind_countries_words_frequency <- bind_countries_words %>%
  count(country, word) %>%   # 연설문 및 단어별 빈도
  filter(str_count(word) > 1)  # 두 글자 이상 추출

head(bind_countries_words_frequency)



#상위 10개 단어 추출
bind_countries_words_frequency_top10 <- bind_countries_words_frequency %>%
  group_by(country) %>%  # president별로 분리
  slice_max(n, n = 10)     # 상위 10개 추출

bind_countries_words_frequency_top10





#그래프 생성하기
library(ggplot2)
ggplot(bind_countries_words_frequency_top10, aes(x = reorder(word, n),
                  y = n,
                  fill = country)) +
  geom_col() +
  coord_flip() +
  facet_wrap(~ country)



#단어 상관 없이 각각 그래프 재생성
ggplot(bind_countries_words_frequency_top10, aes(x = reorder(word, n),
                  y = n,
                  fill = country)) +
  geom_col() +
  coord_flip() +
  facet_wrap(~ country,         # president별 그래프 생성
             scales = "free_y")  # y축 통일하지 않음









##########두 나라간 공통 단어 기반 비교 분석하기
###long form데이터를 wide form으로 변환
#install.packages("tidyr")
library(tidyr)

bind_countries_words_frequency_wide <- bind_countries_words_frequency %>%
  pivot_wider(names_from = country,
              values_from = n,
              values_fill = list(n = 0))

bind_countries_words_frequency_wide

#0으로 수렴하는 단어들이 많다.



#add 1 smooting
#Naive Bayes 3 Learning in Naive Bayes
#https://www.youtube.com/watch?v=Ge612JZGBMU&list=PLaZQkZp6WhWxU3kA6wV0nb5dY1SXDEKWH&index=3
#1:40


bind_countries_words_frequency_wide_add1 <- bind_countries_words_frequency_wide %>%
  mutate(ratio_france = ((france + 1)/(sum(france + 1))),  # france에서 단어의 비중
         ratio_germany = ((germany + 1)/(sum(germany + 1))))  # germany에서 단어의 비중

bind_countries_words_frequency_wide_add1


##오즈비 계산하기 (odds ratio)
#오즈비는 어떤 사건이 A조건에서 발생할 확률이 B조건에서 발생할 확률에 비해 얼마나 큰지를 나타낸 값입니다.
#예를 들어 단어가 두 텍스트중 어디에 등장 할 확률이 높은지에 대한 상대적인 중요도를 이야기합니다.




bind_countries_words_frequency_wide_add1_odds <- bind_countries_words_frequency_wide_add1 %>%
  mutate(odds_ratio = ratio_france/ratio_germany)

bind_countries_words_frequency_wide_add1_odds


#내림차순으로 정렬
bind_countries_words_frequency_wide_add1_odds %>% arrange(-odds_ratio)



#오름차순으로 정렬
bind_countries_words_frequency_wide_add1_odds %>% arrange(odds_ratio)


#로그 오즈비 계산하기
#로그 오즈비 값이 양수이면 paris의 기사에서 사용될 확률이 높은 단어이고 음수이면 berlin에서 사용될 확률이 높은 단어이다.
bind_countries_words_frequency_wide_add1_odds_log <- bind_countries_words_frequency_wide_add1_odds %>%
  mutate(log_odds_ratio = log(odds_ratio))

bind_countries_words_frequency_wide_add1_odds_log




#내림차순으로 정렬
#france에서 사용 비중이 높은 단어들
bind_countries_words_frequency_wide_add1_odds_log %>% arrange(-log_odds_ratio)



#오름차순으로 정렬
#germany에서 사용 비중이 높은 단어들
bind_countries_words_frequency_wide_add1_odds_log %>% arrange(log_odds_ratio)






#오즈값을 기준으로 10개의 상위 단어 선정하기
bind_countries_words_frequency_wide_add1_odds_log_top10 <- bind_countries_words_frequency_wide_add1_odds_log %>%
  group_by(country = ifelse(log_odds_ratio > 0, "france", "germany")) %>%
  slice_max(abs(log_odds_ratio), n = 10, with_ties = F)

bind_countries_words_frequency_wide_add1_odds_log_top10


#내림차순으로 정렬
bind_countries_words_frequency_wide_add1_odds_log_top10 %>% 
  arrange(-log_odds_ratio) %>% 
  select(word, log_odds_ratio, country)



#그래프로 나타내기
ggplot(bind_countries_words_frequency_wide_add1_odds_log_top10, aes(x = reorder(word, log_odds_ratio),
                  y = log_odds_ratio,
                  fill = country)) +
  geom_col() +
  coord_flip() +
  labs(x = NULL) +
  theme(text = element_text(family = "nanumgothic"))








