


#########################관계 시각화###################


#R을 사용하여 네트워크 시각화 생성하기(i.e., visNetwork)


##1.패키지 설치하기
install.packages("visNetwork")
require(visNetwork, quietly = TRUE)


##2.기본적인 네트워크 생성하기
nodes <- data.frame(id = 1:8)
edges <- data.frame(from = c(1,6,2,3,4,7,1,6,1), to = c(5,3,5,7,7,1,4,2,8))
visNetwork(nodes, edges, width = "100%")

##3.노드의 정보를 업데이트하기

###3.1.Label
nodes <- data.frame(id = 1:8, label = paste("Node", 1:8));nodes
edges <- data.frame(from = c(1,6,2,3,4,7,1,6,1), to = c(5,3,5,7,7,1,4,2,8));edges
visNetwork(nodes, edges, width = "100%")


###3.2.Shape
nodes <- data.frame(id = 1:8, label = paste("Node", 1:8), shape = c("square", "triangle", "box", "dot", "star", "ellipse", "database", "diamond"));nodes
edges <- data.frame(from = c(1,6,2,3,4,7,1,6,1), to = c(5,3,5,7,7,1,4,2,8));edges
visNetwork(nodes, edges, width = "100%")

###3.3.Group
nodes <- data.frame(id = 1:8, label = paste("Node", 1:8), shape = c("square", "triangle", "box", "dot", "star", "ellipse", "database", "diamond"), group = c("A","B","A","B","A","B","A","B"));nodes
edges <- data.frame(from = c(1,6,2,3,4,7,1,6,1), to = c(5,3,5,7,7,1,4,2,8));edges
visNetwork(nodes, edges, width = "100%")



###3.4.Color
nodes <- data.frame(id = 1:8, label = paste("Node", 1:8), shape = c("square", "triangle", "box", "dot", "star", "ellipse", "database", "diamond"), color = c("darkred", "grey", "orange", "darkblue", "purple","red","blue","pink"));nodes
edges <- data.frame(from = c(1,6,2,3,4,7,1,6,1), to = c(5,3,5,7,7,1,4,2,8));edges
visNetwork(nodes, edges, width = "100%")

nodes <- data.frame(id = 1:8, label = paste("Node", 1:8), shape = c("square", "triangle", "box", "dot", "star", "ellipse", "database", "diamond"), group = c("A","B","A","B","A","B","A","B"), color = c("darkred", "grey", "orange", "darkblue", "purple","red","blue","pink"));nodes
edges <- data.frame(from = c(1,6,2,3,4,7,1,6,1), to = c(5,3,5,7,7,1,4,2,8));edges
visNetwork(nodes, edges, width = "100%")


###3.5.Shadow
nodes <- data.frame(id = 1:8, label = paste("Node", 1:8), shape = c("square", "triangle", "box", "dot", "star", "ellipse", "database", "diamond"), color = c("darkred", "grey", "orange", "darkblue", "purple","red","blue","pink"), shadow = c(FALSE, TRUE, FALSE, TRUE, TRUE, TRUE, FALSE, TRUE));nodes
edges <- data.frame(from = c(1,6,2,3,4,7,1,6,1), to = c(5,3,5,7,7,1,4,2,8));edges
visNetwork(nodes, edges, width = "100%")



##4.엣지의 정보를 업데이트하기
###4.1. Label
nodes <- data.frame(id = 1:8);nodes
edges <- data.frame(from = c(1,6,2,3,4,7,1,6,1), to = c(5,3,5,7,7,1,4,2,8), label = paste("Edge", 1:9));edges
visNetwork(nodes, edges, width = "100%")


###4.2. Length
nodes <- data.frame(id = 1:8);nodes
edges <- data.frame(from = c(1,6,2,3,4,7,1,6,1), to = c(5,3,5,7,7,1,4,2,8), label = paste("Edge", 1:9), length = c(100,200,300,400,300,200,100,500,100));edges
visNetwork(nodes, edges, width = "100%")




###4.3. Width
nodes <- data.frame(id = 1:8);nodes
edges <- data.frame(from = c(1,6,2,3,4,7,1,6,1), to = c(5,3,5,7,7,1,4,2,8), label = paste("Edge", 1:9), length = c(100,200,300,400,300,200,100,500,100),width = c(4,1,3,2,4,1,2,3,4));edges
visNetwork(nodes, edges, width = "100%")


