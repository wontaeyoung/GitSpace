//
//  MainHomeView.swift
//  GitSpace
//
//  Created by 이승준 on 2023/01/17.
//

import SwiftUI

struct MainHomeView: View {
    
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var gitHubAuthManager: GitHubAuthManager
    @ObservedObject var eventViewModel = EventViewModel(gitHubService: GitHubService())
    @State private var selectedHomeTab = "Starred"
    
    private let starTab = "Starred"
    private let activityTab = "Activity"
    private let service = GitHubService()
    
    var body: some View {
        VStack {
            /* Starred, Activity Tab Button */
            HStack {
                GSButton.CustomButtonView(
                    style: .homeTab(
                        tabName: starTab,
                        tabSelection: $selectedHomeTab
                    )
                ) {
                    selectedHomeTab = starTab
                } label: {
                    Text(starTab)
                        .font(.title3)
                        .foregroundColor(selectedHomeTab == starTab ? .primary : .gsGray2)
                        .bold()
                        .padding(.bottom, 4)
                }
                .tag(starTab)
                
                Divider()
                    .frame(height: 10)
                    .padding(.horizontal, 4)
                
                GSButton.CustomButtonView(
                    style: .homeTab(
                        tabName: activityTab,
                        tabSelection: $selectedHomeTab
                    )
                ) {
                    selectedHomeTab = activityTab
                } label: {
                    Text(activityTab)
                        .font(.title3)
                        .foregroundColor(selectedHomeTab == activityTab ? .primary : .gsGray2)
                        .bold()
                        .padding(.bottom, 4)
                }
                .tag(activityTab)
                
                Spacer()
            }
            .overlay(alignment: .bottom) {
                Divider()
                    .frame(minHeight: 0.5)
                    .overlay(Color.primary)
                    .offset(y: 3.5)
            }
            .padding(16)
            
            /* Starred, Activity View */
            switch selectedHomeTab {
            case starTab:
                StarredView()
                    .ignoresSafeArea()
                    
            case activityTab:
                ActivityView(eventViewModel: eventViewModel)
                    .ignoresSafeArea()
                    .task {
                        guard let currentGitHubUser = gitHubAuthManager.authenticatedUser?.login else { return }
                        do {
                            try await eventViewModel.requestAuthenticatedUserReceivedEvents(who: currentGitHubUser)
                        } catch(let error) {
                            print(error)
                        }
                        
                    }
            default:
                Text("네트워크 에러입니다.")
            }
            
        }
        
        // FIXME: - 추후 네비게이션 타이틀 지정 (작성자: 제균)
        .navigationTitle("")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Text("GitSpace")
                    .font(.title2)
                    .bold()
            }
            
            //TODO: - 이후 push notication 기능이 완전히 구현되었을 때 다시 넣을 예정
//            ToolbarItem(placement: .navigationBarTrailing) {
//                NavigationLink {
//                    NotificationView()
//                } label: {
//                    Image(systemName: "bell")
//                        .foregroundColor(.primary)
//                }
//            }
            
        }
    }
}

struct MainHomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MainHomeView()
        }
    }
}
