//
//  SearchUserViewModel.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/03/02.
//

import SwiftUI

final class SearchUserViewModel : ObservableObject {
    
    @Published var seachText : String = ""
    @Published var searchedUser : FBUser?
   
    @Published var buttonEnable : Bool = false
    @Published var showAlert = false
    @Published var alert = Alert(title: Text("")) {
        didSet {
            showAlert = true
        }
    }

    func searchUser(userInfo : UserInfo) {
        
        guard seachText != "" else {return}
        buttonEnable = false
        
        FBAuth.searchUserFromName(name: seachText) { (result) in
            
            self.searchedUser = nil
            
            switch result {
            
            case .success(let user):
                self.searchedUser = user
                self.checkFriend(userInfo: userInfo)
            case .failure(let error):
                print(error.localizedDescription)
                self.alert = errorAlert(message: error.localizedDescription)
                return
            }
            
            self.seachText = ""
            hideKeyBord()
        }
        
        
    }
    
    private func checkFriend(userInfo : UserInfo) {
        guard let searchedUser = searchedUser else {return}
        guard !searchedUser.isCurrentUser else {return}
        
        let currentUser = userInfo.user
        let withUser = searchedUser
        
        FBfriend.checkFriend(currentUser: currentUser, withUser: withUser) { (isFriend) in
          
            self.searchedUser?.isFriend = isFriend
            
            withAnimation(.easeInOut(duration: 1.0)) {
                self.buttonEnable = true
            }
           
        }
    }
    
    func startPrivateChat(userInfo : UserInfo,completion : @escaping() -> Void) {
        
        guard let searchedUser = searchedUser else {return}
        guard !searchedUser.isCurrentUser else {return}
        
        let currentUID = userInfo.user.uid
        let user2Id = searchedUser.uid
        
        Recent.createPrivateChat(currentUID: currentUID, user2ID: user2Id,users: [userInfo.user, searchedUser]) { (chatRoomId) in
            
            completion()
            
            userInfo.chatRoomId = chatRoomId
            userInfo.withUser = searchedUser
            userInfo.tabIndex = 2
            userInfo.MSGPushNav = true
      

        }
        
    }
    
    func addFriend(userInfo : UserInfo) {
        
        guard let searchedUser = searchedUser else {return}
        guard !searchedUser.isCurrentUser else {return}
        
        let currentUser = userInfo.user
        let withUser = searchedUser
        
        switch searchedUser.isFriend {
        case false:
            FBfriend.addFriend(currentUser: currentUser, withUser: withUser) { (error) in
                if let error = error {
                    self.alert = errorAlert(message: error.localizedDescription)
                    return
                }
                
                self.searchedUser?.isFriend = true
            }
            
        case true :
            
            FBfriend.removeFriend(currentUser: currentUser, withUser: withUser) { (error) in
                if let error = error {
                    self.alert = errorAlert(message: error.localizedDescription)
                    return
                }
                
                
                self.searchedUser?.isFriend = false
            }
            
        }
        
       
        
    }
    
    
    
}