###4.4. Arrows
nodes <- data.frame(id = 1:8, label = paste("Node", 1:8));nodes
edges <- data.frame(from = c(1,6,2,3,4,7,1,6,1), to = c(5,3,5,7,7,1,4,2,8), label = paste("Edge", 1:9), length = c(100,200,300,400,300,200,100,500,100),width = c(4,1,3,2,4,1,2,3,4),arrows = c("to", "from", "middle", "middle;to","to", "from", "middle", "middle;to","middle"));edges
visNetwork(nodes, edges, width = "100%")





###4.5. Dashes
nodes <- data.frame(id = 1:8, label = paste("Node", 1:8));nodes
edges <- data.frame(from = c(1,6,2,3,4,7,1,6,1), to = c(5,3,5,7,7,1,4,2,8), label = paste("Edge", 1:9), length = c(100,200,300,400,300,200,100,500,100),width = c(4,1,3,2,4,1,2,3,4),arrows = c("to", "from", "middle", "middle;to","to", "from", "middle", "middle;to","middle"), dashes = c(FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, FALSE));edges
visNetwork(nodes, edges, width = "100%")




###4.6. Shadow
nodes <- data.frame(id = 1:8, label = paste("Node", 1:8));nodes
edges <- data.frame(from = c(1,6,2,3,4,7,1,6,1), to = c(5,3,5,7,7,1,4,2,8), label = paste("Edge", 1:9), length = c(100,200,300,400,300,200,100,500,100),width = c(4,1,3,2,4,1,2,3,4),arrows = c("to", "from", "middle", "middle;to","to", "from", "middle", "middle;to","middle"), dashes = c(FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, FALSE), shadow = c(FALSE, TRUE, FALSE, TRUE, FALSE, TRUE, FALSE, TRUE, TRUE));edges
visNetwork(nodes, edges, width = "100%")




###4.7. Color
nodes <- data.frame(id = 1:8, label = paste("Node", 1:8));nodes
edges <- data.frame(from = c(1,6,2,3,4,7,1,6,1), to = c(5,3,5,7,7,1,4,2,8), label = paste("Edge", 1:9), length = c(100,200,300,400,300,200,100,500,100),width = c(4,1,3,2,4,1,2,3,4),arrows = c("to", "from", "middle", "middle;to","to", "from", "middle", "middle;to","middle"), dashes = c(FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, FALSE), shadow = c(FALSE, TRUE, FALSE, TRUE, FALSE, TRUE, FALSE, TRUE, TRUE), color = c("darkred", "grey", "orange", "darkblue", "purple","red","blue","pink","darkgray"));edges
visNetwork(nodes, edges, width = "100%")





##5.제목 및 범례 생성하기

###5.1.제목 생성하기
nodes <- data.frame(id = 1:8, label = paste("Node", 1:8), shape = c("square", "triangle", "box", "dot", "star", "ellipse", "database", "diamond"), group = c("A","B","A","B","A","B","A","B"), shadow = c(FALSE, TRUE, FALSE, TRUE, TRUE, TRUE, FALSE, TRUE));nodes
edges <- data.frame(from = c(1,6,2,3,4,7,1,6,1), to = c(5,3,5,7,7,1,4,2,8), label = paste("Edge", 1:9), length = c(100,200,300,400,300,200,100,500,100),width = c(4,1,3,2,4,1,2,3,4),arrows = c("to", "from", "middle", "middle;to","to", "from", "middle", "middle;to","middle"), dashes = c(FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, FALSE), shadow = c(FALSE, TRUE, FALSE, TRUE, FALSE, TRUE, FALSE, TRUE, TRUE), color = c("darkred", "grey", "orange", "darkblue", "purple","red","blue","pink","darkgray"));edges
visNetwork(nodes, edges, main = "R을 사용한 네트워크 시각화", width = "100%")


nodes <- data.frame(id = 1:8, label = paste("Node", 1:8), shape = c("square", "triangle", "box", "dot", "star", "ellipse", "database", "diamond"), group = c("A","B","A","B","A","B","A","B"), shadow = c(FALSE, TRUE, FALSE, TRUE, TRUE, TRUE, FALSE, TRUE));nodes
edges <- data.frame(from = c(1,6,2,3,4,7,1,6,1), to = c(5,3,5,7,7,1,4,2,8), label = paste("Edge", 1:9), length = c(100,200,300,400,300,200,100,500,100),width = c(4,1,3,2,4,1,2,3,4),arrows = c("to", "from", "middle", "middle;to","to", "from", "middle", "middle;to","middle"), dashes = c(FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, FALSE), shadow = c(FALSE, TRUE, FALSE, TRUE, FALSE, TRUE, FALSE, TRUE, TRUE), color = c("darkred", "grey", "orange", "darkblue", "purple","red","blue","pink","darkgray"));edges
visNetwork(nodes, edges, main = "R을 사용한 네트워크 시각화", width = "100%")



