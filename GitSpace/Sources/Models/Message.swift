//
//  ChatCellModel.swift
//  GitSpace
//
//  Created by 원태영 on 2023/01/27.
//

import Foundation

// 채팅 메세지 모델
struct Message : Identifiable {
    let id : String
    let userID : String
    let content : String
    let date: Date
    
    var stringDate : String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter.string(from: date)
    }
}
