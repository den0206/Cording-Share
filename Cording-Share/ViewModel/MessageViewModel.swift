//
//  MessageViewModel.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/01/18.
//

import SwiftUI
import Firebase

final class MessageViewModel : ObservableObject {
    
    @Published var messages = [Message]() {
        didSet {
            print(messages.count)
        }
    }
    //    var lastMessage : Message?
    
    @Published var text = ""
    @Published var codeText = ""
    @Published var firstLoad = true
    
    @Published var loading = false
    @Published var showHUD = false
    
    @Published var reachLast = false
    @Published var lastDoc : DocumentSnapshot?
    
    @Published var alert = Alert(title: Text("")) {
        didSet {
            showAlert = true
        }
    }
    
    @Published var showAlert = false
    @Published var fullScreen = false
    
    let limit = 5
    
    //MARK: - fetch
    
    func loadMessage(chatRoomId : String,currentUser : FBUser) {
        
        guard !reachLast else {return}
        loading = true
        
        var ref : Query!
        
        if lastDoc == nil {
            ref = FirebaseReference(.Message).document(currentUser.uid).collection(chatRoomId).order(by: MessageKey.date, descending: true).limit(to: limit)
        } else {
            ref = FirebaseReference(.Message).document(currentUser.uid).collection(chatRoomId).order(by: MessageKey.date, descending: true).start(afterDocument: lastDoc!).limit(to: limit)
        }
        
        
        
        ref.getDocuments { (snapshot, error) in
            if let error = error {
                self.alert = errorAlert(message: error.localizedDescription)
                return
            }
            
            guard let snapshot = snapshot else {return}
            guard !snapshot.isEmpty else {
                self.reachLast = true
                self.loading = false
                return
                
            }
            
            if self.lastDoc == nil {
                self.messages = snapshot.documents.map({Message(dic: $0.data())}).reversed()
            } else {
                self.messages.insert(contentsOf: snapshot.documents.map({Message(dic: $0.data())}).reversed(), at: 0)
            }
            
            self.listenNewChat(chatRoomId: chatRoomId, currentUser: currentUser)
            

            //            snapshot.documentChanges.forEach { (doc) in
            //
            //                switch doc.type {
            //
            //                case .added :
            //                    let message = Message(dic: doc.document.data())
            //
            //                    if !self.messages.contains(message) {
            //
            //                        self.messages.append(message)
            //
            //                        if self.messages.count % self.limit == 0 {
            //                            print("load")
            //                        }
            //
            //                    }
            //                case .modified :
            //                    print("edit")
            //
            //                case .removed :
            //                    let message = Message(dic: doc.document.data())
            //
            //                    if !doc.document.metadata.hasPendingWrites {
            //                        print("delete")
            //                        self.messages.remove(value: message)
            //                    }
            //
            //                default :
            //                    print("NO Message")
            //                }
            //
            //            }
            
            
            self.lastDoc = snapshot.documents.last
            
            
            self.loading = false
            
            
            
        }
        
    }
    
    func listenNewChat(chatRoomId : String,currentUser : FBUser) {
        
        print("call")
        if messages.count > 0 {
            let lastMessage = messages.last
            print(lastMessage?.text)
            let lastTime = lastMessage!.date
            
            FirebaseReference(.Message).document(currentUser.uid).collection(chatRoomId).whereField(MessageKey.date, isGreaterThan : lastTime).addSnapshotListener { (snapshot, error) in
                
                if let error = error {
                    self.alert = errorAlert(message: error.localizedDescription)
                    return
                }
                
                guard let snapshot = snapshot else {return}
                guard !snapshot.isEmpty else { return }
                
                snapshot.documentChanges.forEach { (doc) in
                    switch doc.type {
                    
                    case .added:
                        print("all")
                        let message = Message(dic: doc.document.data())
                        
                        if !self.messages.contains(message) {
                            self.messages.append(message)

                        }
                        
                    default :
                        print("NO")
                    }
                }
            }
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
        
        
        users.forEach { (user) in
            FirebaseReference(.Message).document(user.uid).collection(chatRoomId).document(messageID).setData(data)
        }
        
        //                messages.append(Message(dic: data))
        
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
                
                //                                self.messages.append(Message(dic: data))
                /// reset
                self.codeText = ""
                self.text = ""
                
            case .failure(let error):
                self.alert = errorAlert(message: error.localizedDescription)
                
            }
            
            completion()
            
            self.loading = false
        }
    }
    
    
    //MARK: - delete Message
    
    func showDeleteALert(message : Message, userInfo : UserInfo, withUser : FBUser) {
        
        alert = Alert(title: Text("確認"), message: Text("削除しますか？"), primaryButton: .cancel(), secondaryButton: .destructive(Text("削除"), action: {
            
            self.deleteMessage(message: message, userInfo: userInfo, withUser: withUser)
            
            
        }))
    }
    
    func deleteMessage(message : Message, userInfo : UserInfo, withUser : FBUser) {
        
        let currentUser = userInfo.user
        guard Reachabilty.HasConnection() else {
            self.alert = errorAlert(message: "No Internet")
            return
            
        }
        
        guard message.userID == currentUser.uid else {return}
        
        let users = [currentUser,withUser]
        
        users.forEach { (user) in
            FirebaseReference(.Message).document(user.uid).collection(message.chatRoomId).document(message.id).delete()
        }
        
        if message.type == .code {
            let ref = Storage.storage().reference()
            
            ref.child("sources").child(currentUser.uid).child("\(message.id).txt").delete { (error) in
                
                if let error = error {
                    self.alert = errorAlert(message: error.localizedDescription)
                    return
                }
                
                  DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                      self.messages.remove(value: message)
                  }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.messages.remove(value: message)
            }
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



