//
//  RecentsViewModel.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/01/17.
//

import Combine

final class RecentsViewModel : ObservableObject {
    
    @Published var recents = [Recent]()
    
    @Published var showALert = false
    @Published var errorMessage = "" {
        didSet {
            showALert = true
        }
    }
    
    init(userInfo : UserInfo) {
        fetchRecents(userInfo: userInfo)
    }
    
    func fetchRecents(userInfo : UserInfo) {
        
        guard Reachabilty.HasConnection() else {
            errorMessage = "No Internet"
            return
        }
        
        FirebaseReference(.Recent).whereField(RecentKey.userId, isEqualTo: userInfo.user.uid).order(by: RecentKey.date, descending: true).addSnapshotListener { (snapshot, error) in
            
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            
            guard let snapshot = snapshot else {return}
            guard !snapshot.isEmpty else {
                self.errorMessage = "No Recents"
                return
                
            }
            
            snapshot.documentChanges.forEach { (diff) in
                
                var recent = Recent(dic: diff.document.data())
                
                let witUserID = recent.withUserId
                
                FBAuth.fecthFBUser(uid: witUserID) { (result) in
                    switch result {
                    
                    case .success(let user):
                        recent.withUser = user
                        
                        self.recents.append(recent)
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                    }
                }
            }
            
        }
        
    }
}


