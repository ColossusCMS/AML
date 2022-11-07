<p align="center">
  <h1 align="center">AML</h1>
  <p align="center">-Album, Music, Lyrics-</p>
  <p align="center">(※ 내가 필요해서, 나 혼자 쓰려고 만듦)</p>
  
  <p align="center">
  <img width="200" src="https://user-images.githubusercontent.com/22445932/200247149-2ea7dd58-d50a-4c4e-b6b9-91f7c6c0f431.png"/>
  </p>
  
  <p align="center">
  발매될 앨범 정보를 한 눈에 파악할 수 있고 로컬에 보관하고 있는 음악파일 검색에 가사 검색까지!<br/>
    <br/>
    <img width="220" src="https://user-images.githubusercontent.com/22445932/200238023-e79f2a3c-d0bf-4b0a-9e5f-79f214d9fc0c.png"/>
    <img width="220" src="https://user-images.githubusercontent.com/22445932/200238032-c5a7fa16-198f-4bb0-a9b7-7d6355ee5dd6.png"/>
    <img width="220" src="https://user-images.githubusercontent.com/22445932/200238045-f101e76a-c6e0-41d7-9baf-afde65583985.png"/>
    <img width="220" src="https://user-images.githubusercontent.com/22445932/200238048-9c68ae35-da9b-4959-a92b-4762a0ac7026.png"/>
  <br/>
</p>

<!-- ABOUT THE PROJECT -->
## 개요

서브컬쳐 관련 앨범들의 관련 정보들을 한 곳에 정리해두고 필요할 때 바로바로 확인할 수 있는 그런 앱이 필요했다. 다시 말해, 관련 정보에 대해서 찾으러 다니는 게 귀찮아서 정보가 공개될 때 처음 한 번 저장해서 다시 찾으러 다니기 싫어서 만든 앱.

그런데 만들다보니 앨범 정보만 관리하려고 했는데 앨범 정보를 등록하는 과정에서 내가 이전에 구매는 했는데 앨범 정보만 등록하지 않았는건지 헷갈리는 경우가 발생해 로컬 서버에 있는 음악 파일도 검색하는 기능이 추가!

그러다가 음악만 찾기 좀 허전해서 이왕 이렇게 된 거 가사까지 검색해보자!해서 가사 검색 기능까지 또 추가!


<!-- GETTING STARTED -->
## 기능 설명

- 앨범 정보 리스트
- 앨범 정보 등록
- 로컬 음악 파일 검색
- 가사 검색
- 사용자 정보

### 앨범 정보 리스트

<img width="300" src="https://user-images.githubusercontent.com/22445932/200238009-cd857a97-c771-4885-8e36-4c067b182007.png"/> <img width="300" src="https://user-images.githubusercontent.com/22445932/200238032-c5a7fa16-198f-4bb0-a9b7-7d6355ee5dd6.png"/> <img width="300" src="https://user-images.githubusercontent.com/22445932/200238024-918e1e97-dfee-45bd-87c2-881d0b947e58.png"/>

※ DB에 저장되어 있는 앨범 정보를 리스트로 보여주고 패널을 확장하면 더 자세한 정보들을 볼 수 있다.

<img width="300" src="https://user-images.githubusercontent.com/22445932/200238036-c8dbacac-2ee3-4c9f-9223-06cd4a685f07.png"/>

※ 사용자 등록 후 로그인을 하면 숨겨진 기능이!?

- 초기 리스트에서는 발매일과 앨범명을 보여주면서 패널을 확장하면 앨범아트, 가수 및 소속명을 확인할 수 있다.
- 앨범 정보로 넘어가면 좀 더 디테일한 정보를 확인할 수 있으며, 로그인 유무에 따라 각 정보 수정도 가능!

### 앨범 정보 등록

<img width="300" src="https://user-images.githubusercontent.com/22445932/200254435-c2129bb7-a941-4ab6-b7f9-41ee41874a76.png"/> <img width="300" src="https://user-images.githubusercontent.com/22445932/200238038-8be37b1d-9955-4615-962b-afddb575a775.png"/> <img width="300" src="https://user-images.githubusercontent.com/22445932/200238040-9eb3c174-ffd4-4b5d-87ed-83d7d7c9d94d.png"/>

※ 앨범아트는 로컬에 저장된 이미지를 등록할 수도 있고 직접 이미지 주소를 입력해 등록할 수도 있다.


- 앨범 등록은 권한이 부여된 유저만 가능하다. 로그인하지 않고 해당 메뉴를 선택해도 메뉴 진입이 되지 않으니 주의!
- 입력한 정보는 서버로 전송되어 DB에 저장이 되고, 만약 로컬의 이미지를 선택해 앨범아트를 등록했다면 이 역시 서버로 파일을 전송해 특정 위치에 파일을 저장, 관리한다.
- 앨범아트를 특별히 등록하지 않는다면 기본 앨범아트로 등록이 된다.

### 로컬 음악 파일 검색

