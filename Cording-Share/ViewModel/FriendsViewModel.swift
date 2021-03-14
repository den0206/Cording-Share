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
    private var listCount = 5
    private let per_page = 5
    
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
        
        guard Reachabilty.HasConnection() else {
            status = .error(NetworkError.disConnect.localizedDescription)
            return
        }
        
        friendsListner =  FirebaseReference(.User).document(user.uid).collection(FriendKey.friends).limit(to: listCount).addSnapshotListener { (snapshot, error) in
            if let error = error {
                self.status = .error(error.localizedDescription)
                return
            }
            
            guard let snapshot = snapshot else {
                self.status = .error(FirestoreError.noDocumentSNapshot.localizedDescription)
                return
                
            }
            
            guard !snapshot.isEmpty else {
                self.status = .empty(.Friend)
                self.reachLast = true
                return
            }
            
            if snapshot.documents.count < self.listCount {
                print("Reach last")
                self.reachLast = true
            } else {
                self.listCount += self.per_page
                print(self.listCount)
            }
            
            self.lastDoc = snapshot.documents.last
            
            self.diffType(diffs: snapshot.documentChanges)
        }
    }
    
    //MARK: - documentChange
    
    private func diffType(diffs :[DocumentChange]) {
        
        let uids = self.friends.map({$0.uid})
        
        diffs.forEach { (diff) in
            let data = diff.document.data()
            let uid = data[FriendKey.userID] as? String ?? ""
            
            switch diff.type {
            
            case .added :
                
                guard !uids.contains(uid) && uid != "" else {return}
                
                FBAuth.fecthFBUser(uid: uid) { (result) in
                    switch result {
                    
                    case .success(let user):
                        
                        if !self.friends.contains(user) {
                            self.friends.append(user)
                        }
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

