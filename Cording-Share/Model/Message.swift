//
//  Message.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/01/18.
//

import Foundation
import CodeMirror_SwiftUI
import Firebase

struct Message : Identifiable,Equatable{
    
    enum MessageType {
        case text, code
    }
    
    var id : String
    var userID : String
    var text : String
    var chatRoomId : String
    var date : Timestamp
    var type : MessageType
    
    var read : Bool
    

    var lang : CodeMode?
    var codeUrl : URL?
    var codeBlock : String {
        
        guard let url = codeUrl else {return "No Code"}
        
        do {
            let str = try String(contentsOf: url)
            return str
         
        } catch {
            return "Can't Compile"
        }
        
    }
   
    var tmstring : String {
        return timeElapsed(date: date.dateValue())
    }
    
    //MARK: - init
    init(dic : [String : Any]) {
        
        self.id = dic[MessageKey.messageId] as? String ?? ""
        self.userID = dic[MessageKey.userID] as? String ?? ""
        self.chatRoomId = dic[MessageKey.chatRoomId] as? String ?? ""
        self.date = dic[MessageKey.date] as? Timestamp ?? Timestamp(date: Date())
        
        if let read = dic[MessageKey.read] as? Bool {
            self.read = read
        } else {
            self.read = false
        }

        if let baseText = dic[MessageKey.text] as? String {
         self.text = CryptoAES.shared.decypt(baseText: baseText)
        } else {
            self.text = ""
        }
        
        let strValue = dic[MessageKey.messageType] as? String ?? ""
        
        switch strValue {
        case MessageKey.TextType:
            type = .text
        case MessageKey.CodeType :
            type = .code
        default:
            type = .text
        }
        
        if let codeUrl = dic[MessageKey.codeUrl] as? String {
            self.codeUrl = URL(string: codeUrl)
        }
        
        if let langValue = dic[MessageKey.language] as? String {
            self.lang = encodeLang(strValue: langValue)
        }
        
    }
    
   
}

extension Array where Element: Equatable {
    mutating func remove(value: Element) {
        if let i = self.firstIndex(of: value) {
            self.remove(at: i)
        }
    }
}

