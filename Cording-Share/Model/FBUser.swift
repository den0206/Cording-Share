//
//  FBUser.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2020/12/31.
//

import Foundation
import FirebaseAuth

struct FBUser : Equatable{
   
    let uid : String
    var name : String
    var email : String
    var fcmToken : String
    let searchId : String
    var avaterUrl : URL?
    
    var isFriend : Bool = false
   
    var isCurrentUser : Bool {
        return Auth.auth().currentUser?.uid == uid
    }

    static func currentUID() -> String? {
        return Auth.auth().currentUser?.uid
    }
 
    
    init(uid : String, name : String, email : String,fcmToken : String,searchId : String) {
        self.uid = uid
        self.name = name
        self.email = email
        self.fcmToken = fcmToken
        self.searchId = searchId
    }
    
    init?(dic : [String : Any]) {
        
        let uid = dic[Userkey.userID] as? String ?? ""
        let name = dic[Userkey.name] as? String ?? ""
        let email = dic[Userkey.email] as? String ?? ""
        let fcmToken = dic[Userkey.fcmToken] as? String ?? ""
        let searchId = dic[Userkey.searchID] as? String ?? ""
        
        self.init(uid: uid, name: name, email: email,fcmToken : fcmToken,searchId : searchId)
        
        if let urlString = dic[Userkey.avatarUrl] as? String  {
            
            self.avaterUrl = URL(string: urlString)
        }
        
       
    }
}