nodes <- data.frame(id = 1:8, label = paste("Node", 1:8), shape = c("square", "triangle", "box", "dot", "star", "ellipse", "database", "diamond"), group = c("A","B","A","B","A","B","A","B"), shadow = c(FALSE, TRUE, FALSE, TRUE, TRUE, TRUE, FALSE, TRUE));nodes
edges <- data.frame(from = c(1,6,2,3,4,7,1,6,1), to = c(5,3,5,7,7,1,4,2,8), label = paste("Edge", 1:9), length = c(100,200,300,400,300,200,100,500,100),width = c(4,1,3,2,4,1,2,3,4),arrows = c("to", "from", "middle", "middle;to","to", "from", "middle", "middle;to","middle"), dashes = c(FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, FALSE), shadow = c(FALSE, TRUE, FALSE, TRUE, FALSE, TRUE, FALSE, TRUE, TRUE), color = c("darkred", "grey", "orange", "darkblue", "purple","red","blue","pink","darkgray"));edges
visNetwork(nodes, edges, main = "R을 사용한 네트워크 시각화", submain = "조선시대사학회", width = "100%")



###5.2.캡션 생성하기


nodes <- data.frame(id = 1:8, label = paste("Node", 1:8), shape = c("square", "triangle", "box", "dot", "star", "ellipse", "database", "diamond"), group = c("A","B","A","B","A","B","A","B"), shadow = c(FALSE, TRUE, FALSE, TRUE, TRUE, TRUE, FALSE, TRUE));nodes
edges <- data.frame(from = c(1,6,2,3,4,7,1,6,1), to = c(5,3,5,7,7,1,4,2,8), label = paste("Edge", 1:9), length = c(100,200,300,400,300,200,100,500,100),width = c(4,1,3,2,4,1,2,3,4),arrows = c("to", "from", "middle", "middle;to","to", "from", "middle", "middle;to","middle"), dashes = c(FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, FALSE), shadow = c(FALSE, TRUE, FALSE, TRUE, FALSE, TRUE, FALSE, TRUE, TRUE), color = c("darkred", "grey", "orange", "darkblue", "purple","red","blue","pink","darkgray"));edges
visNetwork(nodes, edges, footer = "Fig.1 R을 사용한 네트워크 시각화", width = "100%")



###5.3.범례 생성하기

nodes <- data.frame(id = 1:8, label = paste("Node", 1:8), shape = c("square", "triangle", "box", "dot", "star", "ellipse", "database", "diamond"), group = c("A","B","A","B","A","B","A","B"), shadow = c(FALSE, TRUE, FALSE, TRUE, TRUE, TRUE, FALSE, TRUE));nodes
edges <- data.frame(from = c(1,6,2,3,4,7,1,6,1), to = c(5,3,5,7,7,1,4,2,8), label = paste("Edge", 1:9), length = c(100,200,300,400,300,200,100,500,100),width = c(4,1,3,2,4,1,2,3,4),arrows = c("to", "from", "middle", "middle;to","to", "from", "middle", "middle;to","middle"), dashes = c(FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, FALSE), shadow = c(FALSE, TRUE, FALSE, TRUE, FALSE, TRUE, FALSE, TRUE, TRUE), color = c("darkred", "grey", "orange", "darkblue", "purple","red","blue","pink","darkgray"));edges
visNetwork(nodes, edges, width = "100%") %>% visLegend()



nodes <- data.frame(id = 1:8, label = paste("Node", 1:8), shape = c("square", "triangle", "box", "dot", "star", "ellipse", "database", "diamond"), group = c("A","B","A","B","A","B","A","B"), shadow = c(FALSE, TRUE, FALSE, TRUE, TRUE, TRUE, FALSE, TRUE));nodes
edges <- data.frame(from = c(1,6,2,3,4,7,1,6,1), to = c(5,3,5,7,7,1,4,2,8), label = paste("Edge", 1:9), length = c(100,200,300,400,300,200,100,500,100),width = c(4,1,3,2,4,1,2,3,4),arrows = c("to", "from", "middle", "middle;to","to", "from", "middle", "middle;to","middle"), dashes = c(FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, FALSE), shadow = c(FALSE, TRUE, FALSE, TRUE, FALSE, TRUE, FALSE, TRUE, TRUE), color = c("darkred", "grey", "orange", "darkblue", "purple","red","blue","pink","darkgray"));edges
visNetwork(nodes, edges, width = "100%") %>% visLegend(position = "right", main = "범례")






