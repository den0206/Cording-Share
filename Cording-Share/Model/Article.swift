//
//  Article.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/03/07.
//

import Foundation

struct Article: Codable, Identifiable{
    
    let id : String
    let body : String
    let title: String
    let user: qitaUser
    let url : String
    

  
    
}

struct qitaUser: Codable {
    let name: String
    let profileImageURL: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case profileImageURL = "profile_image_url"
    }
}

