

# 유럽 나라 목록 가져오기

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



#도시 목록 불러오기

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


#capitalList <- c("파리","베를린","런던","로마")



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











library(stringr)
countryNewsAll <- NULL
for(i in 1:length(countryList)){#3
  Sys.sleep(1)
  fileName <- paste("newsDF_",countryList[i],".csv",sep="")
  newsDF <-read.csv(fileName,head=T)
  
  countryNews <- NULL
  for (j in 1:length(newsDF$title)){
    textAll <- paste(newsDF$title[j],newsDF$contents[j],sep="")
    textAll <- str_replace_all(textAll, "[[:punct:]]", " ")
    textAll <- str_replace_all(textAll, "[[:digit:]]", " ")
    textAll <- str_replace_all(textAll, "\\s+", " ")
    textAll <- str_trim(textAll) 
    countryNews <- c(countryNews, textAll)
  }
  
  outSentence <- NULL
  for (j in 1:length(countryNews)){
    x_kaist <- udpipe(x = countryNews[j][1],object = udmodel_kaist)
    text_postagged_kaist2 <- paste(x_kaist$lemma, "_", x_kaist$xpos, collapse = " ", sep = "")
    inputWords <- unlist(strsplit(as.character(text_postagged_kaist2), split=" "))
    outCome <- contentWordsRefineder(inputWords)
    countryNewsAll <- c(countryNewsAll, outCome)
  }
  
}
head(countryNewsAll)
summary(countryNewsAll)
str(countryNewsAll)

#write.csv(countryNewsAll,"countryNewsAll_10.csv")
#countryNewsAll<- read.csv("countryNewsAll_10.csv",head=T)
#countryNewsAll <- countryNewsAll[-1]; countryNewsAll
#colnames(countryNewsAll)[1] <- "value"; countryNewsAll


#tibble형태 사용하기
library(dplyr)
countryNewsAll_tb <- as_tibble(countryNewsAll)
countryNewsAll_tb




#id 값 추가하기 - 동출 출현 단어 빈도 계산시 사용
countryNewsAll_tb_id <- countryNewsAll_tb %>%
  select(value) %>%
  mutate(id = row_number())

countryNewsAll_tb_id



#tidytext를 활용한 정제
#install.packages("tidytext")
library(tidytext)
# 문장 기준 토큰화
countryNewsAll_tb_id_words <- countryNewsAll_tb_id %>%
  unnest_tokens(input = value,        # 토큰화할 텍스트
                output = word,        # 출력 변수명
                token = "words", 
                drop = F)  
countryNewsAll_tb_id_words





#단어 id 문장 순서 변경하기
countryNewsAll_tb_id_words <- countryNewsAll_tb_id_words %>% select(word, id, value)
countryNewsAll_tb_id_words




#문맥단어 사용 빈도 카운트하기
countryNewsAll_tb_id_words_cw <- countryNewsAll_tb_id_words %>% count(word, sort = T)
countryNewsAll_tb_id_words_cw




# 두 글자 이상만 남기기
countryNewsAll_tb_id_words_2 <- countryNewsAll_tb_id_words %>%
  filter(str_count(word) > 1) %>%
  arrange(id)

countryNewsAll_tb_id_words_2





####동시 출현 단어 생성하기 (co-occurrence)
#install.packages("widyr")
library(widyr)

countryNewsAll_tb_id_words_2_pair <- countryNewsAll_tb_id_words_2 %>%
  pairwise_count(item = word,
                 feature = id,
                 sort = T)
countryNewsAll_tb_id_words_2_pair


#여행과 관련되어 등장하는 단어 확인하기
countryNewsAll_tb_id_words_2_pair_travel <- countryNewsAll_tb_id_words_2_pair %>% filter(item1 == "여행")
countryNewsAll_tb_id_words_2_pair_travel



#최 상위 50개 빈출 단어 추출
countryNewsAll_tb_id_words_2_pair_travel_top50 <- countryNewsAll_tb_id_words_2_pair_travel %>% head(50)
countryNewsAll_tb_id_words_2_pair_travel_top50



#동시 출현 네트워크 생성하기
#install.packages("tidygraph")
library(tidygraph)

countryNewsAll_tb_id_words_2_pair_graph <- countryNewsAll_tb_id_words_2_pair %>%
  filter(n >= 25) %>%
  as_tbl_graph()

countryNewsAll_tb_id_words_2_pair_graph



#그래프 생성하기

library(showtext)
font_add_google(name = "Nanum Gothic", family = "nanumgothic")
showtext_auto()

#install.packages("ggraph")
library(ggraph)

ggraph(countryNewsAll_tb_id_words_2_pair_graph) +
  geom_edge_link() +                 # 엣지
  geom_node_point() +                # 노드
  geom_node_text(aes(label = name))  # 텍스트




