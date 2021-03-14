//
//  UserProfileViewModel.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/01/16.
//

import SwiftUI

final class UserProfileViewModel : ObservableObject {
    
    @Published var user : FBUser!
    @Published var buttonEnable = false
    @Published var didAppear = false
    
    init(user : FBUser?) {
        self.user = user
        
    }
    
    //MARK: - Friend
    
    func checkFriend(userInfo : UserInfo) {
       
        guard !user.isCurrentUser else {return}
        guard let withUser = user else {return}
        
        print("Check ")
        let currentUser = userInfo.user
        
        FBfriend.checkFriend(currentUser: currentUser, withUser: withUser) { (isFriend) in
          
            self.user?.isFriend = isFriend
            
            withAnimation(.easeInOut(duration: 0.7)) {
                self.buttonEnable = true
            }
           
        }
    }
    
    func addfriend(userInfo : UserInfo) {
        guard !user.isCurrentUser else {return}
        guard let withUser = user else {return}
        let currentUser = userInfo.user
        
        switch withUser.isFriend {
        case false :
            FBfriend.addFriend(currentUser: currentUser, withUser: withUser) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
        
                self.user.isFriend = true
                
            }
        case true :
            FBfriend.removeFriend(currentUser: currentUser, withUser: withUser) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
     
                self.user.isFriend = false
            }
       
        }
        
        
    }
    
    
    //MARK: - Message
    
    func startPrivateChat(userInfo : UserInfo) {
        guard !user.isCurrentUser else {return}
        
        let currentUID = userInfo.user.uid
        let user2Id = user.uid
        
        Recent.createPrivateChat(currentUID: currentUID, user2ID: user2Id,users: [userInfo.user, user]) { (chatRoomId) in
            userInfo.chatRoomId = chatRoomId
            userInfo.withUser = self.user
            userInfo.tabIndex = 2
            userInfo.MSGPushNav = true

        }
        
    }
}
