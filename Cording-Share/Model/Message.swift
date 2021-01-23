//
//  Message.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/01/18.
//

import Foundation
import Firebase

struct Message : Identifiable,Equatable{
    
    enum MessageType {
        case text, code
    }
    
    var id : String
    var userID : String
    var text : String
    var date : Timestamp
    
    var type : MessageType
    
    var tmstring : String {
        return timeElapsed(date: date.dateValue())
    }
    
    init(dic : [String : Any]) {
        
        self.id = dic[MessageKey.messageId] as? String ?? ""
        self.userID = dic[MessageKey.userID] as? String ?? ""
        self.date = dic[MessageKey.date] as? Timestamp ?? Timestamp(date: Date())
        
        self.text = dic[MessageKey.text] as? String ?? ""
        
        let strValue = dic[MessageKey.messageType] as? String ?? ""
        
        switch strValue {
        case MessageKey.TextType:
            type = .text
        case MessageKey.CodeType :
            type = .code
        default:
            type = .text
        }
    }
    
   
}


