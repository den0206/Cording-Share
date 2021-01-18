//
//  UserProfileViewModel.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/01/16.
//

import Combine

final class UserProfileViewModel : ObservableObject {
    
    let user : FBUser!
    
    init(user : FBUser?) {
        self.user = user
    }
    
    
    //MARK: - func
    
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
