# Information

PR 및 Issue는 [원본 레포지토리](https://github.com/APPSCHOOL1-REPO/finalproject-gitspace)에서 확인 가능합니다!

[앱스토어 링크](https://apps.apple.com/kr/app/gitspace/id6446034470)

<br><br>

# Introduce

GitHub API를 통해 Repository, Follow, Activity와 같은 정보를 받고, 사용자가 Starred한 Repository를 클라이언트의 커스텀 태그로 카테고리를 묶어서 관리할 수 있습니다.

특정 레포지토리의 Contributor에게 노크를 요청할 수 있고, 상대방이 이를 수락하면 채팅을 진행할 수 있습니다.

<br><br>

# Onwer Feature

GitSpace의 채팅 기능에 오너십을 가지고 관련 로직과 UI를 개발했습니다.

<br>


- SwiftUI와 Firestore를 사용하여 채팅 UI 및 로직 구현
    - Listener의 데이터 동기화를 이용한 채팅 로직 구현
    - ScrollViewReader를 이용한 proxy 스크롤링 동작
    - Life Cycle을 활용하여 상대방이 읽지 않은 메세지 카운터 처리

- MVVM을 간소화 한 MVS 적용
    - Store가 ObservableObject를 채택
    - Published 래퍼로 프로퍼티 바인딩 관리, 비즈니스 로직을 처리하는 단방향 아키텍처

- NSCache를 이용한 이미지 캐싱을 구현하여 이미지 요청 횟수 감소

- 메세지 입력 필드로 사용하기 위해 동적으로 높이가 변하는 커스텀 TextEditor 구현
    - 텍스트 길이, 개행 문자, 행간, 폰트 사이즈를 통해 실시간으로 Height를 계산하여 높이 조절


<br>

## Feature UI

|메세지 보내기|
|-|
|<img width="700" alt="메세지 보내기" src="https://github.com/wontaeyoung/GitSpace/assets/45925685/ea1e0953-6b94-47eb-9ed9-245f6f7165d4">|
- 메세지 전송 버튼을 누르면 서버에 업로드합니다.
- 상대방 클라이언트의 Listener가 서버 업데이트를 감지하여 두 클라이언트를 동기화해서 실시간 채팅이 동작합니다.

<br><br><br>

|메세지 인터랙션|
|-|
|<img width="300" alt="메세지 인터랙션" src="https://github.com/wontaeyoung/GitSpace/assets/45925685/7b9dc19e-5bf8-44ab-b011-729984aa9d96">|
- Long Press 제스처로 메세지 버블에 대한 인터랙션을 할 수 있습니다.
- 내 메세지에 대해서는 삭제, 상대 메세지에 대해서는 신고 동작을 할 수 있습니다.

<br><br><br>

|메세지 삭제|
|-|
|<img width="700" alt="메세지 삭제" src="https://github.com/wontaeyoung/GitSpace/assets/45925685/76800fbc-40ce-4628-9783-b9f94a88bfd7">|
- 삭제 버튼을 누르면 서버에서 해당 메세지를 삭제합니다.
- 상대방 클라이언트의 Listener가 이를 감지해서 동일한 메세지를 삭제합니다.

<br><br><br>

|메세지 읽음 처리|
|-|
|<img width="300" alt="메세지 읽음 처리" src="https://github.com/wontaeyoung/GitSpace/assets/45925685/bd54d255-a352-41d8-92bc-222fc84ab667">|
- 읽지 않은 메세지가 있을 때 채팅방을 입장해서 해당 메세지를 읽으면, 읽지 않은 메세지 카운트가 0으로 초기화됩니다.

<br><br><br>

|실시간 메세지 읽음 처리|
|-|
|<img width="300" alt="실시간 메세지 읽음 처리" src="https://github.com/wontaeyoung/GitSpace/assets/45925685/5f3e3191-0f11-44f8-9f7b-8cbe91bf6016">|
- 채팅방에 입장한동안 새롭게 받은 메세지는 모두 읽음 처리됩니다.

<br><br><br>

|읽지 않은 메세지 시작 위치로 이동|
|-|
|<img width="300" alt="읽지 않은 메세지 시작 위치로 이동" src="https://github.com/wontaeyoung/GitSpace/assets/45925685/2c0f2219-b2f8-4b5d-8070-bb6a566448b8">|
- 채팅방 입장 시, 읽지 않은 메세지 중 첫 번째 메세지 위치로 자동 스크롤됩니다.

<br><br><br>

|읽지 않은 메세지 삭제|
|-|
|<img width="700" alt="읽지 않은 메세지 삭제" src="https://github.com/wontaeyoung/GitSpace/assets/45925685/cd800361-d532-4c9c-b812-c78e985c1bca">|
- 읽지 않은 메세지를 상대방이 삭제하면, 이에 맞춰서 읽지 않은 메세지 카운트가 감소합니다.
- 만약 상대방이 삭제한 메세지가 마지막 메세지라면, 그 이전 메세지로 마지막 메세지가 수정됩니다.

<br><br><br>

|커스텀 텍스트 에디터|
|-|
|<img width="300" alt="읽지 않은 메세지 삭제" src="https://github.com/wontaeyoung/GitSpace/assets/45925685/ec91ec85-0664-4bdd-9dbf-e43e2c18ebc2">|
- 커스텀 텍스트에디터를 디자인 시스템으로 구현했습니다.
- 높이 계산 로직을 통해 최대 5줄 높이까지 동적으로 계산하여 변화합니다.
- 커스텀하게 된 배경과 구현 과정은 상단 포스팅에서 확인 가능합니다.

<br><br><br>

**관련 포스팅**
- [Listener 활용 채팅 구현 과정 포스팅](https://velog.io/@wontaeyoung/swiftui3)
- [동적 높이 커스텀 텍스트에디터 배경 및 구현 과정 포스팅](https://velog.io/@wontaeyoung/swiftui4)

<br><br>

# -ing

2023.05에 1차 출시 후, 추가 기능 및 보안 업데이트를 진행했습니다.

2023.10부터 GitSpacer Organization을 생성하고 레포지토리 이사 및 이전부터 논의했던 리팩토링을 시작했습니다.

MVVM 적용 시 겪으면서 불편했던 점, 모듈화 필요성, 코드 컨벤션과 같은 문제들에 대해 의견을 나누고, 새롭게 도입할 아키텍처, 라이브러리에 대해 학습 후 팀 내에서 세미나를 진행했습니다.

팀원들과 나눈 의견을 토대로 SwiftUI의 선언형 UI에 적합한 단방향 아키텍처인 TCA를 도입하고, Feature 개발을 모듈화하는 시도를 해보기로 하였습니다.

현재는 주 단위로 회의를 진행하며 도입할 기술들을 학습하고 적용해보는 과정을 진행하고 있습니다.
