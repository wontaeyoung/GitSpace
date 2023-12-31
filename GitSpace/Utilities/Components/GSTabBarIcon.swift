//
//  GSTabBarIcon.swift
//  GitSpace
//
//  Created by 박제균 on 2023/02/03.
//

import SwiftUI

/**
 현재 GSTabBarRouter가 어떤 탭을 선택하고 있는지 알아야 하기 때문에 GSTabBarRouter를 주입받는다.
 탭바의 각 아이템은 자신이 나타내고 있는 Page 값도 가지고 있어야 한다.
 - Author: 제균
 */
struct GSTabBarIcon: View {

    @Environment(\.colorScheme) var colorScheme
    @StateObject var tabBarRouter: GSTabBarRouter

    let page: GSTabBarRouter.Page
    let geometry: GeometryProxy
    let isSystemImage: Bool
    let imageName: String
    let tabName: String

    private var width: CGFloat {
        geometry.size.width / 4
    }

    /**
     탭바 아이콘의 높이
     */
    private var height: CGFloat {
        geometry.size.height / 56
    }

    var body: some View {

        GeometryReader { geometry in

            if tabBarRouter.currentPage ?? GSTabBarRouter.Page.stars == page {
                Rectangle()
                    .foregroundColor(colorScheme == .light ? .gsGreenPrimary : .gsYellowPrimary)
                    .frame(width: width / 2, height: 4)
                    .cornerRadius(5, corners: [.bottomLeft, .bottomRight])
                    .padding(.leading, geometry.size.width / 4.5)
            }

            VStack(alignment: .center, spacing: 4) {

                isSystemImage ? Image(systemName: imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: width, height: height)
                : Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: width, height: height)

                GSText.CustomTextView(style: .caption2, string: tabName)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .foregroundColor(colorScheme == .light ? .gsGreenPrimary : .gsYellowPrimary)
            .onTapGesture {
                tabBarRouter.currentPage = page
                UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
            }
        }

    }


}

struct GSTabBarIcon_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            GSTabBarIcon(tabBarRouter: GSTabBarRouter(), page: .profile, geometry: geometry, isSystemImage: true, imageName: "person.fill", tabName: "되나요오")
        }
    }
}
