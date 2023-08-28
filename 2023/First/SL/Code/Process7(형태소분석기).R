

#Introduction to Part of Speech Tagging
#https://www.youtube.com/watch?v=WQYt3DRLpuQ&list=PLaZQkZp6WhWwqgrTakHF5I1WbVbgBC9bL&index=2
#3:10


## 형태소 분석
### 형태소는 의미를 가지는 요소로서는 더 이상 분석할 수 없는 가장 작은 말의 단위
# - 친구가 파이썬을 재밌게 하고 있다.
# - 어절 분석: 친구가, 파이썬을, 재밌게, 하고, 있다 (공백 기준)
# - 단어 분석: 친구, 가, 파이썬, 을, 재밌게, 하고, 있다 (어절 단위; 단어 5 조사 2)
# - 형태소 분석: 친구, 가, 파이썬, 을, 재미, 있-, -게, 하-, -고, 있-, -다 (의미를 가지고 있는 최소 단위)
# - 품사 태깅: 명사, 조사, 명사, 조사, 형용사, 보조용언, 연결어미, 동사, 연결어미, 보조용언, 종결어미 (형태소를 쓰임에 따라 분류한 기준)




### 문장에 따라 단어의 품사가 달라지는 경우 (e.g., 오늘)
# - <b>오늘</b>도 이 집은 장사를 안하네 (조사 '도'와 결합되는 경우이므로 '명사'이다)
# - <b>오늘</b> 가지 말고 내일 가자 (서술어 '가지'를 수식하므로 '부사'이다)




### 문맥에 따라 단어의 의미와 품사가 달라지는 경우
# - https://ko.dict.naver.com/#/search?range=word&query=%EB%B0%B0&autoConvert=&shouldSearchOpen=false
# - <b>배</b> 농장에서 구매했다(배나무의 열매).
# - 냄새가 옷에 <b>배</b>다(스며들어 오래남다).
# - 명태가 알을 <b>배</b>다(뱃속에 알이 가득 차 있다).








#KoNLP - 한글 자연어 처리 툴킷2

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


#참고
# https://cran.r-project.org/web/packages/udpipe/vignettes/udpipe-annotation.html
# https://corpling.hypotheses.org/4081

#udpipe를 활용
#install.packages("udpipe")
library(udpipe)

# korean = korean-gsd
udmodel_Korean <- udpipe_download_model(language = "korean"); udmodel_Korean

# korean-gsd, korean-kaist
udmodel_gsd <- udpipe_download_model(language = "korean-gsd"); udmodel_gsd
udmodel_kaist <- udpipe_download_model(language = "korean-kaist"); udmodel_kaist

provide_xpostag(udmodel_kaist)

# korean-gsd
x_gsd <- udpipe(x = "한국어를 사용하겠습니다.",object = udmodel_gsd)
text_postagged_gsd <- paste(x_gsd$token, "_", x_gsd$upos, collapse = " ", sep = ""); text_postagged_gsd
text_postagged_gsd2 <- paste(x_gsd$lemma, "_", x_gsd$xpos, collapse = " ", sep = ""); text_postagged_gsd2
#"한국어+를_NNG+JKO 사용하겠습니다_VV+EP+EF ._SF"
# korean-kaist
x_kaist <- udpipe(x = "한국어를 사용하겠습니다.",object = udmodel_kaist)
text_postagged_kaist <- paste(x_kaist$token, "_", x_kaist$upos, collapse = " ", sep = ""); text_postagged_kaist
text_postagged_kaist2 <- paste(x_kaist$lemma, "_", x_kaist$xpos, collapse = " ", sep = ""); text_postagged_kaist2
#"한국어+를_ncn+jco 사용하+겠+습니다_pvg+ep+ef ._sf"

# generate dependency plot
install.packages("textplot")
library(textplot)
dplot <- textplot_dependencyparser(x_kaist, size = 3) 
# show plot
dplot


udmodel_fr <- udpipe_download_model(language = "french")
udmodel_fr
#french-gsd, french-partut, french-sequoia, french-spoken

