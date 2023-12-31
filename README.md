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

- Git Flow, 코드 컨벤션, 브랜치 전략, PR 및 코드리뷰, 내부 세미나와 같이 팀 프로젝트에서 겪을 수 있는 다양한 경험들을 했습니다.
- `Design System`을 적용해서 UI 일관성을 유지하고 작성 리소스를 확보하는 방법을 학습했습니다.
- iOS 최소 지원버전으로 사용할 수 없는 컴포넌트 기능을 직접 구현하여 사용했습니다. - [관련 포스팅](https://velog.io/@wontaeyoung/swiftui4)
- `Listener`를 사용해서 실시간 채팅 기능을 구현했습니다. 두 클라이언트의 데이터 동기화 및 상호작용 시나리오에 대해 고민해보고 해결할 수 있는 경험이었습니다. - [관련 포스팅](https://velog.io/@wontaeyoung/swiftui3)
- `ScenePhase`를 사용하여 앱의 Life Cycle을 활용하는 방법을 학습했습니다. - [관련 포스팅](https://velog.io/@wontaeyoung/swiftui7)
- `ScrollViewReader`로 프로그래밍적으로 화면을 스크롤링 하는 방법을 학습했습니다. - [관련 포스팅](https://velog.io/@wontaeyoung/swiftui2)

<br>

## Feature UI

|메세지 보내기|
|-|
|<img width="700" alt="메세지 보내기" src="https://github.com/wontaeyoung/GitSpace/assets/45925685/62a6e123-81f3-4883-9a46-e6a503cd512b">|
- 메세지 전송 버튼을 누르면 서버에 업로드합니다.
- 상대방 클라이언트의 Listener가 서버 업데이트를 감지하여 두 클라이언트를 동기화해서 실시간 채팅이 동작합니다.


<br><br><br>

|메세지 인터랙션|
|-|
|<img width="300" alt="메세지 인터랙션" src="https://github.com/wontaeyoung/GitSpace/assets/45925685/55ab6596-8392-4287-b6dc-bdbeca57a1ff">|
- Long Press 제스처로 메세지 버블에 대한 인터랙션을 할 수 있습니다.
- 내 메세지에 대해서는 삭제, 상대 메세지에 대해서는 신고 동작을 할 수 있습니다.


<br><br><br>

|메세지 삭제|
|-|
|<img width="700" alt="메세지 삭제" src="https://github.com/wontaeyoung/GitSpace/assets/45925685/289341f0-4dce-4e9a-acdd-15db82015f77">|
- 삭제 버튼을 누르면 서버에서 해당 메세지를 삭제합니다.
- 상대방 클라이언트의 Listener가 이를 감지해서 동일한 메세지를 삭제합니다.


<br><br><br>

|메세지 읽음 처리|
|-|
|<img width="300" alt="메세지 읽음 처리" src="https://github.com/wontaeyoung/GitSpace/assets/45925685/1c29c727-bc56-48d7-81ab-f09a0cb4477a">|
- 읽지 않은 메세지가 있을 때 채팅방을 입장해서 해당 메세지를 읽으면, 읽지 않은 메세지 카운트가 0으로 초기화됩니다.


<br><br><br>

|실시간 메세지 읽음 처리|
|-|
|<img width="300" alt="실시간 메세지 읽음 처리" src="https://github.com/wontaeyoung/GitSpace/assets/45925685/f40f7497-ba7a-4d0e-89d5-4041b1501e7b">|
- 채팅방에 입장한동안 새롭게 받은 메세지는 모두 읽음 처리됩니다.


<br><br><br>

|읽지 않은 메세지 시작 위치로 이동|
|-|
|<img width="300" alt="읽지 않은 메세지 시작 위치로 이동" src="https://github.com/wontaeyoung/GitSpace/assets/45925685/6e4aa499-2f25-4bca-bfa9-03e7c71911d1">|
- 채팅방 입장 시, 읽지 않은 메세지 중 첫 번째 메세지 위치로 자동 스크롤됩니다.


<br><br><br>

|읽지 않은 메세지 삭제|
|-|
|<img width="700" alt="읽지 않은 메세지 삭제" src="https://github.com/wontaeyoung/GitSpace/assets/45925685/90b3f067-78f0-48cd-9ae5-482a4ce733f7">|
- 읽지 않은 메세지를 상대방이 삭제하면, 이에 맞춰서 읽지 않은 메세지 카운트가 감소합니다.
- 만약 상대방이 삭제한 메세지가 마지막 메세지라면, 그 이전 메세지로 마지막 메세지가 수정됩니다.


<br><br><br>

|커스텀 TextEditor|
|-|
|<img width="300" alt="읽지 않은 메세지 삭제" src="https://github.com/wontaeyoung/GitSpace/assets/45925685/3b0e1ae7-9a52-45e4-b2a2-026ca6446a0d">|
- 커스텀 텍스트에디터를 디자인 시스템으로 구현했습니다.
- 높이 계산 로직을 통해 최대 5줄 높이까지 동적으로 계산하여 변화합니다.
- 해당 컴포넌트에 기능을 추가하고 최소 지원버전을 낮춰 [AutoHeightEditor](https://github.com/wontaeyoung/AutoHeightEditor)라는 오픈소스 라이브러리를 공개했습니다.


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
