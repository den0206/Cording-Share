//
//  Recent.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/01/16.
//

import Foundation
import SwiftUI
import Firebase

final class Recent  {
    
    let id : String
    var userId : String
    var withUserId : String
    var chatRoomId : String
    var lastMessage : String
    var counter : Int
    var date : Timestamp
    
    
    init(dic : [String : Any]) {
        
        self.id = dic[RecentKey.recentID] as? String ?? ""
        self.userId = dic[RecentKey.userId] as? String ?? ""
        self.chatRoomId = dic[RecentKey.chatRoomId] as? String ?? ""
        self.withUserId = dic[RecentKey.withUserId] as? String ?? ""
        self.lastMessage = dic[RecentKey.lastMessage] as? String ?? ""
        self.counter = dic[RecentKey.counter] as? Int ?? 0
        self.date = dic[RecentKey.date] as? Timestamp ?? Timestamp(date: Date())
    }
    
}
