# gyeolhap
## 🦊 게임 화면


<img src="https://user-images.githubusercontent.com/55867479/100044509-125a4080-2e53-11eb-89f3-5f97a0633a65.png" width="300">



## 🦊 How to Play

![image](https://user-images.githubusercontent.com/55867479/100490923-04faca00-3163-11eb-9c4b-56e94b29a62e.png)



1. 모든 타일은 색, 모양, 배경색 3가지 속성을 갖고 있습니다.

2. 이 중에서 각각의 속성이 서로 다 같거나 다 다른 타일 3개를 뽑으면 합(정답)이 됩니다.

### 예시

![image](https://user-images.githubusercontent.com/55867479/100491089-63747800-3164-11eb-9980-5533673ad4a3.png)

3. 모든 합(정답)을 다 찾아 낸뒤 '**결**' 버튼을 누르면 게임이 종료됩니다.

### 패널티 

틀린 '합 조합'을 입력하면 풀이 시간이 10초 증가 합니다.

모든 정답을 다 찾이 않은 상태에서 '결' 버튼을 누르면 풀이 시간이 30초 증가합니다.



## 🦊 기능

### 메뉴 화면(10%)
- [ ] 임시 화면 표시(Play버튼만 있음)
- [ ] 메뉴 화면 디자인
- [ ] 테마 설정

### 스테이지 화면 (0%)
- [ ] 싱글 플레이지만 서로 같이 플레이하는 느낌을 주기 위해서 스테이지별로 고정된 문제 내기
- [ ] 100여개 정도의 스테이지 생성
- [ ] 스테이지 화면 디자인

### 게임 화면 (40%)

#### 문제 생성 및 화면 구현

- [X] 0~26중에 9개의 중복되지 않는 랜덤숫자를 생성함
- [x] 배경, 색, 모양의 3가지 속성마다 갖는 3가지 값을 위의 27가지 값과 연결함(3진법 사용)
  - 예를들어 0은 0번째 배경, 0번째 색, 0번째 모양/ 4는 1번째 배경, 1번째 색, 0번째 모양
- [x] 위에서 구해진 속성값을 바탕으로 화면을 구성함
- [x] 문제를 생성하고 정답 리스트를 생성해서 디버깅용으로 화면에 보여주기
- [x] 타일들을 클릭할 때마다 테두리가 생기거나 사라짐
- [x] 선택된 타일들이 총 3개가 되면 정답인지 체크해서 정답이면 정답칸에 보여줌
  - [x] 틀린 경우에는 선택이 해제됨
- [X]  결버튼 구현
- [x] 타이머 구현

#### 사용자 인터랙션
- [X] 타일 클릭가능하게 만들기
- [X] 클릭한 타일이 3개가 되면 합인지 아닌지 판단
- [X] 합이면 합목록에 추가
- [ ] 결버튼을 누르면 모든 정답을 다 찾았는지 확인하고 틀리면 +30초 증가
- [ ] 합을 잘못 찾은 경우에 타이머 +10초 하기

#### 결 성공시(모든 답을 다 찾고 결버튼을 눌렀을 때)
- [ ] 성공 메세지 보여주기
- [ ] 리플레이 버튼 구현
- [ ] 다음 문제 버튼 구현
- [ ] 메인 메뉴로 돌아가는 버튼 구현

#### 스테이지 화면
- [ ]  스테이지 정보를 JSON파일로 관리해서 게임 정보를 저장할 수 있게 하기
- [ ]  완료된 스테이지는 색을 다르게 하고 클리어 시간을 적어놓기

#### 일시정지 버튼 눌렀을 때
- [ ] 일시 정지 버튼 상단에 만들기
- [ ] 게임 되돌아가기 버튼
- [ ] 게임 나가기 버튼
- [ ] 테마 변경 버튼
- [ ] 스테이지 선택 버튼
