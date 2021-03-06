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
    
    @Published var text = ""
    @Published var codeText = ""
    
    @Published var loading = false
    @Published var showHUD = false
    @Published var listenNewChat = false
    
    @Published var reachLast = false
    @Published var lastDoc : DocumentSnapshot?
    
    @Published var alert = Alert(title: Text("")) {
        didSet {
            showAlert = true
        }
    }
    
    @Published var showAlert = false
    @Published var fullScreen = false
    
    
    var unReadMessages = [String]()
    var newChatlistner : ListenerRegistration?
    var statusListner : ListenerRegistration?
    let limit = 10
    
    
    
    
    //MARK: - fetch
    
    func loadMessage(chatRoomId : String,currentUser : FBUser, completion : ((Message) -> Void)? = nil) {
        
        guard !reachLast && !loading else {return}
        
        var ref : Query!
        
        if lastDoc == nil {
            ref = FirebaseReference(.Message).document(currentUser.uid).collection(chatRoomId).order(by: MessageKey.date, descending: true).limit(to: limit)
        } else {
            loading = true
            
            ref = FirebaseReference(.Message).document(currentUser.uid).collection(chatRoomId).order(by: MessageKey.date, descending: true).start(afterDocument: self.lastDoc!).limit(to: self.limit)
            
        }
        
        ref.getDocuments { (snapshot, error) in
            if let error = error {
                self.alert = errorAlert(message: error.localizedDescription)
                return
            }
            
            guard let snapshot = snapshot else {return}
            guard !snapshot.isEmpty else {
                self.reachLast = true
                
                if  self.newChatlistner == nil {
                    self.listenNewChat(chatRoomId: chatRoomId, currentUser: currentUser)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.loading = false
                }
                return
                
            }
            
            if self.lastDoc == nil {
                self.messages = snapshot.documents.map({Message(dic: $0.data())}).reversed()
                
                self.addReadListner(chatRoomId: chatRoomId, currentUser: currentUser)
                
                self.lastDoc = snapshot.documents.last
                
                self.listenNewChat(chatRoomId: chatRoomId, currentUser: currentUser)
            } else {
                let moreMessages = snapshot.documents.map({Message(dic: $0.data())}).reversed()
                
                if moreMessages.count < self.limit {
                    self.reachLast = true
                }
                
                self.lastDoc = snapshot.documents.last
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    
                    if completion != nil {
                        completion!(self.messages[3])
                    }
                    
                    
                    self.messages.insert(contentsOf: moreMessages, at: 0)
                    self.addReadListner(chatRoomId: chatRoomId, currentUser: currentUser,moreMessages: moreMessages)
                    
                    
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    self.loading = false
                }
                
                
            }
            
        }
        
    }
    
    
    func updateReadStatus(message : Message,chatRoomId : String,users : [FBUser]) {
        
        if !message.read {
            let value = [MessageKey.read : true]
            
            users.forEach { (user) in
                FirebaseReference(.Message).document(user.uid).collection(chatRoomId).document(message.id).updateData(value)
            }
            
        }
        
    }
    
    
    func addReadListner(chatRoomId : String,currentUser : FBUser,moreMessages : ReversedCollection<[Message]>? = nil) {
        
        if moreMessages == nil {
            unReadMessages = self.messages.filter({$0.read != true && $0.userID == currentUser.uid}).map({$0.id})
            
        } else {
            
            let more = moreMessages!.filter({$0.read != true && $0.userID == currentUser.uid}).map({$0.id})
            
            guard more.count > 0 else {return}
            
            
            unReadMessages.append(contentsOf: more)
            print(unReadMessages)
        }
        
        guard unReadMessages.count > 0 else {return}
        
        statusListner = FirebaseReference(.Message).document(currentUser.uid).collection(chatRoomId).whereField(MessageKey.messageId, in: unReadMessages).addSnapshotListener({ (snapshot, error) in
            
            guard let snapshot = snapshot else {return}
            
            print("unRead \(snapshot.documents.count)")
            snapshot.documentChanges.forEach { (diff) in
                switch diff.type {
                case .modified :
                    let editedMessage = Message(dic: diff.document.data())
                    
                    for i in 0 ..< self.messages.count {
                        let temp = self.messages[i]
                        
                        if editedMessage.id == temp.id {
                            self.messages[i] = editedMessage
                            self.messages[i].read = true
                        }
                        
                    }
                default :
                    return
                    
                }
            }
            
        })
    }
    
    
    func listenNewChat(chatRoomId : String,currentUser : FBUser) {
        
        var ref : Query!
        
        if messages.count > 0 {
            let lastMessage = messages.last
            let lastTime = lastMessage!.date
            ref = FirebaseReference(.Message).document(currentUser.uid).collection(chatRoomId).whereField(MessageKey.date, isGreaterThan : lastTime)
        } else {
            ref = FirebaseReference(.Message).document(currentUser.uid).collection(chatRoomId)
        }
        
        newChatlistner = ref.addSnapshotListener { (snapshot, error) in
            
            if let error = error {
                self.alert = errorAlert(message: error.localizedDescription)
                return
            }
            
            guard let snapshot = snapshot else {return}
            guard !snapshot.isEmpty else { return }
            
            snapshot.documentChanges.forEach { (doc) in
                switch doc.type {
                
                case .added:
                    let message = Message(dic: doc.document.data())
                    
                    if !self.messages.contains(message) {
                        
                        self.messages.append(message)
                        self.listenNewChat.toggle()
                        
                    }
                    
                case .modified :
                    let editedMessage = Message(dic: doc.document.data())
                    
                    for i in 0 ..< self.messages.count {
                        let temp = self.messages[i]
                        
                        if editedMessage.id == temp.id {
                            self.messages[i] = editedMessage
                            self.messages[i].read = true
                        }
                        
                    }
                    
                case .removed :
                    print("Remove")
                default :
                    print("NO")
                }
            }
        }
        
        
    }
    
    //MARK: - Send
    
    func sendTextMessage(chatRoomId : String,currentUser : FBUser,withUser : FBUser) {
        
        guard text != "" else {return}
        guard let ecrypText = CryptoAES.shared.ecrypt(text: text) else {return}
        
        let messageID = UUID().uuidString
        let users = [currentUser,withUser]
        
        let data = [MessageKey.text : ecrypText,
                    MessageKey.messageId : messageID,
                    MessageKey.chatRoomId : chatRoomId,
                    MessageKey.userID : currentUser.uid,
                    MessageKey.messageType : MessageKey.TextType,
                    MessageKey.read : false,
                    MessageKey.date : Timestamp(date: Date())
        ] as [String : Any]
        
        
        users.forEach { (user) in
            FirebaseReference(.Message).document(user.uid).collection(chatRoomId).document(messageID).setData(data)
        }
        
        /// last Message && Notification
        Recent.updateRecentCounter(chatRoomID: chatRoomId, lastMessage: text, withUser: withUser)
   
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
                            MessageKey.read : false,
                            MessageKey.messageType : MessageKey.CodeType,
                            MessageKey.date : Timestamp(date: Date()) ] as [String : Any]
                
                users.forEach { (user) in
                    FirebaseReference(.Message).document(user.uid).collection(chatRoomId).document(messageID).setData(data)
                }
                
                let lastMessage = "コードが届きました"
                
                //MARK: - Foreground Notification
                Recent.updateRecentCounter(chatRoomID: chatRoomId, lastMessage: lastMessage, withUser: withUser)
                
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
    
    
    func clearRecentCounter(chatRoomID : String, currentUser : FBUser) {
        
        let value = [RecentKey.counter : 0]
        
        FirebaseReference(.Recent).whereField(RecentKey.chatRoomId, isEqualTo: chatRoomID).getDocuments { (snapshot, error) in
            
            guard let snapshot = snapshot else {return}
            
            if !snapshot.isEmpty {
                for recent in snapshot.documents {
                    let recent = Recent(dic: recent.data())
                    
                    if recent.userId == currentUser.uid {
                  
                        FirebaseReference(.Recent).document(recent.id).updateData(value)
                        
                    }
                    
                }
            }
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
        
        let lastMessage =  "削除されました"
        /// last Message
        Recent.updateRecentCounter(chatRoomID: userInfo.chatRoomId, lastMessage: lastMessage, withUser: withUser,isDelete: true)
    }
    
    func removeListner() {
        newChatlistner?.remove()
        statusListner?.remove()
    }
    
    func removeObject() {
        /// for MacOS
        text = ""
        codeText = ""
        loading = false
        showHUD = false
        listenNewChat = false
        reachLast = false
        lastDoc = nil
        showAlert = false
        unReadMessages = [String]()
        newChatlistner = nil
        statusListner = nil
        messages.removeAll()
    }
    
    //    MARK: - UI
    
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

