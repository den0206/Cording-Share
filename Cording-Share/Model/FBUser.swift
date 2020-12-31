//
//  FBUser.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2020/12/31.
//

import Foundation

struct FBUser {
   
    let uid : String
    var name : String
    var email : String
    var avaterUrl : URL?
    
    init(uid : String, name : String, email : String) {
        self.uid = uid
        self.name = name
        self.email = email
    }
    
    init?(dic : [String : Any]) {
        
        let uid = dic[Userkey.userID] as? String ?? ""
        let name = dic[Userkey.name] as? String ?? ""
        let email = dic[Userkey.email] as? String ?? ""
        
        self.init(uid: uid, name: name, email: email)
        
        if let urlString = dic[Userkey.avatarUrl] as? String  {
            
            self.avaterUrl = URL(string: urlString)
        }
        
       
    }
}

