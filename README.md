# SniffMEET

<img src="https://github.com/user-attachments/assets/4e3bd3bb-17d7-4cee-bc41-3d5f97967691" width = 200 >

</br>
</br>

> SniffMEET은 반려견에게 친구를 만들어 주고 싶다는 작은 바램에서 시작했습니다.

</br>
</br>

## **👩🏻‍💻🧑🏻‍💻** 팀원 소개

| <img src="https://github.com/pearhyunjin.png"> | <img src="https://github.com/green-yoon87.png"> | <img src="https://github.com/kelly-chui.png"> | <img src="https://github.com/soletree.png"> |
| --- | --- | --- | --- |
| [배현진](https://github.com/pearhyunjin) | [윤지성](https://github.com/green-yoon87) | [최진원](https://github.com/kelly-chui) | [허혜민](https://github.com/soletree) |

</br>
</br>

## **🎯** 프로젝트 목표

- **반려견 성향에 맞춰 산책 친구를 맺을 수 있는 서비스를 제공하자.**
    
    🐾  사람이 아닌 반려동물의 입장에서 친구를 구하고 싶어요
    
    🐾  현재 산책하고 있는 중에 빠르게 산책 친구를 구하고 싶어요
    
    🐾  비슷한 산책 성향을 가진 반려동물 친구를 구하고 싶어요
    

</br>
</br>

## **🐶** 'SniffMEET'에서 가능한 것

### 익명 로그인

- 반려동물 정보 입력만으로 앱 이용이 가능해요
- 반려동물 정보는 홈 프로필 카드를 통해 확인 / 수정할 수 있어요

<img src="https://github.com/user-attachments/assets/d86ca49e-f017-4c8e-b8b0-cdce988cd51c" width = 200 >
<img src="https://github.com/user-attachments/assets/69232bf7-0352-4f88-970e-1929aa1681fd" width = 200 >
<img src="https://github.com/user-attachments/assets/f55fd88a-0e49-4843-b579-9df23e3e59c3" width = 200 >

</br>

### 메이트 맺기

- 네임드랍 형태의 기능을 통해 즉석에서 메이트 맺기를 요청할 수 있어요
- 요청이 들어오면 어떤 반려동물인지 정보를 확인할 수 있어요
- 수락시 메이트 관계가 형성되어 이후 함께 산책할 수 있어요
- 거절도 가능해요

<img src="https://github.com/user-attachments/assets/d86ca49e-f017-4c8e-b8b0-cdce988cd51c" width = 200 >
<img src="https://github.com/user-attachments/assets/525123a0-e6f7-4fd6-9b14-6b25e091a314" width = 200 >
<img src="https://github.com/user-attachments/assets/9a3f7743-73ee-4f9e-8cca-e5b01b544cca" width = 200 >

</br>

### 산책 요청

- 내 메이트들에게 산책을 요청할 수 있어요
- 간단한 메세지와 만남의 장소를 정해 요청할 수 있어요
- 지도에서 만날 장소를 지정할 수 있어요
- 알림을 통해 메이트에게 요청이 전달돼요

<img src="https://github.com/user-attachments/assets/33eb7547-ae77-4ee4-83c4-604c0ac3b0c6" width = 200 >
<img src="https://github.com/user-attachments/assets/41eeb613-1266-4b8f-9ef1-13aa99828da0" width = 200 >
<img src="https://github.com/user-attachments/assets/36eeb0d8-187f-4054-a1ce-fc0252c587f3" width = 200 >
<img src="https://github.com/user-attachments/assets/8f1362df-3ef6-4e5e-a59b-1e028c368f1f" width = 200 >

</br>

### 📌 이후 추가 예정이에요

- 산책 기록을 남길 수 있어요
- 산책 기록을 모아 리포트를 발행해 드려요
- 이미지 분석을 통해 정확한 산책 기록이 가능해요
- 회원가입을 통한 계정 관리로 더 편리한 사용을 지원해요
- 오프라인 만남이 발생하는 환경이니 신고와 차단 기능으로 메이트를 관리할 수 있어요

</br>
</br>

## **🛠** 기술 스택

### 패턴

- VIPER
- Repository
- 위 패턴으로 진행하며 추가하고 싶은 내용 의논해보고 적용

### Swift Concurrency

동시성 프로그래밍을 위해서는 Swift Concurrency를 선택했습니다. </br>
코드의 뎁스가 깊어지지 않는다는 점에서 가독성이 우수합니다. </br>
또한 에러 핸들링할 때 GCD는 컴파일 에러가 발생하지 않는다는 점과 비교하면 에러 핸들링도 우수합니다.

### Combine

비동기 이벤트를 처리하기 위해서 first-party 프레임워크인 Combine을 선택했습니다.

### MapKit

사용성이 편리하다는 점과 지도 커스텀이 비교적 쉬운 MapKit을 선택했습니다.

### Firebase

필요한 익명 Auth, Messaging 기능을 사용하기 위해 선택했습니다.

### CoreData

유저의 정보 및 산책 히스토리 데이터를 영속적으로 저장하기 위해 선택했습니다. </br>
복잡한 데이터 관계 및 구조를 쉽게 관리할 수 있습니다.

</br>
</br>

## **🛠** 개발 환경

| 항목 | 내용 |
| --- | --- |
| 개발 툴 | Xcode 16+ |
| 타켓 버전 | iOS 15+ |
| 버전 관리 도구 | GitHub |
| 코드 품질 관리 도구 | SwiftLint |
| 의존성 관리 도구 | Swift Package Manager (SPM) |

</br>
</br>

## **🔒** 라이센스

- 미정

</br>
</br>

## **📁** 문서

| [팀노션](https://www.notion.so/check-it/SniffMeet-129f6d0576c28022a263f6673925113e?pvs=4)  | [Wiki](https://github.com/boostcampwm-2024/iOS03-SniffMeet/wiki) | [디자인](https://www.figma.com/design/hqvx1sLktjajEBcT0lGhyd/SniffMeet?node-id=0-1&m=dev&t=JhNxpBr3EsmhXR5k-1) | [프로덕트 백로그](https://check-it.notion.site/e2052f2712f04f478190eaad9998ff26?pvs=4) |
|:-:|:-:|:-:|:-:|

</br>
</br>

📆 2024. 10. 28 - 진행 중
