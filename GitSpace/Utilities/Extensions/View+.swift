//
//  View+.swift
//  GitSpace
//
//  Created by 이승준 on 2023/01/24.
//

import SwiftUI

extension View {
    
    /**
     탭바의 배경화면 생성을 위한 modifier
     */
    func tabBarBackGroundModifier(style: GSTabBarBackGround.GSTabBarBackGroundStyle) -> some View {
        modifier(TabBarBackgroundModifier(backgroundStyle: style))
    }
    
    // MARK: - 키보드 내리기 위한 extension
    func endTextEditing() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil, from: nil, for: nil
        )
    }
    
    
    // MARK: - 팔로워, 레포 숫자를 처리를 위한 extension
    /// Int 타입으로 된 숫자 데이터를 받아와 소수점 처리 후 단위를 붙여 String 타입으로 반환
    /// 예: 3300 -> "3.3k"
    func handleCountUnit(countInfo: Int) -> String {
        var handledCount: String
        let convertedIntCount: Double = Double(countInfo)
        
        if convertedIntCount > 999 {
            handledCount = "\((convertedIntCount / 1000).rounded())k"
        } else {
            handledCount = String(countInfo)
        }
        
        return handledCount
    }
    
    // MARK: - SwiftUI에서 ViewDidLoad를 구현하기 위한 Extension
    /// 뷰가 메모리에 로드될 경우 수행되게 하는 ViewDidLoad 함수.
    /// UIKit에는 viewDidLoad 함수가 있지만 SwiftUI에는 존재하지 않는다.
    /// 그러므로 onAppear을 사용하여 직접 viewDidLoad를 수정자로 구현한다.
    func onViewDidLoad(perform action: (() -> Void)? = nil) -> some View {
        self.modifier(ViewDidLoadModifier(action: action))
    }
    
    // MARK: - Half Sheet을 사용하기 위한 Extension
    /// Half Sheet를 사용할 수 있는 View의 Extension이다.
    /// iOS 15의 SwiftUI에서는 Sheet의 크기를 조절하는 API가 없다.
    /// 그러므로 HalfSheetManager를 background에 사용하여 half modal을 구현한다.
    func halfSheet<Content: View>(
        isPresented: Binding<Bool>,
        onDismiss: (() -> ())? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        return self
            .background {
                 HalfSheetManager(
                    isPresented: isPresented,
                    onDismiss: onDismiss,
                    content: content()
                 )
            }
    }
    
    func reportBlockProcessSheet(
        reportViewIsPresented: Binding<Bool>,
        reportType: Report.ReportType,
        suggestViewIsPresented: Binding<Bool>,
        blockViewIsPresented: Binding<Bool>,
        isBlockedUser: Binding<Bool>,
        targetUserInfo: UserInfo
    ) -> some View {
        self
            .sheet(isPresented: reportViewIsPresented) {
                ReportView(
                    isReportViewShowing: reportViewIsPresented,
                    isSuggestBlockViewShowing: suggestViewIsPresented,
                    reportType: reportType,
                    targetUser: targetUserInfo
                )
            }
            .sheet(isPresented: suggestViewIsPresented) {
                SuggestBlockView(
                    isBlockViewShowing: blockViewIsPresented,
                    isSuggestBlockViewShowing: suggestViewIsPresented
                )
            }
            .sheet(isPresented: blockViewIsPresented) {
                BlockView(
                    isBlockViewShowing: blockViewIsPresented,
                    isBlockedUser: isBlockedUser,
                    targetUser: targetUserInfo)
            }
    }
}
