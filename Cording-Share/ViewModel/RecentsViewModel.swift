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
    
    @Published var showALert = false
    @Published var errorMessage = "" {
        didSet {
            showALert = true
        }
    }
    
    
    func fetchRecents(userInfo : UserInfo) {
        
        FirebaseReference(.Recent).whereField(RecentKey.userId, isEqualTo: userInfo.user.uid).addSnapshotListener { (snapshot, error) in
            
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            
            guard let snapshot = snapshot else {return}
            guard !snapshot.isEmpty else {
                self.errorMessage = "No Recents"
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
}







