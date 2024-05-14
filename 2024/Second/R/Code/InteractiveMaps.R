####인터렉티브 맵 



#생성 패키지(leaflet) 설치
install.packages("leaflet")
library(leaflet)

#파이프 사용하기 위해서 사용
install.packages("dplyr")
library(dplyr)




# 기본 지도 바탕 생성
map <- leaflet(); map





# 지도 바탕 위에 타일 생성
map <- leaflet() %>% addTiles(); map





# 서로 상이한 모습의 타일 생성하기
str(providers)
map <- leaflet() %>% addProviderTiles(providers$Esri); map

map <- leaflet() %>% addProviderTiles(providers$Esri.WorldImagery); map

map <- leaflet() %>% addProviderTiles(providers$CartoDB.DarkMatter); map

map <- leaflet() %>% addProviderTiles(providers$CartoDB.Positron); map





# 초기 위치(관점)지정하기
map <- leaflet() %>% addTiles() %>% setView(lng=127.04, lat=37.28, zoom = 15); map






# 마커 생성하기
map <- leaflet() %>% addTiles() %>% setView(lng=127.04, lat=37.28, zoom = 15) %>% addMarkers(lng=127.0462, lat=37.2819); map

#팝업 추가하기
map <- leaflet() %>% addTiles() %>% setView(lng=127.04, lat=37.28, zoom = 15) %>% addMarkers(lng=127.0462, lat=37.2819, popup="아주대학교"); map


##각자 위치 찍어보기
##구글에서 좌표 가져오기
##왼쪽 커서 클릭 - 이곳이궁금한가요 클릭 - 회색포인트 클릭






# 여러 다른 모양의 마커 생성하기
# 깃발
map <- leaflet() %>% addTiles() %>% setView(lng=127.04, lat=37.28, zoom = 15) %>% addAwesomeMarkers(lng=127.0462, lat=37.2819, icon= awesomeIcons(icon = 'flag', markerColor = 'orange', iconColor = 'white')); map

# 집
map <- leaflet() %>% addTiles() %>% setView(lng=127.04, lat=37.28, zoom = 15) %>% addAwesomeMarkers(lng=127.0462, lat=37.2819, icon= awesomeIcons(icon = 'home', markerColor = 'blue', iconColor = 'white')); map


??addAwsomeMarkers
??awesomeIcons


## 원형 마커 생성하기
map <- leaflet() %>% addTiles() %>% setView(lng=127.04, lat=37.28, zoom = 15) %>% addCircleMarkers(lng=127.0462, lat=37.2819, radius = 20); map






####데이터와 연동하기
##스타벅스 데이터


#경로 확인및 지정
getwd()
setwd("/Users/seongminmun/Desktop/Development/Rprogram/R_Script/AjouUniv/2024/SL_FD_2/Data/")
dir()

#한국어를 사용하는 경유 인코딩 변경
Sys.setlocale(category = "LC_CTYPE", locale = "ko_KR.UTF-8")
#window사용
#options(encoding = 'UTF-8')

Starbucks <- read.csv("Starbucks_utf8.csv",head=T); Starbucks
head(Starbucks)
str(Starbucks)





#타일생성하기
map <- leaflet() %>% addProviderTiles(providers$CartoDB.Positron); map

# 초기 위치(관점)지정하기
map <- leaflet() %>% addProviderTiles(providers$CartoDB.Positron) %>% setView(lng=127.04, lat=37.28, zoom = 11); map

#원으로 데이터 표시하기
map <- leaflet(Starbucks) %>% addProviderTiles(providers$CartoDB.Positron) %>% setView(lng=127.04, lat=37.28, zoom = 11) %>% addCircles(lng=~long, lat=~lat, color='#006633'); map


#색상추가하기
# 팔레트 생성
pal <- colorFactor("viridis", levels = Starbucks$code)
map <- leaflet(Starbucks) %>% addProviderTiles(providers$CartoDB.Positron) %>% setView(lng=127.04, lat=37.28, zoom = 9) %>% addCircles(lng=~long, lat=~lat, color=~pal(code)); map



