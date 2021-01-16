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
        
        print(userInfo.user.uid, user.uid)
    }
}
