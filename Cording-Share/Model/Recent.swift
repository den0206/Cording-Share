//
//  Recent.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/01/16.
//

import Foundation
import SwiftUI
import Firebase

struct Recent : Identifiable {
    
    var id : String
    var userId : String
    var withUserId : String
    var chatRoomId : String
    var lastMessage : String
    var counter : Int
    var date : Timestamp
    
    var withUser : FBUser!
    
    var tmstring : String {
        return timeElapsed(date: date.dateValue())
    }
    
    
    init(dic : [String : Any]) {
        
        self.id = dic[RecentKey.recentID] as? String ?? ""
        self.userId = dic[RecentKey.userId] as? String ?? ""
        self.chatRoomId = dic[RecentKey.chatRoomId] as? String ?? ""
        self.withUserId = dic[RecentKey.withUserId] as? String ?? ""
        self.lastMessage = dic[RecentKey.lastMessage] as? String ?? ""
        self.counter = dic[RecentKey.counter] as? Int ?? 0
        self.date = dic[RecentKey.date] as? Timestamp ?? Timestamp(date: Date())
    }
    
    
    static func createPrivateChat(currentUID : String, user2ID : String, users : [FBUser],completion : @escaping(String) -> Void) {
        
        var chatRoomId : String
        let value = currentUID.compare(user2ID).rawValue
        
        if value < 0 {
            chatRoomId = currentUID + user2ID
        } else {
            chatRoomId = user2ID + currentUID
        }
        
        let userIDs = [currentUID, user2ID]
        var tempMembers = userIDs
        
        FirebaseReference(.Recent).whereField(RecentKey.chatRoomId, isEqualTo: chatRoomId).getDocuments { (snapshot, error) in
        
            guard let snapshot = snapshot else {return}
            if !snapshot.isEmpty {
                for recent in snapshot.documents {
                    let currentRecent = recent.data()
                    
                    print(currentRecent)
                    if let currentUserId = currentRecent[RecentKey.userId] {
                       if userIDs.contains(currentUserId as! String) {
                        tempMembers.remove(at: tempMembers.firstIndex(of: currentUserId as! String)!)
                        }
                    }
                }
            }
            
            for userId in tempMembers {
                Recent.createRecentTofireStore(userId: userId, currentUID: currentUID, chatRoomId: chatRoomId, users: users)
            }
            
            completion(chatRoomId)
        }
    }
    
    static func createRecentTofireStore(userId : String, currentUID : String,chatRoomId : String, users : [FBUser]) {
        let ref = FirebaseReference(.Recent).document()
        let recentID = ref.documentID
        
        var withUser : FBUser
        
        if userId == currentUID {
            withUser = users.last!
        } else {
            withUser = users.first!
        }
        
        let recent = [RecentKey.recentID : recentID,
                      RecentKey.userId : userId,
                      RecentKey.chatRoomId : chatRoomId,
                      RecentKey.withUserId : withUser.uid,
                      RecentKey.lastMessage : "",
                      RecentKey.counter : 0,
                      RecentKey.date : Timestamp(date: Date())] as [String : Any]
        
        print(recent)
        ref.setData(recent)
    
    }
    
}

