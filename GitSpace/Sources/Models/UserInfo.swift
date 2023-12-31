//
//  UserInfo.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/27.
//

import Foundation

struct UserInfo : Identifiable, Codable, Equatable {
    // MARK: -Firestore Properties
    let id: String                  // 유저 ID (Firebase Auth UID)
    let createdDate: Date           // 유저 생성일시
    var deviceToken: String         // 유저 기기 토큰
    var blockedUserIDs: [String]    // 차단한 유저 ID 리스트
    var blockedByUserIDs: [String]  // 유저를 차단한 상대 유저 ID 리스트
    var isKnockPushAvailable: Bool? // Knock 푸시알람 승인여부
    var isChatPushAvailable: Bool?  // chat 푸시알람 승인여부
    
    // MARK: -Github Properties
    let githubID: Int               // 유저 깃허브 ID값, 받을 때 정수형으로 와서 타입 통일
    let githubLogin: String         // 유저 깃허브 login (Repository 경로에 쓰는 이름)
    let githubName: String?         // 유저 깃허브 이름
    let githubEmail: String?        // 유저 이메일
    let avatar_url: String          // profile image
    let bio: String?                // bio, intro message
    let company: String?            // company
    let location: String?           // location
    let blog: String?               // blog url
    let public_repos: Int           // public repos
    let followers: Int              // followers
    let following: Int              // following
    
    // MARK: Date를 문자열로 반환하는 연산 프로퍼티
    var createdDateAsString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: createdDate)
    }
	
	static func getFaliedUserInfo() -> Self {
		let userinfo = UserInfo(id: "FAILED",
                                createdDate: .now,
                                deviceToken: "FAILED",
                                blockedUserIDs: ["FAILED"],
                                blockedByUserIDs: ["FAILED"],
                                githubID: 0,
                                githubLogin: "FAILED",
                                githubName: "FAILED",
                                githubEmail: "FAILED",
                                avatar_url: "ProfilePlaceholder",
                                bio: "FAILED",
                                company: "FAILED",
                                location: "FAILED",
                                blog: "FAILED",
                                public_repos: 0,
                                followers: 0,
                                following: 0)
		return userinfo
	}
}
