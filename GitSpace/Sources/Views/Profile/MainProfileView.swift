//
//  profileDetailView.swift
//  GitSpace
//
//  Created by 정예슬 on 2023/01/17.
//

import SwiftUI

// 사용자의 프로필 뷰
// TODO: - ToolBar Item들 네비게이션으로 다른 뷰 연결

struct MainProfileView: View {
    
    @State private var showGuideCenter: Bool = false

    var body: some View {
        CurrentUserProfileView()
        // FIXME: - 추후 네비게이션 타이틀 지정 (작성자: 제균)
        .navigationTitle("")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing){
                Button {
                    showGuideCenter.toggle()
                } label: {
                    Image(systemName: "info.circle")
                        .foregroundColor(.primary)
                }
                .padding(.trailing, -10)

                NavigationLink {
                    SetMainView()
                } label: {
                    Image(systemName: "gearshape")
                        .foregroundColor(.primary)
                }
            }
        }
        .fullScreenCover(isPresented: $showGuideCenter) {
            GuideCenterView()
        }
    }
}

struct MainProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            MainProfileView()
        }
    }
}
