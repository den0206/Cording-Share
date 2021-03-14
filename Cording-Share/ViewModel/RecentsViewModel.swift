//
//  RecentsViewModel.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/01/17.
//

import Combine
import FirebaseFirestore

final class RecentsViewModel : ObservableObject {
    
    @Published var recents = [Recent]()
    @Published var status : Status = .plane
    @Published var recentsListner : ListenerRegistration?
    @Published var lastDoc : DocumentSnapshot?
    @Published var reachLast = false

    private let limit = 5
    
    deinit {
        print("Remove Recents")
        recentsListner?.remove()
    }
    
    func fetchRecents() {
        
        guard let uid = FBUser.currentUID() else {return}
        
        
        guard !reachLast else {return}
        
        if lastDoc == nil {
            self.status = .loading
        }
        
        guard Reachabilty.HasConnection() else {
            self.status = .error(NetworkError.disConnect.localizedDescription)
            return
            
        }
        
        var ref : Query!
        
        if lastDoc == nil {
            ref = FirebaseReference(.Recent).whereField(RecentKey.userId, isEqualTo: uid).limit(to: limit)
        } else {
            ref = FirebaseReference(.Recent).whereField(RecentKey.userId, isEqualTo: uid).start(afterDocument: lastDoc!).limit(to: limit)
        }
        
        ref.getDocuments(completion: { (snapshot, error) in
            
            if let error = error {
                self.status = .error(error.localizedDescription)
                return
            }
            
            guard let snapshot = snapshot else {return}
            guard !snapshot.isEmpty else {
                
                if self.lastDoc == nil {
                    self.status = .empty(.Recent)
                }
                
                self.reachLast = true
                return
                
            }
            
            if snapshot.documents.count < self.limit {
                self.reachLast = true
            }
            
            self.lastDoc = snapshot.documents.last
            
            snapshot.documents.forEach { (doc) in
                
                var recent = Recent(dic: doc.data())
                
                FBAuth.fecthFBUser(uid: recent.withUserId) { (result) in
                    switch result {
                    
                    case .success(let withUser):
                        
                        recent.withUser = withUser
                        
                        self.recents.append(recent)
                        self.recents.sort {$0.date.dateValue() > $1.date.dateValue()}
                        
                        self.status = .plane
                        
                    case .failure(let error):
                        self.status = .error(error.localizedDescription)
                    }
                }
            }
        })
        
    }
    
    func addListner() {
        
        guard let uid = FBUser.currentUID() else {return}
        
        recentsListner = FirebaseReference(.Recent).whereField(RecentKey.userId, isEqualTo: uid).whereField(RecentKey.date, isGreaterThan: Timestamp(date: Date())).addSnapshotListener({ (snapshot, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let snapshot = snapshot else {return}
            guard !snapshot.isEmpty else {return}
            
            snapshot.documentChanges.forEach { (diff) in
                
                var recent = Recent(dic: diff.document.data())
                
                switch diff.type {
                
                case .added:
                    
                    for i in 0 ..< self.recents.count {
                        
                        let tempRecent = self.recents[i]
                        
                        if recent.id == tempRecent.id {
                            
                            recent.withUser = tempRecent.withUser
                            
                            self.recents[i] = recent
                            
                        }
                    }
                    
                    self.recents.sort {$0.date.dateValue() > $1.date.dateValue()}
                default :
                    print("Default")
                }
            }
        })
    }
    
    
    //    func fetchRecents(userInfo : UserInfo) {
    //
    //        guard Reachabilty.HasConnection() else {
    //            self.status = .error(NetworkError.disConnect.localizedDescription)
    //            return
    //
    //        }
    //
    //        FirebaseReference(.Recent).whereField(RecentKey.userId, isEqualTo: userInfo.user.uid).addSnapshotListener { (snapshot, error) in
    //
    //            if let error = error {
    //                self.errorMessage = error.localizedDescription
    //                return
    //            }
    //
    //            guard let snapshot = snapshot else {return}
    //            guard !snapshot.isEmpty else {
    //                self.status = .empty(.Recent)
    //                return
    //
    //            }
    //
    //            snapshot.documentChanges.forEach { (doc) in
    //
    //                var recent = Recent(dic: doc.document.data())
    //
    //
    //                switch doc.type {
    //                case .added:
    //                    let witUserID = recent.withUserId
    //
    //                    FBAuth.fecthFBUser(uid: witUserID) { (result) in
    //                        switch result {
    //
    //                        case .success(let user):
    //                            recent.withUser = user
    //
    //                            self.recents.append(recent)
    //                            self.recents.sort {$0.date.dateValue() > $1.date.dateValue()}
    //
    //                            self.status = .plane
    //                        case .failure(let error):
    //                            self.errorMessage = error.localizedDescription
    //                        }
    //                    }
    //
    //                case .modified:
    //                    for i in 0 ..< self.recents.count {
    //
    //                        let tempRecent = self.recents[i]
    //
    //                        if recent.id == tempRecent.id {
    //
    //                            recent.withUser = tempRecent.withUser
    //
    //                            self.recents[i] = recent
    //
    //                        }
    //                    }
    //
    //                    /// sort
    //                    self.recents.sort {$0.date.dateValue() > $1.date.dateValue()}
    //
    //                default :
    //                    print("Default")
    //                }
    //
    //            }
    //        }
    //
    //    }
    
    func updateBadgCunt(recent : Recent) {
        let counter = recent.counter
        
        UIApplication.shared.applicationIconBadgeNumber -= counter
        
        if UIApplication.shared.applicationIconBadgeNumber < 0 {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }
    
    func deleteRecents(at offsets : IndexSet) {
        self.recents.remove(atOffsets: offsets)
        let index = offsets[offsets.startIndex]
        print(index)
        
        //MARK: - Delete recents from firestore
    }
}







