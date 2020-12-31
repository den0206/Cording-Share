//
//  FBAuth.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2020/12/31.
//


import FirebaseAuth

struct FBAuth {
    
    static func createUser(email : String, name : String,password : String,imageData : Data, completion : @escaping(Result<FBUser, Error>) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let _ = result?.user else {
                completion(.failure(error!))
                return
            }
            
            guard let uid = result?.user.uid else {return}
            
            let filename =  "Avatars/_" + uid + ".jpeg"
            
            saveFileFirestore(data: imageData, fileName: filename) { (result) in
                
                switch result {
                
                case .success(let imageUrl):
                    
                    let data = [Userkey.userID : uid,
                                Userkey.name : name,
                                Userkey.email : email,
                                Userkey.avatarUrl : imageUrl]
                    
                    FirebaseReference(.User).document(uid).setData(data) { (error) in
                        if let error = error {
                            completion(.failure(error))
                            return
                        }
                    }
                    
                    guard let user = FBUser(dic: data) else {return}
                    completion(.success(user))
                case .failure(let error):
                    completion(.failure(error))
                    return
                }
            }
            
            
        }
    }
}
