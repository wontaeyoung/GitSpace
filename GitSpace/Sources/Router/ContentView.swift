//
//  ContentView.swift
//  GitSpace
//
//  Created by 이승준 on 2023/01/17.
//

import SwiftUI

struct ContentView: View {
    
    // let stars = MainHomeView()
    // let chats = MainChatView()
    // let knocks = MainKnockView()
    // let profile = MainProfileView()
    
    @StateObject var tabBarRouter: GSTabBarRouter
	@EnvironmentObject var knockViewManager: KnockViewManager
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var githubAuthManager: GitHubAuthManager
	@EnvironmentObject var pushNotificationManager: PushNotificationManager
	@EnvironmentObject var chatStore: ChatStore
    @EnvironmentObject var blockedUsers: BlockedUsers
    
    var body: some View {
        /**
         현재 라우팅 하고있는 page에 따라서
         상단에는 해당 page에 대응하는 view를 보여주고
         하단에는 tabBar를 보여준다.
         */
        GeometryReader { geometry in
            /**
             모든 뷰는 하나의 네비게이션 스택에서 계층 구조를 갖는다.
             뷰의 이동은 탭으로 조정한다.
             */
            NavigationView {
                if UIScreen().isWiderThan375pt {
                    VStack(spacing: -10) {
                        showCurrentTabPage()
                        showGSTabBar(geometry: geometry)
                    }
                    .edgesIgnoringSafeArea(.horizontal)
                    .edgesIgnoringSafeArea(.bottom)
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                    
                    // MARK: - DEVICE가 SE인 경우
                } else {
                    VStack(spacing: -10) {
                        showCurrentTabPage()
                        showGSTabBar(geometry: geometry)
                    }
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                }
            }
            .navigationViewStyle(.stack)
        }
        .task {
            // Authentication의 로그인 유저 uid를 받아와서 userStore의 유저 객체를 할당
            if let uid = githubAuthManager.authentification.currentUser?.uid {
				await userStore.updateUserInfoOnFirestore(
                    userID: uid,
                    with: .deviceToken(
                        token: pushNotificationManager.currentUserDeviceToken ?? "PUSHNOTIFICATION NOT GRANTED"
                    )
                )
                
				// userInfo 할당
                Utility.loginUserID = uid
                await userStore.requestUser(userID: uid)
                await retrieveBlockedUserList()
                userStore.addListener()
            } else {
                print("Error-ContentView-requestUser : Authentication의 uid가 존재하지 않습니다.")
            }
        }
        .onDisappear {
            userStore.removeListener()
        }
    }
    
    /**
     현재 선택된 tabPage에 따라 탭페이지를 보여준다.
     반환되는 View의 타입이 tabPage에 따라 다르기 때문에 ViewBuilder를 사용해준다.
     - Author: 제균
     */
    @ViewBuilder private func showCurrentTabPage() -> some View {
		if let tabPagenation = tabBarRouter.currentPage {
			switch tabPagenation {
			case .stars:
				MainHomeView()
			case .chats:
				MainChatView(chatID: pushNotificationManager.viewBuildID ?? chatStore.newChat.id)
			case .knocks:
                MainKnockView()
			case .profile:
				MainProfileView()
			}
		} else {
			MainHomeView()
		}
    }
    
    /**
     탭바를 보여준다.
     */
    private func showGSTabBar(geometry: GeometryProxy) -> some View {
        return GSTabBarBackGround.CustomTabBarBackgroundView(style: .rectangle(backGroundColor: .black)) {
            GSTabBarIcon(tabBarRouter: tabBarRouter, page: .stars, geometry: geometry, isSystemImage: true, imageName: "sparkles", tabName: "Stars")
            GSTabBarIcon(tabBarRouter: tabBarRouter, page: .chats, geometry: geometry, isSystemImage: true, imageName: "bubble.left", tabName: "Chats")
            GSTabBarIcon(tabBarRouter: tabBarRouter, page: .knocks, geometry: geometry, isSystemImage: false, imageName: "KnockTabBarIcon", tabName: "Knocks")
            GSTabBarIcon(tabBarRouter: tabBarRouter, page: .profile, geometry: geometry, isSystemImage: false, imageName: "avatarImage", tabName: "Profile")
        }
        .frame(width: geometry.size.width, height: 48)
//        .padding(.bottom, 20)
    }
    
    /**
     currentUser의 BlockedUserList를 가져옵니다.
     가져온 유저 목록은 blockedUsers의 blockedUserList에 저장됩니다.
     - blockedUsers.blockedUserList: [(userInfo, gitHubUser)]
     - Author: 한호
     */
    private func retrieveBlockedUserList() async {
        if let currentUser = await userStore.requestUserInfoWithID(userID: userStore.currentUser?.id ?? "") {
            
            for someUser in currentUser.blockedUserIDs {
                if let userInfo = await UserStore.requestAndReturnUser(userID: someUser) {
                    let gitHubUser = githubAuthManager.getGithubUser(FBUser: userInfo)
                    let blockedUser: (userInfo: UserInfo, gitHubUser: GithubUser) = (userInfo, gitHubUser)
                    
                    if !blockedUsers.blockedUserList.contains(where: { $0.userInfo.id == userInfo.id }) {
                        blockedUsers.blockedUserList.append(blockedUser)
                    }
                }
            }
        }
    }
}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView(tabBarRouter: GSTabBarRouter())
//            .environmentObject(ChatStore())
//            .environmentObject(MessageStore())
//            .environmentObject(UserStore())
//            .environmentObject(RepositoryViewModel())
//            .environmentObject(TagViewModel())
//    }
//}
