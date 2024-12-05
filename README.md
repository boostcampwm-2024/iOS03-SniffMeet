---
# SniffMEET

<img src="https://github.com/user-attachments/assets/c64cdb32-ad35-405e-9776-3bc6be7fb300">

<img src="https://github.com/user-attachments/assets/4e3bd3bb-17d7-4cee-bc41-3d5f97967691" width = 200 >

> SniffMEET 아이콘


SniffMEET는 반려견 산책 친구를 찾는 새로운 방식을 제공합니다.   

🐾 즉석에서 만난 사람들과 연락처 공유 없이 프로필 드랍 기능을 통해 메이트를 맺을 수 있어요.  
🐾 메이트 관계인 반려견 정보를 확인할 수 있어요.  
🐾 메이트 관계를 맺은 사람에게만 산책 요청을 보낼 수 있어요.  
🐾 산책 요청은 장소와 메시지를 함께 보낼 수 있어요.  

SniffMEET에서 반려견과의 산책을 더욱 특별하게 만들어보세요.  
새로운 인연, 행복한 산책으로 이어져요. 🐶💛  

# **📱** 기술적 도전 

## Profile Drop 기능
NameDrop 형태의 방식으로 기기간 특정 액션에 대한 반응으로 반려견 프로필 카드를 공유할 수 있는 서비스를 제공합니다. 애플에서 공식으로 제공하는 NameDrop API가 없기 때문에
NearbyInteraction + MultipeerConnectivity 이용하여 직접 비슷한 형태로 구현해보기로 했습니다.
아래는 동작 방식에 대한 플로우입니다.

