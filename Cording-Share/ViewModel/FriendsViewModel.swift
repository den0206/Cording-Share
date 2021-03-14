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
    @Published var lastDoc : DocumentSnapshot?
    
    @Published var reachLast = false
    private let limit = 5
    
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
        
        guard user.isCurrentUser && !reachLast else {return}
        
        var ref : Query!
        
        if lastDoc == nil {
            ref = FirebaseReference(.User).document(user.uid).collection(FriendKey.friends).limit(to: limit)
            
        } else {
            ref = FirebaseReference(.User).document(user.uid).collection(FriendKey.friends).start(afterDocument: lastDoc!).limit(to: limit)
        }
        
        
        ref.getDocuments { (snapshot, error) in
            if let error = error {
                self.status = .error(error.localizedDescription)
                return
            }
            
            guard let snapshot = snapshot else {
                self.status = .error(FirestoreError.noDocumentSNapshot.localizedDescription)
                return
                
            }
            
            guard !snapshot.isEmpty else {
                
                if self.lastDoc == nil {
                    self.status = .empty(.Friend)
                }
                
                self.reachLast = true
                return
            }
            
            let uids = snapshot.documents.map({$0.data()[FriendKey.userID] as? String ?? ""})
            
            self.lastDoc = snapshot.documents.last
            
            FBAuth.convertFriends(uids: uids) { (result) in
                switch result {
                
                case .success(let users):
                    
                    if users.count < self.limit  {
                        print("Reach last")
                        self.reachLast = true
                    }
                    
                    self.friends.append(contentsOf: users)
                    self.status = .plane
                case .failure(let error):
                    self.status = .error(error.localizedDescription)
                }
            }
        }
    }
    
    func friendslistner() {
        
        
        
        friendsListner = FirebaseReference(.User).document(user.uid).collection(FriendKey.friends).whereField(FriendKey.date, isGreaterThan: Timestamp(date: Date())).addSnapshotListener({ (snapshot, error) in
            
            if let error = error {
                self.status = .error(error.localizedDescription)
                return
            }
            
            guard let snapshot = snapshot else {return}
            guard !snapshot.isEmpty else { return }
            
            snapshot.documentChanges.forEach { (diff) in
                
                let data = diff.document.data()
                let uid = data[FriendKey.userID] as? String ?? ""
                switch diff.type {
                
                case .added :
                    
                    FBAuth.fecthFBUser(uid: uid) { (result) in
                        switch result {
                        
                        case .success(let user):

                            self.friends.append(user)
                            self.status = .plane
                            
                        case .failure(let error):
                            self.status = .error(error.localizedDescription)
                        }
                        
                    }
                case .removed :
                    
                    guard let index = self.friends.map({$0.uid}).firstIndex(of: uid) else { return }
                    self.friends.remove(at: index)
                    
                default :
                    print("Default")
                }
                
            }
            
            
        })
    }
    
    
    func deleteFriend(offsets : IndexSet) {
        
        guard user.isCurrentUser else {return}
        let index = offsets[offsets.startIndex]
        
        let withUser = self.friends[index]
        FBfriend.removeFriend(currentUser: user, withUser: withUser) { (error) in
            
            if let error = error {
                self.status = .error(error.localizedDescription)
            }
            
            self.friends.remove(atOffsets: offsets)
        }
        
    }
    
    
}

