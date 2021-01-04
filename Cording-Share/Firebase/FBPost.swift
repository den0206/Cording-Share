//
//  FBPost.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/01/03.
//

import FirebaseFirestore
import CodeMirror_SwiftUI

struct FBPost {
    
    static func craeteNewPost(data : Data, userId : String, language : CodeMode, completion : @escaping(Result<Bool, Error>) -> Void) {
        
        let postId = UUID().uuidString
    
        let fileName = "sources/" + "\(userId)/" + postId + ".txt"
        
        
        saveFileFirestore(data: data, fileName: fileName) { (result) in
            
            switch result {
            
            case .success(let codeUrl):
                
                let data = [PostKey.postId : postId,
                            PostKey.userID : userId,
                            PostKey.codeUrl : codeUrl,
                            PostKey.language : language.rawValue,
                            PostKey.date : Timestamp(date: Date())
                            
                ] as [String : Any]
                
                FirebaseReference(.User).document(userId).collection(PostKey.posts).document(postId).setData(data) { (error) in
                    
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                }
                
                completion(.success(true))
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
       
    }
}