#범례 추가하기
map <- leaflet(Starbucks) %>% addProviderTiles(providers$CartoDB.Positron) %>% setView(lng=127.04, lat=37.28, zoom = 9) %>% addCircles(lng=~long, lat=~lat, color=~pal(code)) %>% addLegend(data = Starbucks, position = "bottomright", pal = pal, values = ~code, title = "범례", opacity = 1); map




#팝업 데이터 추가하기
StarbucksPop <- Starbucks %>% mutate(pop = paste('코드: ',code,'<br> 위도:', lat,'<br> 경도:', long))
head(StarbucksPop)
map <- leaflet(StarbucksPop) %>% addProviderTiles(providers$CartoDB.Positron) %>% setView(lng=127.04, lat=37.28, zoom = 9) %>% addCircles(lng=~long, lat=~lat, color=~pal(code), popup = ~pop) %>% addLegend(data = Starbucks, position = "bottomright", pal = pal, values = ~code, title = "Legend", opacity = 1); map





#데이터 연동하고 원의 크기 생성
#경로 확인및 지정
getwd()
setwd("/Users/seongminmun/Desktop/Development/Rprogram/R_Script/AjouUniv/2024/SL_FD_2/Data/")
dir()

#한국어를 사용하는 경유 인코딩 변경
Sys.setlocale(category = "LC_CTYPE", locale = "ko_KR.UTF-8")
#window사용
#options(encoding = 'UTF-8')

dataSK <- read.table("SK_pop.txt", header = T)
summary(dataSK)

#인구수를 데이터 사이즈로 사용
map <- leaflet(dataSK) %>% addProviderTiles(providers$CartoDB.Positron) %>% setView(lng=127.04, lat=37.28, zoom = 7) %>% addCircles(lng=~LON, lat=~LAT, radius=~sqrt(총인구수)*3) ; map


#데이터 변형
# 집단 정보 추가하기
dataSKClass <- dataSK %>% mutate(class = ifelse(총인구수>mean(총인구수),"1","0"))
head(dataSKClass)


#색상 수동으로 생성하기
pal <- colorFactor(c("#ffa500", "#13ED3F"), domain=c("1", "0"))
map <- leaflet(dataSKClass) %>% addProviderTiles(providers$CartoDB.Positron) %>% setView(lng=127.04, lat=37.28, zoom = 7) %>% addCircles(lng=~LON, lat=~LAT, radius=~sqrt(총인구수)*3, color=~pal(class)) ; map


#색상에 따른 범례 수동으로 생성하기
map <- leaflet(dataSKClass) %>% addProviderTiles(providers$CartoDB.Positron) %>% setView(lng=127.04, lat=37.28, zoom = 7) %>% addCircles(lng=~LON, lat=~LAT, radius=~sqrt(총인구수)*3, color=~pal(class)) %>% addLegend("bottomright", colors= c("#ffa500", "#13ED3F"), labels=c("1", "0"), title="도시 밀집도"); map











# 기타 추가
# 미니맵 생성하기
map <- leaflet(dataSKClass) %>% addProviderTiles(providers$CartoDB.Positron) %>% setView(lng=127.04, lat=37.28, zoom = 7) %>% addCircles(lng=~LON, lat=~LAT, radius=~sqrt(총인구수)*3, color=~pal(class)) %>% addLegend("bottomleft", colors= c("#ffa500", "#13ED3F"), labels=c("1", "0"), title="도시 밀집도") %>% addMiniMap(width = 150, height = 150); map



# 데이터들 순서대로 선 생성하기 -> 경로 지도위에 표시
map <- leaflet(dataSKClass) %>% addProviderTiles(providers$CartoDB.Positron) %>% setView(lng=127.04, lat=37.28, zoom = 7) %>% addCircles(lng=~LON, lat=~LAT, radius=~sqrt(총인구수)*3, color=~pal(class)) %>% addLegend("bottomleft", colors= c("#ffa500", "#13ED3F"), labels=c("1", "0"), title="도시 밀집도") %>% addMiniMap(width = 150, height = 150) %>% addPolylines(lng=~LON, lat=~LAT, weight=.5); map







