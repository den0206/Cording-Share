//
//  FBFollow.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/03/05.
//

import FirebaseFirestore

struct FBfriend {
    
    
    static func checkFriend(currentUser : FBUser, withUser : FBUser,completion :@escaping(Bool) -> Void) {
        
        FirebaseReference(.User).document(currentUser.uid).collection(FriendKey.friends).document(withUser.uid).getDocument { (snapshot, error) in
            
            guard let snapshot = snapshot else {return}
            
            snapshot.exists ? completion(true) : completion(false)
        }
        
    }
    
    static func addFriend(currentUser : FBUser, withUser : FBUser,completion :
    @escaping(Error?) -> Void) {
        
        let value = [FriendKey.userID : withUser.uid,
                     FriendKey.date : Timestamp(date: Date())] as [String : Any]
        
        FirebaseReference(.User).document(currentUser.uid).collection(FriendKey.friends).document(withUser.uid).setData(value) { (error) in
            if let error = error {
                completion(error)
                return
            }
            
            completion(nil)
        }
        
    }
    
    static func removeFriend(currentUser : FBUser, withUser : FBUser,completion :
                                @escaping(Error?) -> Void) {
        FirebaseReference(.User).document(currentUser.uid).collection(FriendKey.friends).document(withUser.uid).delete { (error) in
            if let error = error {
                completion(error)
                return
            }
            
            completion(nil)
        }
    }
}
