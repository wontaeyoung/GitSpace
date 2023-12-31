//
//  TempMainKnockView.swift
//  GitSpace
//
//  Created by Celan on 2023/03/04.
//

import SwiftUI

struct MainKnockView: View {
    @StateObject private var keyboardHandler = KeyboardHandler()
    @EnvironmentObject var tabBarRouter: GSTabBarRouter
    @EnvironmentObject var knockViewManager: KnockViewManager
    @EnvironmentObject var userInfoManager: UserStore
    
    // !!!: TAB Branch
    @State private var userSelectedTab: String = Constant.KNOCK_RECEIVED
    @State private var receivedKnockTab: String = Constant.KNOCK_RECEIVED
    @State private var sentKnockTab: String = Constant.KNOCK_SENT
    
    // !!!: FILTER Branch
    @State private var userFilteredKnockState: KnockStateFilter = .all
    
    // !!!: SEARCH Branch
    @State private var searchText: String = ""
    @State private var isSearching: Bool = false
    
    @State private var isEditing: Bool = false
    @State private var isDisplayedKnockSettingView: Bool = false
    
    var body: some View {
        VStack {
            // MARK: - Tab Buttons
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("User Name", text: $searchText)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
            }
            .padding(8)
            .background(
                Color(.systemGray4)
                    .cornerRadius(16)
            )
            .padding(.horizontal, 20)
            .opacity(isSearching ? 1 : 0)
            .frame(height: isSearching ? 40 : 0)
            
            headerTabPagenationViewBuilder()
                .overlay(alignment: .bottom) {
                    Divider()
                        .frame(minHeight: 0.5)
                        .overlay(Color.primary)
                        .offset(y: 3.5)
                }
                .padding(.top, 10)
                .padding(.horizontal, 20)
            
            ScrollView {
                LazyVStack(pinnedViews: .sectionHeaders) {
                    if !isSearching {
                        subHeaderGuideMessageBuilder()
                    }
                    
                    if userSelectedTab == Constant.KNOCK_RECEIVED {
                        Section {
                            if knockViewManager.receivedKnockList.isEmpty {
                                VStack {
                                    Image("GitSpace-Knock-Empty")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 225, height: 225)
                                        .transition(knockViewManager.trailingTransition)
                                    
                                    GSText.CustomTextView(
                                        style: .description,
                                        string: "There are no Knocks!")
                                    .multilineTextAlignment(.center)
                                }
                            } else {
                                ForEach(
                                    $knockViewManager.receivedKnockList
                                        .sorted {
                                            knockViewManager.sortedByDateValue(
                                                lhs: $0.wrappedValue,
                                                rhs: $1.wrappedValue
                                            )
                                        }
                                        .filter {
                                            knockViewManager.filterKnockList(
                                                isReceivedKnockList: true,
                                                isSearching: isSearching,
                                                searchText: searchText,
                                                userFilteredKnockState: userFilteredKnockState,
                                                eachKnock: $0.wrappedValue
                                            )
                                        },
                                    id: \.wrappedValue.id
                                ) { $eachKnock in
                                    NavigationLink {
                                        if eachKnock.knockStatus == Constant.KNOCK_WAITING {
                                            ReceivedKnockDetailView(
                                                knock: $eachKnock
                                            )
                                        } else {
                                            KnockHistoryView(
                                                eachKnock: $eachKnock,
                                                userSelectedTab: $userSelectedTab
                                            )
                                        }
                                    } label: {
                                        // Label
                                        EachKnockCell(
                                            eachKnock: $eachKnock,
                                            isEditing: $isEditing,
                                            userSelectedTab: userSelectedTab
                                        )
                                        .foregroundColor(.primary)
                                    }
                                    .transition(knockViewManager.leadingTransition)
                                    .id($eachKnock.wrappedValue.id)
                                }
                            }
                        } header: {
                            let num = knockViewManager.getFilteredKnockCountInKnockList(
                                isReceivedKnockList: true,
                                isSearching: isSearching,
                                searchText: searchText,
                                userFilteredKnockState: userFilteredKnockState
                            )
                            
                            if num != 0 {
                                HStack {
                                    Text(userFilteredKnockState.rawValue)
                                        .bold()
                                        .font(.headline)
                                    
                                    Spacer()
                                    
                                    Text(num.description)
                                    .bold()
                                }
                                .modifier(PinnedViewHeaderModifier())
                            }
                        }
                    } else if userSelectedTab == Constant.KNOCK_SENT {
                        Section {
                            if knockViewManager.sentKnockList.isEmpty {
                                VStack {
                                    Image("GitSpace-Knock-Empty")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 225, height: 225)
                                        .transition(knockViewManager.trailingTransition)
                                    
                                    GSText.CustomTextView(
                                        style: .description,
                                        string: "There are no Knocks!")
                                    .multilineTextAlignment(.center)
                                }
                            } else {
                                ForEach($knockViewManager.sentKnockList
                                    .sorted {
                                        knockViewManager.sortedByDateValue(lhs: $0.wrappedValue, rhs: $1.wrappedValue)
                                    }
                                    .filter {
                                        knockViewManager.filterKnockList(
                                            isReceivedKnockList: false,
                                            isSearching: isSearching,
                                            searchText: searchText,
                                            userFilteredKnockState: userFilteredKnockState,
                                            eachKnock: $0.wrappedValue
                                        )
                                    }, id: \.wrappedValue.id
                                ) { $eachKnock in
                                    NavigationLink {
                                        KnockHistoryView(
                                            eachKnock: $eachKnock,
                                            userSelectedTab: $userSelectedTab
                                        )
                                    } label: {
                                        EachKnockCell(
                                            eachKnock: $eachKnock,
                                            isEditing: $isEditing,
                                            userSelectedTab: userSelectedTab
                                        )
                                        .foregroundColor(.primary)
                                        .id($eachKnock.wrappedValue.id)
                                    }
//                                    .id($eachKnock.wrappedValue.id)
                                    .transition(knockViewManager.trailingTransition)
                                }
                            }
                        } header: {
                            let num = knockViewManager.getFilteredKnockCountInKnockList(
                                isReceivedKnockList: false,
                                isSearching: isSearching,
                                searchText: searchText,
                                userFilteredKnockState: userFilteredKnockState
                            )
                            
                            HStack {
                                Text(userFilteredKnockState.rawValue)
                                    .bold()
                                    .font(.headline)
                                
                                Spacer()
                                
                                Text(num.description)
                                .bold()
                            }
                            .modifier(PinnedViewHeaderModifier())
                        }
                    }
                }
            }
        }
        .task {
            if !knockViewManager.checkIfListenerExists() {
                await knockViewManager.addSnapshotToKnock(
                    currentUser: userInfoManager.currentUser ?? .getFaliedUserInfo()
                )
            }
        }
        .onTapGesture {
            self.endTextEditing()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("\(userSelectedTab) Knock")
        .fullScreenCover(isPresented: $isDisplayedKnockSettingView) {
            NavigationView {
                SetKnockControlsView(
                    showingKnockControls: $isDisplayedKnockSettingView
                )
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            isDisplayedKnockSettingView.toggle()
                        } label: {
                            Text("Done")
                        } // Button
                    } // ToolbarItem
                } // toolbar
            } // NavigationView
        } // fullScreenCover
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    withAnimation(.linear(duration: 0.3)) {
                        isSearching.toggle()
                    }
                } label: {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.primary)
                }
            }
            
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Button(isEditing ? "Cancel" : "Edit") {
//                    withAnimation {
//                        isEditing.toggle()
//                    }
//                }
//            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                if isSearching {
                    Button {
                        withAnimation {
                            isSearching.toggle()
                        }
                    } label: {
                        Text("Cancel")
                    }
                }
            }
        }
    }
    
    // MARK: - METHODS
    @ViewBuilder
    private func headerTabPagenationViewBuilder() -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            GSButton.CustomButtonView(style: .homeTab(
                tabName: receivedKnockTab,
                tabSelection: $userSelectedTab)) {
                    withAnimation {
                        userSelectedTab = receivedKnockTab
                    }
                } label: {
                    Text(receivedKnockTab)
                        .font(.title3)
                        .foregroundColor(.primary)
                        .bold()
                        .padding(.bottom, 4)
                }
            
            Divider()
                .frame(height: 12)
                .overlay {
                    Color.gsDarkGray
                }
                .padding(.horizontal, 4)
            
            GSButton.CustomButtonView(style: .homeTab(
                tabName: sentKnockTab,
                tabSelection: $userSelectedTab)) {
                    withAnimation {
                        userSelectedTab = sentKnockTab
                    }
                } label: {
                    Text(sentKnockTab)
                        .font(.title3)
                        .foregroundColor(.primary)
                        .bold()
                        .padding(.bottom, 4)
                }
            
            Spacer()
            
            Text("\(userFilteredKnockState.rawValue)")
                .bold()
                .font(.footnote)
                .foregroundColor(.gsGray2)
            
            Menu {
                Button {
                    withAnimation {
                        userFilteredKnockState = .all
                    }
                } label: {
                    Text("\(Constant.KNOCK_ALL)")
                }
                
                Button {
                    withAnimation {
                        userFilteredKnockState = .waiting
                    }
                } label: {
                    Text("\(Constant.KNOCK_WAITING)")
                }
                
                Button {
                    withAnimation {
                        userFilteredKnockState = .accepted
                    }
                } label: {
                    Text("\(Constant.KNOCK_ACCEPTED)")
                }
                
                Button {
                    withAnimation {
                        userFilteredKnockState = .declined
                    }
                } label: {
                    Text("\(Constant.KNOCK_DECLINED)")
                }
            } label: {
                Image(systemName: "line.3.horizontal.decrease")
                    .foregroundColor(.primary)
            }
        }
    }
    
    @ViewBuilder
    private func subHeaderGuideMessageBuilder() -> some View {
        switch userSelectedTab {
        case receivedKnockTab:
            VStack {
                // 노크를 한 사람에 대한 정보를 보려면 노크 메세지를 확인하세요.
                Text("Check the message for information about who's Knocking on you.")
                    .foregroundColor(Color(.systemGray))
                
                // 상대방은 응답할 때까지 회원님의 노크 확인 여부를 알 수 없습니다.
                Text("They won't know you've seen it until you respond.")
                    .foregroundColor(Color(.systemGray))
                
                // !!!: - Knock Sensitive Push Notification Setting
                // 다음 버전에 구현
//                Button {
//                    isDisplayedKnockSettingView.toggle()
//                } label: {
//                    // 나에게 노크 할 수 있는 사람 설정하기
//                    Text("Decide who can Knock on You.")
//                }
            }
            .font(.caption2)
            .padding(.top, 8)
        case sentKnockTab:
            VStack {
                // 노크를 한 사람에 대한 정보를 보려면 노크 메세지를 확인하세요.
                Text("You can check your knock history.")
                
                // 상대방은 응답할 때까지 회원님의 노크 확인 여부를 알 수 없습니다.
                Text("You can't send other messages until your receiver")
                
                Text("has approved your knock")
            }
            .foregroundColor(Color(.systemGray))
            .font(.caption2)
            .padding(.top, 8)
        default:
            EmptyView()
        }
    }
}

enum KnockStateFilter: String {
    case waiting = "Waiting"
    case accepted = "Accepted"
    case declined = "Declined"
    case all = "All"
}
