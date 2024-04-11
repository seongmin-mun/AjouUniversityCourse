

gc()
rm(list=ls())
#Encoding_mac
Sys.setlocale(category = "LC_CTYPE", locale = "ko_KR.UTF-8")
#Window운영체제
#options(Encoding = "UTF-8")

library(stringr)

setwd("/Users/seongminmun/Desktop/SL_FD/Data")
getwd()
dir()




# 형태소 분석 함수 생성하기

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















cityList <- c("서울","대전","대구","부산","광주","제주도","춘천","인천")

library(stringr)
citySearchAll <- NULL
for(i in 1:length(cityList)){#3
  Sys.sleep(1)
  fileName <- paste("searchDF_",cityList[i],".csv",sep="")
  searchDF <-read.csv(fileName,head=T)
  
  citySearch <- NULL
  for (j in 1:length(searchDF$title)){
    textAll <- paste(searchDF$title[j],searchDF$contents[j],sep="")
    textAll <- str_replace_all(textAll, "[[:punct:]]", " ")
    textAll <- str_replace_all(textAll, "[[:digit:]]", " ")
    textAll <- str_replace_all(textAll, "\\s+", " ")
    textAll <- str_trim(textAll) 
    citySearch <- c(citySearch, textAll)
  }
  
  outSentence <- NULL
  for (j in 1:length(citySearch)){
    x_kaist <- udpipe(x = citySearch[j][1],object = udmodel_kaist)
    text_postagged_kaist2 <- paste(x_kaist$lemma, "_", x_kaist$xpos, collapse = " ", sep = "")
    inputWords <- unlist(strsplit(as.character(text_postagged_kaist2), split=" "))
    outCome <- contentWordsRefineder(inputWords)
    citySearchAll <- c(citySearchAll, outCome)
  }
  
}
head(citySearchAll)
summary(citySearchAll)
str(citySearchAll)

#write.csv(citySearchAll,"citySearchAll.csv")
#citySearchAll<- read.csv("citySearchAll.csv",head=T)
#citySearchAll <- citySearchAll[-1]; citySearchAll
#colnames(citySearchAll)[1] <- "value"; citySearchAll



##################기본 텍스트 마이닝 분석###################


#tibble형태 사용하기
library(dplyr)
citySearchAll_tb <- as_tibble(citySearchAll)
citySearchAll_tb




#id 값 추가하기 - 동출 출현 단어 빈도 계산시 사용
citySearchAll_tb_id <- citySearchAll_tb %>%
  select(value) %>%
  mutate(id = row_number())

citySearchAll_tb_id



#tidytext를 활용한 정제
#install.packages("tidytext")
library(tidytext)
# 문장 기준 토큰화
citySearchAll_tb_id_words <- citySearchAll_tb_id %>%
  unnest_tokens(input = value,        # 토큰화할 텍스트
                output = word,        # 출력 변수명
                token = "words", 
                drop = F)  
citySearchAll_tb_id_words






citySearchAll_tb_id_words_sort <- citySearchAll_tb_id_words %>%
  count(word, sort = T)

citySearchAll_tb_id_words_sort



# 두 글자 이상만 남기기
citySearchAll_tb_id_words_sort_2 <- citySearchAll_tb_id_words_sort %>%
  filter(str_count(word) > 1)

citySearchAll_tb_id_words_sort_2


#최 상위 20개 빈출 단어 추출
citySearchAll_tb_id_words_sort_2_top20 <- citySearchAll_tb_id_words_sort_2 %>%
  head(20)

citySearchAll_tb_id_words_sort_2_top20



#그림으로 나타내기
#install.packages("ggplot2")
library(ggplot2)

ggplot(citySearchAll_tb_id_words_sort_2_top20, aes(x = reorder(word, n), y = n)) +  # 단어 빈도순 정렬
  geom_col() +
  coord_flip()   


#한글 사용 (에러 해결))
#install.packages("showtext")
library(showtext)
font_add_google(name = "Nanum Gothic", family = "nanumgothic")
showtext_auto()

#위의 순서 재실행



