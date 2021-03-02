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
    
    @Published var showAlert = false
    @Published var alert = Alert(title: Text("")) {
        didSet {
            showAlert = true
        }
    }
    
    func searchUser() {
        
        guard seachText != "" else {return}
        
        FBAuth.srachUserFromName(name: seachText) { (result) in
            
            self.searchedUser = nil
            
            switch result {
            
            case .success(let user):
                self.searchedUser = user
            case .failure(let error):
                print(error.localizedDescription)
                self.alert = errorAlert(message: error.localizedDescription)
            }
            
            self.seachText = ""
        }
        
        
    }
    
}