![Screenshot 2024-11-14 at 1 48 06 AM](https://github.com/user-attachments/assets/0889a8d0-c4b1-4f50-a930-c633ada1140f)

- 기기들은 각각 NISession과 MPCSession을 독립적으로 시작합니다.
- 각 기기들은 MPCSession을 통해 Advertising / Browsing 작업을 수행합니다. 
- 기기가 발견된다면 Invite 하고 세션을 연결합니다.
- NISession은 시작되면 자동으로 기기마다 DiscoveryToken을 생성합니다.
- DiscoveryToken을 기기끼리 교환하기 위해서 MPCSession을 이용합니다.
- DiscoveryToken이 정상적으로 교환되면 NISession으로 연결되고 기기의 거리와 방향을 파악할 수 있습니다.
- 이후, 해당하는 거리와 방향에 있는 기기와 MPCSession을 통해 데이터(프로필 카드)를 교환하게 됩니다.
- 두 피어간에 데이터 교환이 마치게 되면 NI, MPC Session 모두 종료됩니다. 

## 트러블슈팅

### 🔥 중복 연결 문제

`startAdvertising`으로 기기 존재를 광고하고 `startBrowsing`으로 기기를 탐색해서 invite를 보내는 과정에서, 양쪽 기기 모두 advertising, browsing, invite를 진행해 양방향 연결 형태로 구현되었고 연결 불안정의 문제가 발생했습니다.

### 결론

`PassthroughSubject` 이용해 invite 받았는지를 파악하고 받은경우 더이상 invite를 보내지 않도록 `stopbrowsing`하여 단방향 연결 상태를 유지하도록 했습니다.

### 🔥 연결성 문제

```
PeerConnection connectedHandler (advertiser side) - error [Unable to connect].
PeerConnection connectedHandler remoteServiceName is nil.
[GCKSession] Not in connected state, so giving up for participant [1C22D602] on channel [0].ll
```

위와 같은 오류들이 발생하며 `MPCSession`이 Connected 상태가 된 이후 바로 Disconnected되는 상황이 발생했습니다.

### 결론

처음에는 연결 성공이 랜덤으로 발생한다고 생각했지만, 여러가지 환경 통제 방식의 빌드 테스트를 통해 p2p wifi 연결 상태에서만 불안정하고 일반 wifi 연결 상태에서는 연결이 안정적인 것을 발견했습니다. 테스트를 해봐도 코드 상의 문제는 없어 보였고, 동일한 코드에서 와이파이 종류에 따라 연결 상태가 다를 수 없을 것이라 생각해 코드 외적인 부분을 살폈고 문제를 찾을 수 있었습니다.

p2p 와이파이 연결을 위해서는 로컬 네트워크 권한이 반드시 필요한데, 초기 셋팅 과정에서 추가한 권한이 PR 충돌 해결과정에서 누락되며 권한조건이 사라진 상태였습니다. 권한 다시 추가하였고 연결 상태가 모두 정상임을 확인할 수 있었습니다.

### 🔥 기기 간 방향 파악 문제

```
// 방향 측까지 전부 성공한 기기 로그
Distance and Direction to peer: 0.84639883 and SIMD3<Float>(-0.30216265, 0.33539462, -0.892305)
Distance and Direction to peer: 0.7151826 and SIMD3<Float>(-0.35387823, 0.27636543, -0.89352804)
Distance and Direction to peer: 0.7253396 and SIMD3<Float>(-0.07152926, 0.03417755, -0.99685276)

// 방향 측정 실패한 기기 로그
Distance and Direction to peer: 0.6682374 and SIMD3<Float> (0.1, 0.1, 0.1)
Distance and Direction to peer: 0.51894075 and SIMD3<Float>(0.1, 0.1, 0.1)
Distance and Direction to peer: 0.32887232 and SIMDЗ<Float>(0.1, 0.1, 0.1)
Distance and Direction to peer: 0.17357983 and SIMD3<Float>(0.1, 0.1, 0.1)
```

NI 이용해 기기 간 거리와 방향을 측정하는 시점에서 두 기기 중 한 기기에서 방향만 측정이 안되는 상태를 발견했습니다.

### 결론

동일한 메서드에서 거리와 방향을 측정하게 되는데, 방향만 측정되지 않는다는 점에서 기기 문제를 떠올렸고, 다른 기기와 교차검증을 시도했습니다. 그 결과 1개의 기기에서만 방향이 측정되지 않는것을 확인할 수 있었고, 기기 문제로 결론내렸습니다.

NI를 위해서는 U1칩이 필요한데, 기기에서 그 부분에 문제가 있는 것 같습니다. 하지만 시도해볼 수 있는 기기의 수가 한정적이었기 때문에 100퍼센트의 확신을 할 수는 없는 상태입니다.

### 🔥 시점 차이로 인한 일방적인 세션 종료 문제

두 기기 서로에 대한 거리와 방향을 측정하지만 설정한 특정 방향과 거리의 조건을 만족하는 시점 차이가 존재한다. 이처럼 만족하는 시점이 다름에 따라 한쪽 기기에서만 데이터 수신 후 일방적으로 세션이 종료되는 문제 발생하여 다른 기기에서는 프로필 공유가 되지 않았다. 

또한 NI는 세션 연결된 기기에 대해서 짧은 시간 주기 마다 방향과 거리 측정으로 에너지 소모가 큰 기능이므로 최소한의 동작 시간을 유지할 필요가 있다. 

### 결론

종료되는 시점을 자신이 데이터 수신하고 상대방 기기에게도 수신 플래그를 받은 시점으로 한다.

1. 기기 간 거리 및 방향에 대한 조건을 만족하는 경우 `send` 플래그 전송
2. `receive` 플래그를 수신할 때 까지 대기 
3. `receive` 플래그를 수신받으면 상대방 정보를 보여주는 뷰를 화면에 표시하게 된다.

<img src = "https://github.com/user-attachments/assets/423edcf5-4da0-4c7c-8294-82713504df88" width = "500">

# **🐶** 'SniffMEET'에서 가능한 것

### 익명 로그인
- 반려동물 정보 입력만으로 앱 이용이 가능해요
- 반려동물 정보는 홈 프로필 카드를 통해 확인 / 수정할 수 있어요

|온보딩 및 로그인|반려동물 정보 수정|
|---|---|
|<img src="https://github.com/user-attachments/assets/dad6bf82-6d75-4c49-862d-6a991b4664c0" width = 200 >|<img src="https://github.com/user-attachments/assets/a3b1dbf9-2fea-488a-8d2f-e132e0d532bd" width = 200 >|
</br>

### 메이트 맺기
- 프로필 드랍 형태의 기능을 통해 메이트 맺기를 요청할 수 있어요
- 직접 만난 상대만 메이트를 맺을 수 있어요
- 요청이 들어오면 요청 상대의 반려동물의 정보를 확인할 수 있어요
- 수락시 메이트 관계가 형성되어 이후 산책을 요청할 수 있어요

|프로필 드랍|상대 반려견 정보 확인|메이트 목록|
|---|---|---|
|<img src="https://github.com/user-attachments/assets/181f392b-c241-4674-a8e8-6363f1e2b99e" width = 200 >|<img src="https://github.com/user-attachments/assets/458bb507-f388-4471-8717-a06bb668fde0" width = 200 >|<img src="https://github.com/user-attachments/assets/f6b66520-23ff-4fba-9351-736abfd93c35" width = 200 >|

### 산책 요청

- 내 메이트들에게 산책을 요청할 수 있어요
- 간단한 메세지와 만남의 장소를 정해 요청할 수 있어요
- 지도에서 만날 장소를 지정할 수 있어요
- 알림을 통해 메이트에게 요청이 전달돼요

|산책 요청 보내기|산책 요청 수락 알림|
|---|---|
|<img src="https://github.com/user-attachments/assets/ce16c025-f6e9-41b6-a9b7-534410d738c6" width = 200 >|<img src="https://github.com/user-attachments/assets/d502945c-6960-40a9-8ee4-4b6ced624c09" width = 200 >|

</br>
</br>

# **🛠** 기술 스택

### VIPER 패턴

팀원들이 모두 사용해보고 싶었던 패턴이라 고려해보게 되었습니다.
구조가 전부 나눠져 있어 초기 설정이 부담된다는 점이 있지만 좀 더 각각의 역할을 명확하게 나누는 과정을 경험할 수 있습니다.
역할이 잘 구분되어 있다는 점에서 기능 추가 작업시 수정의 범위가 줄어든다는 점이 있어서 원활히 협업할 수 있었습니다. 

<img src="https://github.com/user-attachments/assets/d5e05abd-9db2-438e-a1be-7c63fecbf8f1">

### Swift Concurrency

동시성 프로그래밍을 위해서는 Swift Concurrency를 선택했습니다. 
코드의 뎁스가 깊어지지 않는다는 점에서 가독성이 우수합니다.
또한 에러 핸들링할 때 GCD는 컴파일 에러가 발생하지 않는다는 점과 비교하면 에러 핸들링도 우수합니다. 
네트워크와 DB 처리 과정에서 주로 사용합니다.

### Combine

비동기 이벤트를 처리하기 위해서 first-party 프레임워크인 Combine을 선택했습니다.
데이터 바인딩과 UI 처리 과정에서 주로 사용합니다.

### MapKit

사용성이 편리하다는 점과 커스텀이 비교적 간편한 이유로 지도 사용에 MapKit을 선택했습니다.

### Supabase
Supabase 서버와 HTTP REST API로 직접 통신하도록 Supabase Layer를 애플리케이션 내부에서 자체적으로 구현했습니다.
Supabase 유저와 세션 복원이나 갱신과 같은 로직을 직접 구현해서 사용합니다.
![image](https://github.com/user-attachments/assets/8f11c4a1-3606-4919-b131-599fae3f0eb4)

### Nearby Interaction

특정 거리와 방향을 만족하는 기기에 대해서만 프로필 공유가 가능하게 하기 위해 선택했습니다. NI는 탐색한 기기의 거리와 방향을 파악할 수 있습니다. 
하지만 UWB를 지원하는 기기(iPhone 11+)에 제한되어 사용 가능합니다.

### Multipeer Connectivity

Nearby Interaction에서 지원하지 않는 데이터 교환을 위해 선택했습니다.
와이파이나 블루투스를 이용해 기기를 탐색하고 연결해 데이터를 전송할 수 있습니다.
로컬 네트워크를 이용하여 DiscoveryToken과 프로필 카드 정보를 교환하는 역할을 합니다.

### Push Notification

산책 요청 / 응답 시 사용자에게 알림을 보내기 위해 Push Notification 서버를 Vapor를 통해 구현했습니다. 

# **👩🏻‍💻🧑🏻‍💻** 팀원 소개

| <img src="https://github.com/pearhyunjin.png"> | <img src="https://github.com/green-yoon87.png"> | <img src="https://github.com/kelly-chui.png"> | <img src="https://github.com/soletree.png"> |
| --- | --- | --- | --- |
| [배현진](https://github.com/pearhyunjin) | [윤지성](https://github.com/green-yoon87) | [최진원](https://github.com/kelly-chui) | [허혜민](https://github.com/soletree) |

# **🛠** 개발 환경

| 항목 | 내용 |
| --- | --- |
| 개발 툴 | Xcode 16+ |
| 타켓 버전 | iOS 15+ |
| 버전 관리 도구 | GitHub |
| 코드 품질 관리 도구 | SwiftLint |
| 의존성 관리 도구 | Swift Package Manager (SPM) |

# **📁** 문서

| [팀노션](https://www.notion.so/check-it/SniffMeet-129f6d0576c28022a263f6673925113e?pvs=4)  | [Wiki](https://github.com/boostcampwm-2024/iOS03-SniffMeet/wiki) | [디자인](https://www.figma.com/design/hqvx1sLktjajEBcT0lGhyd/SniffMeet?node-id=0-1&m=dev&t=JhNxpBr3EsmhXR5k-1) | [프로덕트 백로그](https://check-it.notion.site/e2052f2712f04f478190eaad9998ff26?pvs=4) |
|:-:|:-:|:-:|:-:|

📆 2024. 10. 28 - 진행 중
