# Information
PR 및 Issue는 [원본 레포지토리](https://github.com/APPSCHOOL1-REPO/finalproject-gitspace)에서 확인 가능합니다!

<br><br>

# Introduce
Github API를 통해 Repository, Follow, Activity와 같은 정보를 받고, 사용자가 Starred한 Repository를 클라이언트의 커스텀 태그로 카테고리를 묶어서 관리할 수 있습니다.

특정 레포지토리의 Contributor에게 노크를 요청할 수 있고, 상대방이 이를 수락하면 채팅을 진행할 수 있습니다.

<br><br>

# Onwer Feature
GitSpace의 채팅 기능에 오너십을 가지고 관련 로직과 UI를 개발했습니다.

[Listener 활용 채팅 구현 과정 포스팅](https://velog.io/@wontaeyoung/swiftui3)

<br>

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
