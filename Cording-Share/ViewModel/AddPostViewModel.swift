//
//  AddPostViewModel.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/01/01.
//

import SwiftUI

final class AddPostViewModel : ObservableObject {
    
    @Published var text : String = ""
    @Published var description : String = ""
    @Published var showSideMenu = false
    @Published var fullScreen = false
    @Published var showSelectView = false
    
    @Published var showAlert = false
    @Published var alert : Alert = Alert(title: Text(""))
    
    var editPost : Post?
    
    var buttonColor : Color {
        if text.isEmpty {
            return Color.gray
        } else {
            return Color.green
        }
    }
    
    var didChangeStatus : Bool {

        guard let editPost = editPost else {return false}
        
        guard !isEmpty(_field: text) else {
            return false
        }
        
        if editPost.codeBlock != text {
            return true
        }
        
        return false

    }
    
  
    //MARK: - Functions
    
    func submitCode(userInfo : UserInfo) {
        
        guard description != "" else {
            alert = Alert(title: Text("説明欄が空欄です"), message: Text("送信しますか?"), primaryButton: .cancel(Text("キャンセル")), secondaryButton: .default(Text("PUSH"), action: {
                self.pushCode(userInfo: userInfo)
            }))
            
            self.showAlert = true
            return
        }
        
        pushCode(userInfo: userInfo)
        
    }
    func pushCode(userInfo : UserInfo) {
        guard text != "" else {return}
        guard let data = text.data(using: .utf8) else {return}
        
        let userId = userInfo.user.uid
        let lang = userInfo.mode
        
        userInfo.loading = true

        FBPost.craeteNewPost(data: data, userId: userId, language: lang,description: description) { (result) in

            switch result {

            case .success(let post):
                self.text = ""
                self.description = ""
                print(post)
                userInfo.tabIndex = 1
            case .failure(let error):
                self.alert = errorAlert(message: error.localizedDescription)
                self.showAlert = true
            }

            userInfo.loading = false
        }
    }
    
    func toggleSideMenu(userInfo : UserInfo) {
        
        showSideMenu.toggle()
        userInfo.showTab.toggle()
    }
    
    func fullScreenMode(userInfo : UserInfo) {
        
        switch fullScreen {
        
        case true:
            DispatchQueue.main.async {
                AppDelegate.orientationLock = UIInterfaceOrientationMask.portrait
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                UINavigationController.attemptRotationToDeviceOrientation()
                
                withAnimation(.spring()) {
                    userInfo.showTab = true
                }
               
            }
        case false:
            DispatchQueue.main.async {
                AppDelegate.orientationLock = UIInterfaceOrientationMask.landscape
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
                UINavigationController.attemptRotationToDeviceOrientation()
                
                withAnimation(.spring()) {
                    userInfo.showTab = false
                }
            }
        }
        
        fullScreen.toggle()
    }
    
    
    
}