#그래프 수정하기
ggplot(citySearchAll_tb_id_words_sort_2_top20, aes(x = reorder(word, n), y = n)) +
  geom_col() +
  coord_flip() +
  geom_text(aes(label = n), hjust = -0.3) +            # 막대 밖 빈도 표시
  
  labs(title = "서울 투표 관련 검색 결과 단어 빈도",  # 그래프 제목
       x = NULL, y = NULL) +                           # 축 이름 삭제
  
  theme(title = element_text(size = 12))               # 제목 크기




citySearchAll_tb_id_words_sort_2_df <- as.data.frame(citySearchAll_tb_id_words_sort_2)
head(citySearchAll_tb_id_words_sort_2_df)




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


wordcloud(words=citySearchAll_tb_id_words_sort_2_df$word, ## 단어 벡터
          freq=citySearchAll_tb_id_words_sort_2_df$n, ## 단어별 빈도수
          min.freq=3,    ## 워드클라우드에 표현할 단어의 최소 빈도수
          random.order=F, ## 그려지는 순서 랜덤하게 결정
          random.color=T, ## 단어의 채색을 랜덤하게 결정
          colors=pal)  ## 컬러 팔레트 지정



#워드 클라우드 생성하기
#install.packages("ggwordcloud")
library(ggwordcloud)

ggplot(citySearchAll_tb_id_words_sort_2, aes(label = word, size = n)) +
  geom_text_wordcloud(seed = 1234) +     
  scale_radius(limits = c(4, NA),     # 최소, 최대 단어 빈도
               range = c(2, 25))      # 최소, 최대 글자 크기




