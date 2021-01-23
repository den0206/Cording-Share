//
//  MessageViewModel.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/01/18.
//

import Combine
import Firebase

final class MessageViewModel : ObservableObject {
    
    @Published var messages = [Message]()
    @Published var text = ""
    
    //MARK: - fetch
    
    func loadMessage(chatRoomId : String,currentUser : FBUser) {
        
        FirebaseReference(.Message).document(currentUser.uid).collection(chatRoomId).order(by: RecentKey.date, descending: false).addSnapshotListener { (snapshot, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let snapshot = snapshot else {return}
            guard !snapshot.isEmpty else {print("Empty");return}
            
            snapshot.documentChanges.forEach { (doc) in
                
                switch doc.type {
                
                case .added :
                    
                    let message = Message(dic: doc.document.data())
                    self.messages.append(message)
                    print(self.messages.count)
                    
                default :
                    print("NO Message")
                    return
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
        
        print(data)
        
        users.forEach { (user) in
            FirebaseReference(.Message).document(user.uid).collection(chatRoomId).document(messageID).setData(data)
        }
        
        /// reset
        text = ""
        
    }
   
}