x_fr <- udpipe(x = "Je suis coreen",object = udmodel_fr); x_fr
text_postagged_fr <- paste(x_fr$token, "_", x_fr$upos, collapse = " ", sep = ""); text_postagged_fr
#"Je_PRON suis_AUX coreen_ADJ"
text_postagged_fr2 <- paste(x_fr$lemma, "_", x_fr$xpos, collapse = " ", sep = ""); text_postagged_fr2
#"il_NA être_NA coreen_NA"






library(stringr)
sentenceKaist <- "한국어+를_ncn+jco 사용하+겠+습니다_pvg+ep+ef ._sf"; sentenceKaist
inputWords <- unlist(strsplit(sentenceKaist, split=" ")); inputWords


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
    print(wordEach)
    for (j in 1:length(wordEach)){
      innerWord <- paste(innerWord, wordEach[j], "/", posTagEach[j], " ", collapse = " ", sep = "")
    }
  } else {
    innerWord <- paste(words, "/", posTags, " ", collapse = " ", sep = "")
  }
  
  if (i == length(inputWords)){
    innerWord <- gsub("\\s$", "", innerWord)
  }
  
  outSentence <- paste(outSentence, innerWord, collapse = " ", sep = "")
}

print(outSentence)













wordRefineder <- function(inputWords){
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
        innerWord <- paste(innerWord, wordEach[j], "/", posTagEach[j], " ", collapse = " ", sep = "")
      }
    } else {
      innerWord <- paste(words, "/", posTags, " ", collapse = " ", sep = "")
    }
    
    if (i == length(inputWords)){
      innerWord <- gsub("\\s$", "", innerWord)
    }
    
    outSentence <- paste(outSentence, innerWord, collapse = " ", sep = "")
  }
  return(outSentence[1])
}












sentenceKaist <- "한국어+를_ncn+jco 사용하+겠+습니다_pvg+ep+ef ._sf"; sentenceKaist
inputWords <- unlist(strsplit(sentenceKaist, split=" ")); inputWords
wordRefineder(inputWords)






























# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# 
# ######################################################################
# rm(list=ls())
# 
# 
# gc()
# 
# #install.packages("remotes")
# library(remotes)
# 
# #install.packages("rJava")
# 
# #remotes::install_github('haven-jeon/KoNLP', upgrade = 'never', force = TRUE, INSTALL_opts=c("--no-multiarch"))
# 
# library(rJava)
# 
# library(KoNLP)
# 
# Sys.setenv(JAVA_HOME="C:\\Program Files\\Java\\jre1.8.0_141")
# 
# #install.packages("tidytext")
# library(tidytext)
# 
# #install.packages("readr")
# library(readr)
# 
# #install.packages("tidyverse")
# library(tidyverse)
# 
# #install.packages("lubridate")
# library(lubridate)
# 
# #devtools::install_github("r-lib/conflicted", force = TRUE)
# 
# library(conflicted)
# 
# getwd()
# 
# dir()
# 
# library(dplyr)
# #install.packages("tibble")
# library(tibble)
# 
# #install.packages("stats")
# #install.packages("stringr")
# library(stringr)
# library(stats)
# 
# 
# 
# raw_speeches <- read.csv("speeches_presidents.csv")
# 
# raw_speeches_df <- as.data.frame(raw_speeches)
# 
# raw_speeches_tibble <- as_tibble(raw_speeches_df)
# 
# 
# speeches_korean <- raw_speeches_tibble %>%
#   mutate(value = str_replace_all(value, "[^가-힣]", " "),
#          value = str_squish(value))
# 
# 
# speeches_president <- speeches_korean$president
# speeches_value <- speeches_korean$value
# 
# 
# #install.packages("udpipe")
# library(udpipe)
# #install.packages("udpipe")
# # udmodel_kaist <- udpipe_download_model(language = "korean-kaist"); udmodel_kaist
# 
# udmodel_kaist <- udpipe_download_model(language = "korean-kaist"); udmodel_kaist
# 
# outSentencePresident = NULL
# outSentenceNounWord = NULL
# outSentenceNounAll = NULL
# 
# 
# for (k in 1:length(speeches_value)){
#   
#   x_kaist <- udpipe(x = speeches_value[k], object = udmodel_kaist)
#   text_postagged_kaist <- paste(x_kaist$token, "_", x_kaist$upos, collapse = " ", sep = "") ; text_postagged_kaist
#   text_postagged_kaist2 <- paste(x_kaist$lemma, "_", x_kaist$xpos, collapse = " ", sep = "") ; text_postagged_kaist2
#   
#   library(stringr)
#   
#   sentenceKaist <- as.character(text_postagged_kaist2); sentenceKaist
#   inputWords <- unlist(strsplit(sentenceKaist, split=" ")); inputWords
#   
#   outSentenceNoun <- ""
#   outSentence <- ""
#   for (i in 1:length(inputWords)){  
#     # print(inputWords[i])  
#     words <- unlist(strsplit(inputWords[i], split="_"))[1]  
#     # print(words)  
#     posTags <- unlist(strsplit(inputWords[i], split="_"))[2]  
#     # print(posTags)  
#     innerWord <- ""  
#     if(str_detect(words, "\\+")==TRUE){    
#       wordEach <- unlist(strsplit(words, split="\\+"))    
#       posTagEach <- unlist(strsplit(posTags, split="\\+"))    
#       print(wordEach)    
#       for (j in 1:length(wordEach)){      
#         innerWord <- paste(innerWord, wordEach[j], "/", posTagEach[j], " ", collapse = " ", sep = "")    
#       }  
#     } else {    
#       if (str_detect(posTags, "ncn")==TRUE && str_detect(posTags, "\\+")!=TRUE){
#         if (nchar(words)!=1){
#           outSentencePresident <- c(outSentencePresident, speeches_president[k])
#           outSentenceNounWord <- c(outSentenceNounWord,words)
#         }
#         # outSentenceNoun <- paste(outSentenceNoun, " ", words, collapse = " ", sep = "")  
#       }
#       innerWord <- paste(words, "/", posTags, " ", collapse = " ", sep = "")  
#     }    
#     if (i == length(inputWords)){    
#       innerWord <- gsub("\\s$", "", innerWord)  
#     }    
#     outSentence <- paste(outSentence, innerWord, collapse = " ", sep = "")
#   }
#   # print(outSentence)
#   # print(outSentenceNoun)
#   outSentenceNounAll <- c(outSentenceNounAll,outSentenceNoun)
# }
# 
# 
# print(outSentencePresident)
# print(outSentenceNounWord)
# 
# 
# 
# 
# speeches_df = data.frame(president = outSentencePresident, word = outSentenceNounWord)
# 
# finalDFtibble = as_tibble(speeches_df)
# 
# 
# library(stringr)
# frequency2 <- speeches_df %>%
#   count(president, word)
# 
# 
# 
# 
# 
# frequency2
# 
# install.packages("tm")
# library(tm)
# 
# ### Getting TF-IDE; bind_ft_idf function from tidytext ###
# ## tf_idf with higher frequency
# frequency2 <- frequency2 %>%
#   bind_tf_idf(term = word,
#               document = president, # 텍스트 구분 기준
#               n = n) %>% # 단어 빈도
#   arrange(-tf_idf) # arrange(desc(tf_idf))
# frequency2
# 
# 
# 
# moon_tfidf <- frequency2 %>% filter(president == "문재인")
# park_tfidf <- frequency2 %>% filter(president == "박근혜")
# lee_tfidf <- frequency2 %>% filter(president == "이명박")
# rho_tfidf <- frequency2 %>% filter(president == "노무현")
# 
# ### barchart
# 
# top10 <- frequency2 %>%
#   group_by(president) %>%
#   slice_max(tf_idf, n = 10, with_ties = F)
# 
# # 그래프 순서 정하기
# top10$president <- factor(top10$president,
#                           levels = c("문재인", "박근혜", "이명박", "노무현"))
# 
# 
# install.packages("ggplot")
# library(ggplot2)
# # 막대 그래프프
# ggplot(top10, aes(x = reorder_within(word, tf_idf, president),
#                   y = tf_idf,
#                   fill = president)) +
#   geom_col(show.legend = F) +
#   coord_flip() +
#   facet_wrap(~ president, scales = "free", ncol = 2) +
#   scale_x_reordered() +
#   labs(x = NULL) +
#   theme(text = element_text(family = "nanumgothic"))