ggplot(citySearchAll_tb_id_words_sort_2, 
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



ggplot(citySearchAll_tb_id_words_sort_2,
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

ggplot(citySearchAll_tb_id_words_sort_2,
       aes(label = word,
           size = n,
           col = n)) +
  geom_text_wordcloud(seed = 1234,
                      family = "blackhansans") +   # 폰트 적용
  scale_radius(limits = c(10, NA),
               range = c(3, 25)) +
  scale_color_gradient(low = "#66aaf2",
                       high = "#004EA1") +
  theme_minimal()























################연관 단어 네트워크 생성하기#################


#tibble형태 사용하기
library(dplyr)
citySearchAll_tb <- as_tibble(citySearchAll)
citySearchAll_tb




#id 값 추가하기 - 동출 출현 단어 빈도 계산시 사용
citySearchAll_tb_id <- citySearchAll_tb %>%
  select(value) %>%
  mutate(id = row_number())

citySearchAll_tb_id



#tidytext를 활용한 정제
#install.packages("tidytext")
library(tidytext)
# 문장 기준 토큰화
citySearchAll_tb_id_words <- citySearchAll_tb_id %>%
  unnest_tokens(input = value,        # 토큰화할 텍스트
                output = word,        # 출력 변수명
                token = "words", 
                drop = F)  
citySearchAll_tb_id_words





#단어 id 문장 순서 변경하기
citySearchAll_tb_id_words <- citySearchAll_tb_id_words %>% select(word, id, value)
citySearchAll_tb_id_words




#문맥단어 사용 빈도 카운트하기
citySearchAll_tb_id_words_cw <- citySearchAll_tb_id_words %>% count(word, sort = T)
citySearchAll_tb_id_words_cw




# 두 글자 이상만 남기기
citySearchAll_tb_id_words_2 <- citySearchAll_tb_id_words %>%
  filter(str_count(word) > 1) %>%
  arrange(id)

citySearchAll_tb_id_words_2





####동시 출현 단어 생성하기 (co-occurrence)
#install.packages("widyr")
library(widyr)

citySearchAll_tb_id_words_2_pair <- citySearchAll_tb_id_words_2 %>%
  pairwise_count(item = word,
                 feature = id,
                 sort = T)
citySearchAll_tb_id_words_2_pair


#여행과 관련되어 등장하는 단어 확인하기
citySearchAll_tb_id_words_2_pair_voting <- citySearchAll_tb_id_words_2_pair %>% filter(item1 == "투표")
citySearchAll_tb_id_words_2_pair_voting



#최 상위 50개 빈출 단어 추출
citySearchAll_tb_id_words_2_pair_voting_top50 <- citySearchAll_tb_id_words_2_pair_voting %>% head(50)
citySearchAll_tb_id_words_2_pair_voting_top50










#동시 출현 네트워크 생성하기
#install.packages("tidygraph")
library(tidygraph)

citySearchAll_tb_id_words_2_pair_graph <- citySearchAll_tb_id_words_2_pair %>%
  filter(n >= 25) %>%
  as_tbl_graph()

citySearchAll_tb_id_words_2_pair_graph



#그래프 생성하기

library(showtext)
font_add_google(name = "Nanum Gothic", family = "nanumgothic")
showtext_auto()

#install.packages("ggraph")
library(ggraph)

ggraph(citySearchAll_tb_id_words_2_pair_graph) +
  geom_edge_link() +                 # 엣지
  geom_node_point() +                # 노드
  geom_node_text(aes(label = name))  # 텍스트




#상위 100개 단어로 확인하기
citySearchAll_tb_id_words_2_pair_top100 <- citySearchAll_tb_id_words_2_pair %>% head(100)
citySearchAll_tb_id_words_2_pair_top100



#그래프 생성하기
library(tidygraph)

citySearchAll_tb_id_words_2_pair_top100_graph <- citySearchAll_tb_id_words_2_pair_top100 %>%
  as_tbl_graph()

citySearchAll_tb_id_words_2_pair_top100_graph

library(ggraph)

ggraph(citySearchAll_tb_id_words_2_pair_top100_graph) +
  geom_edge_link() +                 # 엣지
  geom_node_point() +                # 노드
  geom_node_text(aes(label = name))  # 텍스트


#그래프 수정하기
library(showtext)
font_add_google(name = "Nanum Gothic", family = "nanumgothic")
showtext_auto()



set.seed(1234)                              # 난수 고정
ggraph(citySearchAll_tb_id_words_2_pair_top100_graph, layout = "fr") +      # 레이아웃
  
  geom_edge_link(color = "gray50",          # 엣지 색깔
                 alpha = 0.5) +             # 엣지 명암
  
  geom_node_point(color = "lightcoral",     # 노드 색깔
                  size = 5) +               # 노드 크기
  
  geom_node_text(aes(label = name),         # 텍스트 표시
                 repel = T,                 # 노드밖 표시
                 size = 5,                  # 텍스트 크기
                 family = "nanumgothic") +  # 폰트
  
  theme_graph()                             # 배경 삭제





#연결 중심성 계산하여 활용하기
#VISUAL ANALYTICS FOR THE MARRIAGE NETWORK IN THE GORYEO DYNASTY, KOREA
#https://mccsis.org/wp-content/uploads/2023/07/CGV2023_S_036.pdf

#Graph Theory Measures and Their Application to Neurosurgical Eloquence
#https://www.researchgate.net/publication/367200823_Graph_Theory_Measures_and_Their_Application_to_Neurosurgical_Eloquence

set.seed(1234)
citySearchAll_tb_id_words_2_pair_top100_graph_centrality <- citySearchAll_tb_id_words_2_pair_top100 %>%
  as_tbl_graph(directed = F) %>%
  mutate(centrality = centrality_degree(),        # 연결 중심성
         group = as.factor(group_infomap()))      # 커뮤니티

citySearchAll_tb_id_words_2_pair_top100_graph_centrality






set.seed(1234)
ggraph(citySearchAll_tb_id_words_2_pair_top100_graph_centrality, layout = "fr") +      # 레이아웃
  
  geom_edge_link(color = "gray50",          # 엣지 색깔
                 alpha = 0.5) +             # 엣지 명암
  
  geom_node_point(aes(size = centrality,    # 노드 크기
                      color = group),       # 노드 색깔
                  show.legend = F) +        # 범례 삭제
  scale_size(range = c(5, 15)) +            # 노드 크기 범위
  
  geom_node_text(aes(label = name),         # 텍스트 표시
                 repel = T,                 # 노드밖 표시
                 size = 5,                  # 텍스트 크기
                 family = "nanumgothic") +  # 폰트
  
  theme_graph()                             # 배경 삭제