<img width="300" src="https://user-images.githubusercontent.com/22445932/200238042-eb167ea4-471e-4744-aed6-6c6bddc5119f.png"/> <img width="300" src="https://user-images.githubusercontent.com/22445932/200238045-f101e76a-c6e0-41d7-9baf-afde65583985.png"/>

※ 로컬 서버에 저장되어 있는 .mp3 또는 .flac 파일을 찾아본다.


- 앨범 정보 등록에서 중복 등록이 되거나, 과거에 음악은 구매했지만 앨범 정보를 등록하지 않아 누락된 부분이 있을지 모르니 그 전에 찾아볼 수 있는 기능.
- 또는 어딘가에서 들었던 노래를 혹시 과거의 내가 구매해서 가지고 있는지도 알아볼 수 있으니 우연히 찾게 되면 플리에도 넣어두고 기분도 같이 좋아질 수도???

### 가사 검색

<img width="300" src="https://user-images.githubusercontent.com/22445932/200238047-eb0c7611-c9fa-42fd-8669-6681aafe3f4c.png"/> <img width="300" src="https://user-images.githubusercontent.com/22445932/200238048-9c68ae35-da9b-4959-a92b-4762a0ac7026.png"/> <img width="300" src="https://user-images.githubusercontent.com/22445932/200238053-143b52b7-0e29-4a42-9ef3-b8b5915d5d19.png"/>

※ 서브컬처를 즐긴다면 일본어 가사는 기본이라구!


- 가사 검색은 서버에서 웹크롤링으로 특정 사이트에서 가사를 검색한다.
- 국내에 정발되지 않은 J-Pop 일본어 가사 지원을 위해 [J-Lyric](https://j-lyric.net/)에서 가사를 검색, 그 외의 음악은 [Naver Vibe](https://vibe.naver.com/today)에서 검색한다.
- 노래 제목 또는 제목과 가수로 검색할 수 있지만 검색 결과가 너무 많을 경우에는 시간이 좀 걸릴테니 여유있게 기다려주자.
- 외국어라고 해서 자동으로 번역해주는 기능은 없으니 많은 것을 바라지는 말자.

### 사용자 정보 및 로그인

<img width="300" src="https://user-images.githubusercontent.com/22445932/200260479-aa980610-0bbb-4422-9a15-036556f2fafc.png"/> <img width="300" src="https://user-images.githubusercontent.com/22445932/200238056-e3595abe-6a49-4a95-8507-5c0d83ea245a.png"/> <img width="300" src="https://user-images.githubusercontent.com/22445932/200238057-0c57136d-b0d9-4003-94e5-d3f533d931ff.png"/>

※ 사용자 정보, 로그인 정보 등은 Firebase와 연동해서 관리하고 있다.

<img width="300" src="https://user-images.githubusercontent.com/22445932/200238033-17821a98-aec0-46ea-83ac-a2803411af9a.png"/> <img width="300" src="https://user-images.githubusercontent.com/22445932/200238035-3ed1d3b7-b721-416e-8b7e-2409514318d5.png"/>

※ 기본적으로 제공하는 기능이 많이 있지만 데이터 수정, 삭제가 필요하다면 로그인은 필수!

- 로그인 기능을 제공하니 필요하다면 사용자 등록으로 계정 등록을 해서 필요하다면 신규 앨범 정보를 등록하거나 기존의 앨범 정보를 수정하거나 삭제할 수 있다.
- 다만 사용자가 본인 한 명이기 때문에 앨범 정보를 사용자마다 구분하지 않기 때문에 모든 사용자가 같은 정보를 공유한다.
- 사용자 등록은 이메일과 비밀번호를 기반으로, 등록 후에 사용자 정보에서 프로필 이미지를 등록하거나 별명을 지정할 수 있고, 비밀번호 변경도 가능하다.
- 프로필 이미지는 등록하지 않는다면 기본 프로필 이미지로 선택되고, 이미지를 등록하면 서버로 프로필 이미지를 전송해 서버에서 관리한다.


<!-- ACKNOWLEDGEMENTS -->
## 기술스택
* Application

  * <img src="https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=Flutter&logoColor=white"/> / <img src="https://img.shields.io/badge/Dart-0175C2?style=flat-square&logo=Dart&logoColor=white"/>
  * <img src="https://img.shields.io/badge/Android-3DDC84?style=flat-square&logo=Android&logoColor=white"/> / <img src="https://img.shields.io/badge/Kotlin-7F52FF?style=flat-square&logo=Kotlin&logoColor=white"/>

* Server
  * <img src="https://img.shields.io/badge/Spring%20Boot-6DB33F?style=flat-square&logo=SpringBoot&logoColor=white"/>
  * <img src="https://img.shields.io/badge/Python-3776AB?style=flat-square&logo=Python&logoColor=white"/>
  * <img src="https://img.shields.io/badge/MariaDB-003545?style=flat-square&logo=MariaDB&logoColor=white"/>


<!-- CONTACT -->
## 링크

최문석(Munseok Choi)

[Rocket Punch @yaahq123](https://www.rocketpunch.com/@yaahq123)

[Resume](https://github.com/your_username/repo_name)