#상위 100개 단어로 확인하기
countryNewsAll_tb_id_words_2_pair_top100 <- countryNewsAll_tb_id_words_2_pair %>% head(100)
countryNewsAll_tb_id_words_2_pair_top100



#그래프 생성하기
library(tidygraph)

countryNewsAll_tb_id_words_2_pair_top100_graph <- countryNewsAll_tb_id_words_2_pair_top100 %>%
  as_tbl_graph()

countryNewsAll_tb_id_words_2_pair_top100_graph

library(ggraph)

ggraph(countryNewsAll_tb_id_words_2_pair_top100_graph) +
  geom_edge_link() +                 # 엣지
  geom_node_point() +                # 노드
  geom_node_text(aes(label = name))  # 텍스트


#그래프 수정하기
library(showtext)
font_add_google(name = "Nanum Gothic", family = "nanumgothic")
showtext_auto()



set.seed(1234)                              # 난수 고정
ggraph(countryNewsAll_tb_id_words_2_pair_top100_graph, layout = "fr") +      # 레이아웃
  
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
countryNewsAll_tb_id_words_2_pair_top100_graph_centrality <- countryNewsAll_tb_id_words_2_pair_top100 %>%
  as_tbl_graph(directed = F) %>%
  mutate(centrality = centrality_degree(),        # 연결 중심성
         group = as.factor(group_infomap()))      # 커뮤니티

countryNewsAll_tb_id_words_2_pair_top100_graph_centrality






set.seed(1234)
ggraph(countryNewsAll_tb_id_words_2_pair_top100_graph_centrality, layout = "fr") +      # 레이아웃
  
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










#요인추출
#EU 회원국들의 공유경제 성장요인에 관한 연구
#https://www-dbpia-co-kr-ssl.openlink.ajou.ac.kr/journal/articleDetail?nodeId=NODE10574162


countryNewsAll_tb_id_words_2_pair_technique <- countryNewsAll_tb_id_words_2_pair %>% filter(item1 == "기술")
countryNewsAll_tb_id_words_2_pair_technique

View(countryNewsAll_tb_id_words_2_pair_technique)

technique_target <- c("개발", "기업", "시스템", "계약", "탐사선", "모빌리티", "네트워크", "스타트업", "로봇", "스마트")

countryNewsAll_tb_id_words_2_pair_technique_target <- countryNewsAll_tb_id_words_2_pair_technique %>%
  filter(item2 %in% technique_target)
countryNewsAll_tb_id_words_2_pair_technique_target



countryNewsAll_tb_id_words_2_pair_system <- countryNewsAll_tb_id_words_2_pair %>% filter(item1 == "제도")
countryNewsAll_tb_id_words_2_pair_system

View(countryNewsAll_tb_id_words_2_pair_system)

system_target <- c("경찰", "통제", "대피", "주민", "강화", "집정관", "정책", "정부", "유엔", "설립")

countryNewsAll_tb_id_words_2_pair_system_target <- countryNewsAll_tb_id_words_2_pair_system %>%
  filter(item2 %in% system_target)
countryNewsAll_tb_id_words_2_pair_system_target





countryNewsAll_tb_id_words_2_pair_economy <- countryNewsAll_tb_id_words_2_pair %>% filter(item1 == "경제") 
countryNewsAll_tb_id_words_2_pair_economy

View(countryNewsAll_tb_id_words_2_pair_economy)

economy_target <- c("성장", "국가", "협력", "기업", "유럽", "시장", "수출", "수출", "투자", "침체", "회담")

countryNewsAll_tb_id_words_2_pair_economy_target <- countryNewsAll_tb_id_words_2_pair_economy %>%
  filter(item2 %in% economy_target)
countryNewsAll_tb_id_words_2_pair_economy_target







countryNewsAll_tb_id_words_2_pair_society <- countryNewsAll_tb_id_words_2_pair %>% filter(item1 == "사회") 
countryNewsAll_tb_id_words_2_pair_society

View(countryNewsAll_tb_id_words_2_pair_society)

society_target <- c("지역", "기관", "정부", "환경", "시위", "계획", "국제", "교류", "자립", "인프라")

countryNewsAll_tb_id_words_2_pair_society_target <- countryNewsAll_tb_id_words_2_pair_society %>%
  filter(item2 %in% society_target)
countryNewsAll_tb_id_words_2_pair_society_target




europe_country_grow_ontology <- bind_rows(countryNewsAll_tb_id_words_2_pair_technique_target, countryNewsAll_tb_id_words_2_pair_system_target, countryNewsAll_tb_id_words_2_pair_economy_target, countryNewsAll_tb_id_words_2_pair_society_target)

head(europe_country_grow_ontology)
tail(europe_country_grow_ontology)

europe_country_grow_ontology_df <- as.data.frame(europe_country_grow_ontology); europe_country_grow_ontology_df

write.csv(europe_country_grow_ontology_df,"europe_country_grow_ontology_df.csv")


