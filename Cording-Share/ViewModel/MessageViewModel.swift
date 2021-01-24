//
//  MessageViewModel.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/01/18.
//

import SwiftUI
import Firebase

final class MessageViewModel : ObservableObject {
    
    @Published var messages = [Message]()
    @Published var text = ""
    @Published var codeText = ""
    @Published var loading = false
    
    @Published var reachLast = false {
        didSet {
            print(reachLast)
        }
    }
    @Published var lastDoc : DocumentSnapshot?
    
    @Published var errorMessage = ""
    @Published var fullScreen = false
    
    let limit = 9
    
    //MARK: - fetch
    
    func loadMessage(chatRoomId : String,currentUser : FBUser) {
        
        guard !reachLast else {return}
        loading = true
        
        var ref : Query!
        
        if lastDoc == nil {
            ref = FirebaseReference(.Message).document(currentUser.uid).collection(chatRoomId).order(by: RecentKey.date, descending: false).limit(to: limit)
        } else {
            ref = FirebaseReference(.Message).document(currentUser.uid).collection(chatRoomId).order(by: RecentKey.date, descending: false).start(afterDocument: lastDoc!).limit(to: limit)
        }
        
        ref.addSnapshotListener { (snapshot, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let snapshot = snapshot else {return}
            guard !snapshot.isEmpty else {
                self.reachLast = true
                self.loading = false
                return
                
            }
            
            snapshot.documentChanges.forEach { (doc) in
                
                switch doc.type {
                
                case .added :
                    
                    let message = Message(dic: doc.document.data())
                    self.messages.append(message)
                    
                default :
                    print("NO Message")
                }
            }
            

            if self.messages.count < 9 {
                self.reachLast = true
            }

            self.lastDoc = snapshot.documents.last
            self.loading = false
            
        }
        
    }
    
    //MARK: - Send
    
    func sendTextMessage(chatRoomId : String,currentUser : FBUser,withUser : FBUser) {
        
        guard text != "" else {return}
        
        let messageID = UUID().uuidString
        let users = [currentUser,withUser]
        
        let data = [MessageKey.text : text,
                    MessageKey.messageId : messageID,
                    MessageKey.chatRoomId : chatRoomId,
                    MessageKey.userID : currentUser.uid,
                    MessageKey.messageType : MessageKey.TextType,
                    MessageKey.date : Timestamp(date: Date())
        ] as [String : Any]
        
        print(data)
        
        users.forEach { (user) in
            FirebaseReference(.Message).document(user.uid).collection(chatRoomId).document(messageID).setData(data)
        }
        
        /// reset
        text = ""
        
    }
    
    func sendCodeMessage(chatRoomId : String,userInfo : UserInfo, withUser : FBUser, completion : @escaping() -> Void) {
        
        guard codeText != "" else {return}
        guard let data = codeText.data(using: .utf8) else {return}
        
        let currentUser = userInfo.user
        let lang = userInfo.mode
        
        
        let messageID = UUID().uuidString
        let users = [currentUser,withUser]
        
        let fileName = "sources/" + "\(currentUser.uid)/" + messageID + ".txt"
        
        /// upload txt file
        
        loading = true
        
        saveFileFirestore(data: data, fileName: fileName) { (result) in
            switch result {
            
            case .success(let codeUrl):
                
                let data = [MessageKey.codeUrl : codeUrl,
                            MessageKey.language : lang.rawValue,
                            MessageKey.messageId : messageID,
                            MessageKey.chatRoomId : chatRoomId,
                            MessageKey.userID : currentUser.uid,
                            MessageKey.messageType : MessageKey.CodeType,
                            MessageKey.date : Timestamp(date: Date()) ] as [String : Any]
                
                users.forEach { (user) in
                    FirebaseReference(.Message).document(user.uid).collection(chatRoomId).document(messageID).setData(data)
                }
                
                /// reset
                self.codeText = ""
                self.text = ""
                
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
            
            completion()

            self.loading = false
        }
    }
    
    
    //MARK: - UI
    
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
