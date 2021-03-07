//
//  Post.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/01/05.
//

import Foundation
import SwiftUI
import CodeMirror_SwiftUI
import Firebase

struct Post : Identifiable{
    
    let id : String
    
    var userId : String
    var lang : CodeMode
    var sorceUrl : URL?
    var description : String 
    var user : FBUser?
    let timestamp : Timestamp
    
    var liked : Bool = false
    
    var isCurrentUser : Bool{
        return userId == Auth.auth().currentUser?.uid
    }
    
    var codeBlock : String {
        
        guard let url = sorceUrl else {return "No Code"}
        
        do {
            let str = try String(contentsOf: url)
            return str
         
        } catch {
            return "Can't Compile"
        }
        
    }
    
    //MARK: - init
    
    init(dic : [String : Any]) {
        
        let id = dic[PostKey.postId] as? String ?? ""
        let userId = dic[PostKey.userID] as? String ?? ""
        let desc = dic[PostKey.description] as? String ?? "No Description"
        let timestamp = dic[PostKey.date] as? Timestamp ?? Timestamp(date: Date())
    
        self.id = id
        self.userId = userId
        self.description = desc
        self.timestamp = timestamp
        
        if let url = dic[PostKey.codeUrl] as? String {
            self.sorceUrl = URL(string: url)
        }
        
        
        let strValue = dic[PostKey.language] as? String ?? ""
        
        lang = encodeLang(strValue: strValue)
        
    }
    
    //MARK: - TimestampString
    
    var timestampString: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: timestamp.dateValue(), to: Date()) ?? ""
    }
    
    var tmstring : String {
        return timeElapsed(date: timestamp.dateValue())
    }
    
    var detailedTimestampString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd · h:mm a"
        return formatter.string(from: timestamp.dateValue())
        
//        "h:mm a · MM/dd/yyyy"
    }
    
    
}

extension CodeMode  {
    static var codeModes : [CodeMode] {
        return [.swift,.python,.c,.ruby,.go,.java,.javascript,.php,]
    }
    
    var image : Image {
        switch self {
        
        default:
            return Image(rawValue.capitalized)
        }
    }
    
    
}

func encodeLang(strValue : String) -> CodeMode {
    
    var lang : CodeMode
    
    switch strValue {
    
    case "swift":
        lang = .swift
    case "c" :
        lang = .c
    case "html" :
        lang = .html
    case "java" :
        lang = .java
    case "javascript" :
        lang = .javascript
    case "objc" :
        lang = .objc
    case "perl" :
        lang = .perl
    case "php" :
        lang = .php
    case "python" :
        lang = .python
    case "r" :
        lang = .r
    case "ruby" :
        lang = .ruby
    case "rust" :
        lang = .rust
    default:
        lang = .csharp
    }
    
    return lang
}


