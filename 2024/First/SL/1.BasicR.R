
######################기본사용법#######################

# 기본 연산하기
1 + 1

2 - 1

2 * 2

4 / 2





#몫과 나머지
#나눗셈 (실수로 표현된다.)
10 / 3
#몫
10 %/% 3
#나머지
10 %% 3

#거듭제곱
2^1
2^2
2^3






#함수를 사용한 산술연산
#최솟값
min(2,5,7)
#최댓값
max(4,10,13)
#절대값(absolute value)
abs(-6)
#제곱근(루트)
sqrt(36)
#팩토리얼
factorial(3)









######################변수#######################





#변수
#어떠한 값을 저장해 놓을 수 있는 상자 (변하는 수)
#하나의 값만을 저장할 수 있다.
a <- 5
a
print(a)


# 변수 & 산술연산
a <- 5
b <- 10
a+b
print(a+b)

c <- a+b
c
print(c)










# 변수명의 작명규칙
# - 첫글자는 .혹은 영문자로 시작해야한다.
# - 두번째 글자부터 숫자나 밑줄을 사용할 수 있다.
# - 대소문자를 구분한다.
a <- 10
A <- 11
a
A
# - 변수명 중간에 공백을 넣을 수 없다.








#변수에 저장 될 수 있는 자료형(값의 종류)
# 숫자
#정수
1
# 음수
-4
# 실수
0.7

#문자
"ajou"
'ajou'

#논리형
TRUE
FALSE
T
F

#특수값
#정의되지 않은 값
NULL
#결측치(비어 있는 값)
NA
#수학적 정의가 불가한 값
NaN
#무한대
Inf
-Inf















######################벡터#######################


# 1 벡터
# R에서 사용하는 가장 기본적인 단위
# c() 함수: 두개 이상의 벡터를 인수로 받아 이를 연결(concatenating)하여 새로운 벡터를 만드는 것



# 1.1 숫자 벡터
# 정수: 정수로 이루어진 벡터
a <- c(1, 2, 3, 4, 5)
a

# 실수: 소수점을 포함하고 있는 벡터
b <- c(1, 2.1, 3, 4, 5.1)
b

# 벡터의 결합
c <- c(a,b)
c

# 슬라이싱을 활용한 벡터 생성
# 정방향
1:10
# 역방향
10:1 
# 음수
-4:8
# 실수
0.7:8




# 생각하기
# 소수점 단위로 증가하려면 어떻게 해야하는가?
# seq(a,b,by=c) 함수: a부터 b까지 c만큼씩 증가하도록 벡터를 만들수 있다.
seq(1,5)


seq(1,5,by=0.5)

# 다른 사용법 1
seq(length=10, from = -3, by = 0.5)

# 다른 사용법 2: 인덱스 생성
a <- c(2,4,6,8,10)
seq(along=a)



# 생각하기
# 반복되는 벡터는 어떻게 생성할까?


# rep(): 벡터를 반복 시켜 새로운 벡터를 생성할 수 있게 해준다.
a <- c(1:5)
rep(a, times = 2)
#[1] 1 2 3 4 5 1 2 3 4 5
rep(a, each = 3)
#[1] 1 1 1 2 2 2 3 3 3 4 4 4 5 5 5














# 1.2 문자 벡터
# 문자를 요소로 하는 벡터이며, 범주형 데이터를 표현 할때 사용한다.
# c() 함수: 두개 이상의 벡터를 인수로 받아 이를 연결(concatenating)하여 새로운 벡터를 만드는 것

#기존의 데이터를 모두 제거
rm(list=ls())

# 문자 벡터 생성
alphabets <- c("a","b","c")
alphabets 

# 숫자 형을 문자 형으로 변환하기
numbers <- c(1,2,3)
numbers

# 자료형 확인
mode(numbers)

# 문자 형으로 변환하기
changeed <- as.character(numbers)
changeed



mode(changeed)



# 생각하기
# 문자열을 붙이는건 어떻게 할까?

a <- "Hello"
b <- "Ajou"
c <- a+b
c
# 에러가 발생한다.


# paste(): 문자 형의 벡터를 연결 할때 사용한다.
a <- "Hello"
b <- "Ajou"
c <- paste(a,b)
c

d <- paste(a,b,sep="")
d

# 생각하기
# 이름이 같고 번호가 붙은 변수 생성

a <- "Ajou"
b <- paste(a,1:10,sep="_")
b

# 세개 이상의 문자 연결
a <- "Ajou"
b <- paste(a,1:5,c("a","b","c","d","e"),sep="_")
b











# 문자열의 개수 계산하기
a <- "Ajou"
nchar(a)

# 배열에 담긴 문자의 개수 계산하기
b <- c("Hello", "Ajou", "nice", "to", "meet", "you")
nchar(b)
# [1] 5 4 4 2 4 3


# 생각하기
# 문자열을 나누는건 어떻게 할까?
strsplit("Hello Ajou", split=" ")



strsplit("2022-01-17", split="-")








