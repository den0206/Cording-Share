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
    }
    
    //MARK: - TimestampString
    
    var timestampString: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: timestamp.dateValue(), to: Date()) ?? ""
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
        return [.swift,.c,.go,.html,.java,.javascript,.objc,.perl,.php,.python,.r,.ruby,.rust]
    }
    
    var image : Image {
        switch self {
        case .swift:
            return Image("Swift")
        case .python :
            return Image("Python")
        case .ruby :
            return Image("Ruby")
        default:
            return Image("")
        }
    }
    
}


