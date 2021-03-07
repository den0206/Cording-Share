//
//  FriendsViewModel.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/03/06.
//

import SwiftUI
import FirebaseFirestore


final class FriendsViewModel : ObservableObject {
    
    
    @Published var friends = [FBUser]()
    @Published var status : Status = .plane
    
    @Published var friendsListner : ListenerRegistration?
    @Published var showAlert = false
    @Published var alert = Alert(title: Text("")) {
        didSet {
            showAlert = true
        }
    }
    
    @Published var pushNav = false
    @Published var selectedFriend : FBUser? {
        didSet {
            pushNav = true
        }
    }
    
  
    
    var user : FBUser
    
    init(user : FBUser) {
        UINavigationBar.appearance().tintColor = .white
        UITableView.appearance().separatorStyle = .none
        self.user = user
    }
    
    
    func fetchFriends() {
        
        guard user.isCurrentUser else {return}
        
        guard Reachabilty.HasConnection() else {
            status = .noInternet
            return
        }
        
       friendsListner = FirebaseReference(.User).document(user.uid).collection(FriendKey.friends).addSnapshotListener { (snapshot, error) in
            
            if let error = error {
                self.alert = errorAlert(message: error.localizedDescription)
                return
            }
            
            guard let snapshot = snapshot else {
                self.alert = errorAlert(message: FirestoreError.noDocumentSNapshot.localizedDescription)
                return
                
            }
            
            guard !snapshot.isEmpty else {
                self.status = .empty(.Friend)
                return
            }
            
            snapshot.documentChanges.forEach { (diff) in
               
                let data = diff.document.data()
                let uid = data[FriendKey.userID] as? String ?? ""
                switch diff.type {
                
                case .added :
                  
                    
                    FBAuth.fecthFBUser(uid: uid) { (result) in
                        switch result {
                        
                        case .success(let user):
                            self.friends.append(user)
                        case .failure(let error):
                            self.alert = errorAlert(message: error.localizedDescription)
                        }
                        
                        self.status = .plane
                    }
                case .removed :
                    
                    guard let index = self.friends.map({$0.uid}).firstIndex(of: uid) else {
                        print("No Index")
                        return
                    }
                    self.friends.remove(at: index)
                 
                default :
                    print("Default")
                }
            
            }
            
            
        }
    }
    
    func deleteFriend(offsets : IndexSet) {
        
        guard user.isCurrentUser else {return}
        let index = offsets[offsets.startIndex]
        
        let withUser = self.friends[index]
        FBfriend.removeFriend(currentUser: user, withUser: withUser) { (error) in
            
            if let error = error {
                self.alert = errorAlert(message: error.localizedDescription)
            }
            
            self.friends.remove(atOffsets: offsets)
        }
        
    }
    
    
}