# 1.3 논리 벡터
# 논리값을 요소로 하는 벡터이다.
# c() 함수: 두개 이상의 벡터를 인수로 받아 이를 연결(concatenating)하여 새로운 벡터를 만드는 것

#기존의 데이터를 모두 제거
rm(list=ls())

# 논리 벡터 생성
a <- c(TRUE, FALSE, TRUE); a

a <- c(T, F, T); a




# 비교 연산으로 논리값 생성하기

# 단일 변수
a <- 5
a > 3

# 연속 변수
a <- 1:5
a > 3




# 이상, 이하
a <- 1:5
a >= 3
a <= 3

# 같다
a == 3

# 다르다
a != 3










######################데이터 프레임#######################





# 데이터프레임
# 여러 타입의 데이터가 결합된 데이터 구조

#기존의 데이터를 모두 제거
rm(list=ls())



#데이터프레임 생성하기
ID <- c(1:6); ID
Gender <- c("M","F","M","F","M","M"); Gender
test <- data.frame(id=ID, gender=Gender); test #이름, 데이터





#데이터프레임 값 추가하기
eng <- c(90,88,92,86,82,89); eng
math <- c(98,89,87,76,85,74); math
scores = cbind(eng, math); scores

test.score <- data.frame(test, scores); test.score





#데이터프레임 요약하기
# 자료 형 확인
str(test.score)
mode(test.score$id)
mode(test.score$gender)

#데이터 요약
summary(test.score)

summary(as.factor(test.score$gender))

# 
#학생 추가하기
a <- data.frame(id=7,gender="M",eng=100,math=40); a
test.score.2 <- rbind(test.score, a); test.score.2








# 데이터프레임 연산하기

# 평균 계산하기
# 숫자 데이터만 추출하기
test.score.number <- test.score.2[,c(3:4)]; test.score.number


# 각 학생들의 전체 과목 평균 점수
apply(test.score.number,1,mean)


# 전체 학생들의 영어 수학의 평균
apply(test.score.number,2,mean)




#데이터 필터링하기

test.score.2
# 1,2변수만 보기
test.score.2[1:2]
# 1,2변수만 제거하고 보기
test.score.2[-(1:2)]

# 행렬 형태로 사용
test.score.2[1,] #1번째 행
test.score.2[1:2,3:4] #1-2번째행, 3-4 열

# 필터링하기
test.score.2[test.score.2$eng >= 90,]

test.score.2[test.score.2$math >= 85,]

# 필터링 결과에서 변수 선택하기
test.score.2[test.score.2$math >= 85,c("id","gender")]

# 영어 점수가 89이상인 학생들
eng89 <- test.score.2[test.score.2$eng >= 89,]

# 오름차순
eng89[order(eng89$eng), ]

# 내림차순
eng89[order(eng89$eng, decreasing = TRUE), ]









# subset을 사용한 필터링
subset(test.score.2, gender=="M")

subset(test.score.2, gender=="F")

subset(test.score.2, gender=="M", c("id","gender"))


# 조건식 활용
subset(test.score.2, eng>=89, c("id","gender","eng"))










# 데이터 입출력하기

# 데이터 출력하기
getwd()
setwd("/Users/seongminmun/Desktop/SL_FD/Data")
getwd()
dir()

write.csv(test.score.2, "testScore2.csv", fileEncoding="cp949")
dir()

write.table(test.score.2, "testScore2.txt", fileEncoding="UTF-8")
dir()





# 데이터 불러오기
testScore2Txt <- read.table("testScore2.txt", header=TRUE, fileEncoding="UTF-8")
testScore2Txt

testScore2Csv <- read.csv("testScore2.csv", header=TRUE, fileEncoding="UTF-8")
testScore2Csv

testScore2Csv <- testScore2Csv[-1]
testScore2Csv



















######################조건문과 반복문#######################

#조건문 
#if(조건){문장}
#조건이 만족되면 문장이 실행된다.(나머지)
money <- 5000
if (money > 3700) {
  print("택시를 타고가라.")
}





money <- 3000
if (money > 3700) {
  print("택시를 타고가라.")
} else {
  print("걸어가라.")
}







#반복문 만들기


#반복문,조건문
#for(변수 in 범위){문장}
#범위에 지정된 값만큼 변수 값이 변화하면서 '문장'을 반복 시행한다.
for(i in 1:3){
  print(i)
}



for(i in 1:3){
  x<-i*3
  print(x)
}




x<-c(50,60,80,90,95,91)
#데이터수
for(i in 1:length(x)){
  print(x[i])
}









#조건문 같이 사용하기
for(i in 1:10){
  if(i%%2==0){
    print(i)
  }
}

# == (같은가)
# != (다른가)
# a <= b (a가 b이하인가?)




# cat() 함수는 나열된 인수를 차례로 콘솔에 출력하는 함수
#if(조건){문장1}else{문장2}
#조건이 만족하면 문장1, 그렇지 않으면 문장2를 시행
for(i in 1:10){
  if(i%%2==0){
    cat(i,'는 짝수',"\n")
  }
  else if(i%%2!=0){
    cat(i,'는 홀수',"\n")
  }
}










