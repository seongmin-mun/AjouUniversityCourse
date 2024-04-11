#참고: https://kilhwan.github.io/rprogramming/ch-visualization.html
#기존의 데이터를 모두 제거
rm(list=ls())

#데이터 시각화를 위한 그래픽 패키지를 설치한다.
install.packages("ggplot2")
library(ggplot2)








#########################비교 시각화###################

?mpg

summary(mpg)

str(mpg)


# 산점도 그려보기
ggplot() + geom_point(mapping=aes(x=displ, y=hwy), data=mpg)



# 1.범주형 변수를 색상(color) 속성에 매핑하기
ggplot() + geom_point(mapping=aes(x=displ, y=hwy, color=class), data=mpg)





# 2.범주형 변수를 모양(shape) 속성에 매핑하기
ggplot() + geom_point(mapping=aes(x=displ, y=hwy, shape=drv), data=mpg)




# 3.연속형 변수를 크기(size), 투명도(alpha), 색상(color) 속성에 매핑하기
ggplot() + geom_point(mapping=aes(x=cty, y=hwy, size=displ), data=mpg)



ggplot() + geom_point(mapping=aes(x=cty, y=hwy, color=displ), data=mpg)


ggplot() + geom_point(mapping=aes(x=cty, y=hwy, alpha=cyl), data=mpg)





# 4. 도형의 여러 속성에 데이터 열을 매핑시키기

ggplot() + geom_point(mapping=aes(x=displ, y=hwy, color=drv, shape=drv), data=mpg)


ggplot() + geom_point(mapping=aes(x=displ, y=hwy, color=class, shape=drv), data=mpg)






# 5. 측면(facets)으로 나누어 그리기
ggplot() + geom_point(mapping=aes(x=displ, y=hwy), data=mpg) + facet_wrap(~class, nrow = 2)

ggplot() + geom_point(mapping=aes(x=displ, y=hwy), data=mpg) + facet_wrap(~drv + year, nrow = 2)


# 6. facet_grid()로 이차원 측면 그래프 그리기
ggplot() + geom_point(mapping=aes(x=displ, y=hwy), data=mpg) + facet_grid(drv~cyl)





# 7. 추세선 (95%신뢰구간 인터벌) 그리기
# 산점도
ggplot() + geom_point(mapping=aes(x=displ, y=hwy), data=mpg)

#추세선 
ggplot() + geom_smooth(mapping=aes(x=displ, y=hwy), data=mpg)

# 두개 그래프 병합하여 사용하기
ggplot() + geom_point(mapping=aes(x=displ, y=hwy), data=mpg) + geom_smooth(mapping=aes(x=displ, y=hwy), data=mpg)

# 변수를 추가해서 그리기
ggplot() + geom_point(mapping=aes(x=displ, y=hwy), data=mpg) +
  geom_smooth(mapping=aes(x=displ, y=hwy), data=mpg) + 
  geom_point(mapping=aes(x=displ, y=cty), data=mpg, col="red", shape=1) +
  geom_smooth(mapping=aes(x=displ, y=cty), data=mpg, linetype=2, col="red")




# 8. 데이터 선택해서 다르게 표현하기
# 다른 데이터 범위로 그래프 계층 만들기
ggplot() +
  geom_point(mapping=aes(displ, hwy), data=mpg) +
  geom_point(mapping=aes(displ, hwy), 
             data=filter(mpg, displ > 5, hwy > 20), 
             color="red", size=2)









#########################시간 시각화###################


Orange

summary(Orange)

str(Orange)


# Tree: 나무의 분류 (5그루의 나무)
# age: 나무의 나이
# circumference: 나무의 둘레(mm)

# 산점도 그려보기
ggplot() + geom_point(mapping=aes(x=age, y=circumference), data=Orange)



# 1. 선그래프 그려보기
ggplot() + geom_line(mapping=aes(x=age, y=circumference), data=Orange)


# 2. group속성을 사용하여 나무별로 그려보기
ggplot() + geom_line(mapping=aes(x=age, y=circumference, group=Tree), data=Orange)




# 3.나무 별 색상 추가하기
ggplot() + 
  geom_line(mapping=aes(x=age, y=circumference, group=Tree, color=Tree), data=Orange )

#간결과 하기
ggplot() + geom_line(mapping=aes(x=age, y=circumference, color=Tree), data=Orange)





# 4. 선의 타입을 변경하기
ggplot() + geom_line(mapping=aes(x=age, y=circumference, linetype=Tree), data=Orange)




# 5. 추세선 생성하기
#geom_smooth() 함수에서 group 속성

ggplot() + geom_smooth(mapping=aes(x=age, y=circumference), data=Orange )

ggplot() + geom_smooth(mapping=aes(x=age, y=circumference, color=Tree), data=Orange )













#########################분포 시각화###################


# 1. 상자그림 그리기
#기본형
p <- ggplot(mpg, aes(class, cty))
p + geom_point()
#실제 데이터보다 점이 더 적게 찍힌 것을 볼 수 있다. 
# 이는 동일한 지점에 여러 데이터가 표현되었기 때문이다.



# 2.분포표현
p + geom_jitter(width = 0.2)
# geom_jitter()로 범주별로 수치 변수의 대락적 분포를 확인할 수는 있으나 전체적인 분포를 요약하여 비교하긴 어렵다.


# 3.상자 그림
p + geom_boxplot()
# 상자그림은 4분위 수로 표현한다



# 4.V자로 표현
p + geom_boxplot(notch = T)
#모집단 중위수에 대한 신뢰구간을 같이 표시하고 싶으면 notch=TRUE로 하여 상자그림을 그린다. 
#만약 두 종류의 차의 V자 모양의 notch가 서로 겹치지 않는다면 두 종류의 차의 도심 연비의 중위수가 통계적으로 유의미하게 다르다는 것을 의미한다. 


# 5.분포를 더 정확히 확인
p + geom_violin()
# 바이롤린 차트는 수치 변수의 확률밀도를 추정하여 확률밀도가 높은 곳은 폭이 넓게, 확률밀도가 낮은 곳은 폭이 좁게 그래프를 그려주는데, 이 모향이 바이올린 모양을 닯아서 바이올린 차트라 한다.





# 6. 좌표계의 변경해서 그래프 생성하기
# 히스토그램 생성하기
p <- ggplot(mpg, aes(cty)) + geom_histogram(binwidth=1)
p


# 7. 히스토그램 축 반전 시켜서 생성하기
p + coord_flip()



# 8. coord_polar()는 직교좌표계를 극좌표계로 변경해 준다
p + coord_polar()








