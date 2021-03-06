//
//  FriendsViewModel.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/03/06.
//

import SwiftUI

final class FriendsViewModel : ObservableObject {
    
    
    @Published var friends = [FBUser]()
    @Published var showAlert = false
    @Published var alert = Alert(title: Text("")) {
        didSet {
            showAlert = true
        }
    }
    
    var user : FBUser
    
    init(user : FBUser) {
        UINavigationBar.appearance().tintColor = .white
        self.user = user
    }
    
   
    func fetchFriends() {
        
        guard user.isCurrentUser else {return}
        
        
        FirebaseReference(.User).document(user.uid).collection(FriendKey.friends).getDocuments { (snapshot, error) in
            
            if let error = error {
                self.alert = errorAlert(message: error.localizedDescription)
                return
            }
            
            guard let snapshot = snapshot else {
                self.alert = errorAlert(message: FirestoreError.noDocumentSNapshot.localizedDescription)
                return
                
            }
            
            guard !snapshot.isEmpty else {
                self.alert = errorAlert(message: FirestoreError.noFriends.localizedDescription)
                return
            }
            
            self.friends = snapshot.documents.map({FBUser(dic: $0.data())!})
            print(self.friends.count)
        }
    }
    
    
}
