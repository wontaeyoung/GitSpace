//
//  SetAccountView.swift
//  GitSpace
//
//  Created by 최한호 on 2023/02/09.
//

import SwiftUI

struct SetAccountView: View {
    
    @EnvironmentObject var gitHubAuthManager: GitHubAuthManager
    @EnvironmentObject var blockedUsers: BlockedUsers
    @State private var showingLogoutAlert = false
    @State private var showingDeleteAccountAlert = false
    
    @EnvironmentObject private var chatViewModel: ChatStore
    @EnvironmentObject private var knockViewManager: KnockViewManager
    
    var body: some View {
        List {
            // MARK: - APP MANAGEMENT
            Section {
                HStack {
                    Text("Username")
                    Spacer()
                    Text("\(gitHubAuthManager.authenticatedUser?.login ?? "")")
                        .foregroundColor(.gsLightGray2)
                }
            } header: {
                Text("ACCOUNT INFORMATION")
            } // Section
            
            // MARK: Blocked Users
            /// 차단한 유저 리스트
            Section {
                NavigationLink {
                    BlockedUsersListView()
                } label: {
                    HStack {
                        Text("Blocked users")
                        Spacer()
                        if !blockedUsers.blockedUserList.isEmpty {
                            Text("\(blockedUsers.blockedUserList.count)")
                                .foregroundColor(.gsLightGray2)
                        }
                    }
                }
            } // Section
            
            // MARK: Sign out / Delete Account
            /// 로그아웃 / 계정 삭제
            Section {
                Button(role: .cancel) {
                    showingLogoutAlert.toggle()
                } label: {
                    Text("Sign out")
                }
                
                Button(role: .destructive) {
                    showingDeleteAccountAlert.toggle()
                } label: {
                    Text("Delete Account")
                }

            } header: {
                Text("ACCOUNT MANAGEMENT")
            } // Section
            
        } // List
        .navigationBarTitle("Account", displayMode: .inline)
        .alert("Sign out", isPresented: $showingLogoutAlert) {
              Button("Sign out", role: .destructive) {
                  blockedUsers.blockedUserList.removeAll()
                  gitHubAuthManager.signOut()
              }
        } message: {
            Text("Sign out from ") + Text("@\(gitHubAuthManager.authenticatedUser?.login ?? "") ").bold() + Text("account.")
        }
        .alert("Delete Account", isPresented: $showingDeleteAccountAlert) {
              Button("Delete", role: .destructive) {
                  Task {
                      blockedUsers.blockedUserList.removeAll()
                      await gitHubAuthManager.deleteCurrentUser()
                      await gitHubAuthManager.withdrawal()
                      reset()
                  }
              }
        } message: {
            Text("@\(gitHubAuthManager.authenticatedUser?.login ?? "") ").bold() + Text("account will be deleted.\nAre you sure?")
        }
    }
    
    private func reset() {
        chatViewModel.removeListener()
        knockViewManager.removeSnapshot()
        chatViewModel.removeChatList()
        knockViewManager.removeKnockList()
        chatViewModel.isDoneFetch = false
    }
}

struct SetAccountView_Previews: PreviewProvider {
    static var previews: some View {
        SetAccountView()
    }
}
