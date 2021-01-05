//
//  Post.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/01/05.
//

import Foundation
import CodeMirror_SwiftUI

struct Post : Identifiable{
    
    let id : String
    
    var userId : String
    var lang : CodeMode
    var sorceUrl : URL?
    
    var codeBlock : String {
        
        guard let url = sorceUrl else {return "No Code"}
        
        return try! String(contentsOf: url)
    }
    
    init(dic : [String : Any]) {
        
        let id = dic[PostKey.postId] as? String ?? ""
        let userId = dic[PostKey.userID] as? String ?? ""
        
        if let url = dic[PostKey.codeUrl] as? String {
            self.sorceUrl = URL(string: url)
        }
        
        self.id = id
        self.userId = userId
        
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
    
    
}

extension CodeMode  {
    static var codeModes : [CodeMode] {
        return [.swift,.c,.go,.html,.java,.javascript,.objc,.perl,.php,.python,.r,.ruby,.rust]
    }
    
    
}

