

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

setwd("/Users/seongminmun/Desktop/SL_FD/Data")
getwd()
dir()



#udpipe를 활용
#install.packages("udpipe")
library(udpipe)

# korean = korean-gsd
udmodel_Korean <- udpipe_download_model(language = "korean"); udmodel_Korean

# korean-gsd, korean-kaist
udmodel_gsd <- udpipe_download_model(language = "korean-gsd"); udmodel_gsd
udmodel_kaist <- udpipe_download_model(language = "korean-kaist"); udmodel_kaist



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











#함수화 하기

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
