##6.데이터를 사용하여 네트워크 생성하기

###6.1.레미제라블(Les miserables) 데이터
nodes <- jsonlite::fromJSON("https://raw.githubusercontent.com/datastorm-open/datastorm-open.github.io/master/visNetwork/data/nodes_miserables.json")
edges <- jsonlite::fromJSON("https://raw.githubusercontent.com/datastorm-open/datastorm-open.github.io/master/visNetwork/data/edges_miserables.json")



###6.2.레미제라블(Les miserables) 데이터를 사용해서 네트워크 생성하기

visNetwork(nodes, edges, height = "700px", width = "100%") 



visNetwork(nodes, edges, height = "700px", width = "100%") %>% visOptions(selectedBy = "group")



visNetwork(nodes, edges, height = "700px", width = "100%") %>% visOptions(selectedBy = "group", highlightNearest = TRUE)


visNetwork(nodes, edges, height = "700px", width = "100%") %>% visOptions(selectedBy = "group", highlightNearest = TRUE, nodesIdSelection = TRUE)



visNetwork(nodes, edges, height = "700px", width = "100%") %>% visOptions(selectedBy = "group", highlightNearest = TRUE, nodesIdSelection = TRUE) %>% visPhysics(stabilization = FALSE)














#########################공간 시각화###################
#######################지도 데이터 시각화 생성 ########################
#https://r-graph-gallery.com/330-bubble-map-with-ggplot2.html


# 라이브러리
library(ggplot2)
library(dplyr)

# 영국지도데이터
library(maps)
UK <- map_data("world") %>% filter(region=="UK"); UK

# 영국 도시의 위도 경도 인구수에 대한 데이터 생성 
data <- world.cities %>% filter(country.etc=="UK"); data


# 도시별 인구수 시각화
ggplot() +
  geom_polygon(data = UK, aes(x=long, y = lat, group = group), fill="grey", alpha=0.3) +
  geom_point( data=data, aes(x=long, y=lat)) +
  theme_void() + ylim(50,59) + coord_map() 

# 그 중 10개의 큰도시
library(ggrepel)
ggplot() +
  geom_polygon(data = UK, aes(x=long, y = lat, group = group), fill="grey", alpha=0.3) +
  geom_point( data=data, aes(x=long, y=lat, alpha=pop)) +
  geom_text_repel( data=data %>% arrange(pop) %>% tail(10), aes(x=long, y=lat, label=name), size=5) +
  geom_point( data=data %>% arrange(pop) %>% tail(10), aes(x=long, y=lat), color="red", size=3) +
  theme_void() + ylim(50,59) + coord_map() +
  theme(legend.position="none")











#########한국인구수 데이터 사용하기


setwd("/Users/seongminmun/Desktop/SL_FD/Data")
dir()
dataSK <- read.table("SK_pop.txt", header = T)
summary(dataSK)

library(geosphere)
library(maps)
SouthKorea <- map_data("world") %>% filter(region=="South Korea")
NorthKorea <- map_data("world") %>% filter(region=="North Korea")

Korea <- rbind(SouthKorea, NorthKorea)


ggplot() +
  geom_polygon(data = Korea, aes(x=long, y = lat, group = group), fill="grey", alpha=0.3) +
  geom_point(data=dataSK, aes(x=LON, y=LAT)) +
  theme_void() + coord_map() 


#한글 사용 (에러 해결))
#install.packages("showtext")
library(showtext)
font_add_google(name = "Nanum Gothic", family = "nanumgothic")
showtext_auto()

# 인구가 큰 3개의 도시
library(ggrepel)
ggplot() +
  geom_polygon(data = Korea, aes(x=long, y = lat, group = group), fill="grey", alpha=0.3) +
  geom_point(data=dataSK, aes(x=LON, y=LAT, alpha=총인구수)) +
  geom_text_repel( data=dataSK %>% arrange(총인구수) %>% tail(3), aes(x=LON, y=LAT, label=지역명), size=5) +
  geom_point( data=dataSK %>% arrange(총인구수) %>% tail(3), aes(x=LON, y=LAT), color="red", size=3) +
  theme_void() + coord_map() +
  theme(legend.position="none")



