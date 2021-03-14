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
    
    @Published var showALert = false
    @Published var errorMessage = "" {
        didSet {
            showALert = true
        }
    }
    
    
    func fetchRecents(userInfo : UserInfo) {

        guard Reachabilty.HasConnection() else {
            self.status = .error(NetworkError.disConnect.localizedDescription)
            return

        }

        FirebaseReference(.Recent).whereField(RecentKey.userId, isEqualTo: userInfo.user.uid).addSnapshotListener { (snapshot, error) in
            
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            
            guard let snapshot = snapshot else {return}
            guard !snapshot.isEmpty else {
                self.status = .empty(.Recent)
                return
                
            }
            
            snapshot.documentChanges.forEach { (doc) in
            
                var recent = Recent(dic: doc.document.data())
            
            
                switch doc.type {
                case .added:
                    let witUserID = recent.withUserId
            
                    FBAuth.fecthFBUser(uid: witUserID) { (result) in
                        switch result {
            
                        case .success(let user):
                            recent.withUser = user
            
                            self.recents.append(recent)
                            self.recents.sort {$0.date.dateValue() > $1.date.dateValue()}
                            
                            self.status = .plane
                        case .failure(let error):
                            self.errorMessage = error.localizedDescription
                        }
                    }
                    
                case .modified:
                    for i in 0 ..< self.recents.count {
                        
                        let tempRecent = self.recents[i]
                        
                        if recent.id == tempRecent.id {
                            
                            recent.withUser = tempRecent.withUser
                            
                            self.recents[i] = recent
                           
                        }
                    }
                    
                    /// sort
                    self.recents.sort {$0.date.dateValue() > $1.date.dateValue()}
                    
                default :
                    print("Default")
                }
            
            }
        }
        
    }
    
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







