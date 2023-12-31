//
//  GSPushNotificationRouter.swift
//  GitSpace
//
//  Created by 이승준 on 2023/02/11.
//

import SwiftUI

// MARK: - ObservableObeject, GSPushNotificationNavigatable 구현부
final class PushNotificationManager: GSPushNotificationNavigatable, ObservableObject {
    @Published var isNavigatedToChat: Bool = false
    @Published var isNavigatedToSentKnock: Bool = false
    @Published var isNavigatedToReceivedKnock: Bool = false
    @Published var currentChatRoomID: String? = nil
    
    private(set) var currentUserDeviceToken: String?
    private(set) var viewBuildID: String? = nil

    // MARK: - Methods
    /// private(set) 속성에 접근하여 DeviceToken을 할당합니다.
    public func setCurrentUserDeviceToken(token: String) {
        currentUserDeviceToken = token
    }
    
    /// private(set) 속성에 접근하여 view를 그릴 때 필요한 데이터 ID를 할당합니다.
    public func assignViewBuildID(_ id: String) {
        self.viewBuildID = id
    }
    
    // MARK: LIFECYCLE
    init(
        currentUserDeviceToken: String?
    ) {
        self.currentUserDeviceToken = currentUserDeviceToken
    }
}

// MARK: - GSPushNotificationSendable 프로토콜 구현부
extension PushNotificationManager: GSPushNotificationSendable {
	var url: URL? {
		URL(string: "https://\(Constant.PushNotification.PUSH_NOTIFICATION_ENDPOINT)")
	}
	
    /**
     노티피케이션을 발송하는 메소드 입니다.
     전해야 하는 메세지를 밖에서 전달하여 발송합니다.
     - Parameters:
        - with message: PushNotificationMessageType 으로 필요한 정보들을 전달하며, subtitle은 경우에 따라 생략할 수 있습니다.
            - subtitle: 알람의 "발신자" 위치
        - to userInfo: UserInfo
     */
	public func sendNotification(
		with message: PushNotificationMessageType,
		to userInfo: UserInfo
	) async -> Void {
		guard let url else { return }
		let messageBody = PushNotificationMessageBody(message)
		let httpBody = makeNotificationData(
            pushNotificationBody: messageBody,
            to: userInfo
        )
        
		let httpRequest = configureHTTPRequest(url: url)
		
		do {
			guard let httpBody else { return }
			
			/// 비동기 함수로 정의된 URLSession upload(for:from:) 메소드를 호출합니다.
			/// uploadPayload는 (Data, Response) 를 갖고 있는 튜플 타입 입니다.
			let _ = try await URLSession.shared.upload(
				for: httpRequest,
				from: httpBody
			)
		} catch {
			/// POST가 실패했을 경우 에러를 확인할 수 있도록 dump를 호출합니다.
			dump("DEBUG: PUSH POST FAILED - \(error)")
		}
	}
	
	internal func makeNotificationData(
		pushNotificationBody: PushNotificationMessageBody,
		to userInfo: UserInfo
	) -> Data? {
        if let knockPushAcceptance = userInfo.isKnockPushAvailable,
           pushNotificationBody.navigateTo == "knock",
           !knockPushAcceptance {
            return nil
        } else if let chatPushAcceptance = userInfo.isChatPushAvailable,
                  pushNotificationBody.navigateTo == "chat",
                  !chatPushAcceptance {
            return nil
        }
        
		/// HTTP Request의 body로 전달할 data를 딕셔너리로 선언한 후, JSON으로 변환합니다.
		let json: [AnyHashable: Any] = [
			/// 특정 기기에 알람을 보내기 위해 "to"를 사용합니다.
			/// 경우에 따라 Topic 등 다른 용도로 활용할 수 있습니다.
			"to": userInfo.deviceToken,
			
			/// 알람의 내용을 구성하는 키-밸류 입니다.
			"notification": [
				"title": pushNotificationBody.messageTitle,
				"body": pushNotificationBody.messageBody,
                "subtitle": pushNotificationBody.sentUserName != nil ? pushNotificationBody.sentUserName : "",
				"badge": "1"
			],
			
			/// 알람을 보내며 함께 전달할 데이터를 삽입합니다.
			"data": [
				"sentDeviceToken": currentUserDeviceToken ?? "보낸 이의 디바이스토큰",
				"sentUserName": userInfo.githubLogin,
				"sentUserID": userInfo.id,
				"navigateTo": pushNotificationBody.navigateTo,
				"viewBuildID": pushNotificationBody.viewBuildID,
				"date": Date.now.description
			]
		]
		let httpBody = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
		
		return httpBody
	}
	
	internal func configureHTTPRequest(url: URL) -> URLRequest {
		var request = URLRequest(url: url)
		request.httpMethod = HTTPRequestMethod.post.rawValue
		request.setValue(
			"application/json",
			forHTTPHeaderField: "Content-Type"
		)
		
		/// serverKey 는 3번 과정에서 저장해둔 키를 사용합니다.
		request.setValue(
			"key=\(Constant.PushNotification.SERVER_KEY)",
			forHTTPHeaderField: "Authorization"
		)
		
		return request
	}
}


/// TEST할 때 사용하는 뷰
struct PushNotificationTestView: View {
	
	var body: some View {
		VStack {
			Button {
				Task {
					let instance = PushNotificationManager(currentUserDeviceToken: "H")
					let valseDevice = Bundle.main.object(forInfoDictionaryKey: "VALSE_DEVICE_TOKEN") as? String ?? ""
					
//					await instance.sendPushNotification(
//						with: .knock(title: "knockMessage", body: "Knock 내용", fromUser: "", knockID: ""),
//						to: UserInfo(id: UUID().uuidString, createdDate: .now, githubUserName: "Valselee", githubID: 000, deviceToken: valseDevice, emailTo: "", blockedUserIDs: [""])
//					)
					
//					await instance.sendNotification(
//						with: .knock(title: "", body: "", nameOfKnockedPerson: "", knockID: ""),
//						to: UserInfo(id: UUID().uuidString, createdDate: .now, githubUserName: "Valselee", githubID: 000, deviceToken: valseDevice, emailTo: "", blockedUserIDs: [""])
//						)
					
//					await instance.sendPushNotification(
//						with: .chat(title: "chatMessage", body: "chat 내용", chatID: "6FBB214E-C5EE-46F6-9670-4DCA5B73AF17"),
//						to: UserInfo(id: UUID().uuidString, createdDate: .now, githubLogin: "Valselee",
//									 githubID: 000,
//									 deviceToken: valseDevice, githubEmail: "", blockedUserIDs: [""])
//					)
				}
			} label: {
				Text("Send")
			}
			
		}
	}
}
