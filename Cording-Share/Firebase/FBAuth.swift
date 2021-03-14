//
//  FBAuth.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2020/12/31.
//


import FirebaseAuth
import FirebaseMessaging
import Firebase

struct FBAuth {
    
    static func fecthFBUser(uid : String, completion :  @escaping(Result<FBUser, Error>) -> Void) {
        

        let ref = FirebaseReference(.User).document(uid)
        
        ref.getDocument { (snapshot, error) in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let snapshot = snapshot else {
                completion(.failure(FirestoreError.noDocumentSNapshot))
                return
            }
            
            guard let data = snapshot.data() else {
                completion(.failure(FirestoreError.noSnapshotData))
                return
            }
            
            guard let user = FBUser(dic: data) else {
                completion(.failure(FirestoreError.noUser))
                return
            }
            
            completion(.success(user))
            
        }
        
    }
    
    static func convertFriends(uids : [String], completion : @escaping(Result<[FBUser], Error>) -> Void) {
        
        var friends = [FBUser]()
        
        uids.forEach { (uid) in
            self.fecthFBUser(uid: uid) { (result) in
                switch result {
                
                case .success(let user):
                    friends.append(user)
                    
                    if friends.count == uids.count {
                        completion(.success(friends))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
    }
    
    static func searchUserFromName(name : String, completion : @escaping(Result<FBUser, Error>) -> Void) {
        
//        guard Reachabilty.HasConnection() else {completion(.failure(NetworkError.disConnect))
//            return
//        }
        
        let ref = FirebaseReference(.User).whereField(Userkey.name, isEqualTo: name)
        
        ref.getDocuments { (snapshot, error) in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let snapshot = snapshot else {
                completion(.failure(FirestoreError.noDocumentSNapshot))
                return
            }
            
            guard !snapshot.isEmpty else {completion(.failure(FirestoreSearchError.noFindUser))
                return
            }
            
            let data = snapshot.documents[0].data()
            
            guard let user = FBUser(dic: data) else {
                completion(.failure(FirestoreError.noUser))
                return
            }
            
            completion(.success(user))
            
        }
    }
    
    //MARK: - Create
    
    static func createUser(email : String, name : String,searchId : String, password : String,imageData : Data,completion : @escaping(Result<FBUser, Error>) -> Void) {
        
        /// avoid duplicate name
        FirebaseReference(.User).whereField(Userkey.name, isEqualTo: name).getDocuments { (snapshot, error) in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let snapshot = snapshot else {
                completion(.failure(FirestoreError.noDocumentSNapshot))
                return
            }
            
            /// check exist same name
            guard snapshot.isEmpty else {
                completion(.failure(FirestoreError.duplicateName))
                return
                
            }
            
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
                        let fcm = Messaging.messaging().fcmToken ?? ""
                        
                        let data = [Userkey.userID : uid,
                                    Userkey.name : name,
                                    Userkey.email : email,
                                    Userkey.avatarUrl : imageUrl,
                                    Userkey.searchID : searchId,
                                    Userkey.fcmToken : fcm]
                        
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
    
    static func loginUser(email : String, password : String, completion :@escaping(Result<String, EmailAuthError>) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            var newError : NSError
            
            if let error = error {
                
                print(error.localizedDescription)
                newError = error as NSError
                var emailError : EmailAuthError?
                
                switch newError.code {
                
                case 17009:
                    emailError = .incorrectPassword
                case 17008 :
                    emailError = .invalidEmail
                case 17011 :
                    emailError = .accountDoesnotExist
                default:
                    emailError = .unknownError
                }
                
                completion(.failure(emailError!))
            } else {
                guard let uid = result?.user.uid else {return}
                updateFCMTOken(uid: uid)
                completion(.success(uid))
            }
        }
        
    }

    static func updateFCMTOken(uid : String) {
        let fcm = Messaging.messaging().fcmToken ?? ""
        
        let value = [Userkey.fcmToken : fcm]
        FirebaseReference(.User).document(uid).setData(value, merge: true)
    }
    
    //MARK: - Edit
    
    static func editUser(currentUser : FBUser, vm : AuthUserViewModel, completion : @escaping(Result<FBUser, Error>) -> Void) {
        
        guard let user = vm.currentUser else {return}
        guard currentUser.uid == user.uid else {return}
        
        FirebaseReference(.User).whereField(Userkey.name, isEqualTo: vm.fullname).getDocuments { (snapshot, error) in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let snapshot = snapshot else {return}
            guard snapshot.isEmpty else {
                completion(.failure(FirestoreError.duplicateName))
                return
            }
            
            if vm.imageData.count != 0 {
                let filename =  "Avatars/_" + currentUser.uid + ".jpeg"
                
                saveFileFirestore(data: vm.imageData, fileName: filename) { (result) in
                    switch result {
                    
                    case .success(let imageUrl):
                        
                        FBAuth.updateUser(currentUser: currentUser, vm: vm, imageUrl: imageUrl) { (resultUser) in
                            
                            switch resultUser {
                            
                            case .success(let user):
                                completion(.success(user))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    case .failure(let error):
                        completion(.failure(error))
                        return
                    }
                }
            } else {
                
                FBAuth.updateUser(currentUser: currentUser, vm: vm, imageUrl: nil) { (resultUser) in
                    
                    switch resultUser {
                    case .success(let user):
                        completion(.success(user))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
                
            }
         
          
        }
        
       
        
    }
    
    static func updateUser(currentUser : FBUser, vm : AuthUserViewModel, imageUrl : String?, completion : @escaping(Result<FBUser, Error>) -> Void) {
        
        let uid = currentUser.uid
        
        var data = [
            Userkey.userID : uid,
            Userkey.name : vm.fullname,
            Userkey.email : vm.email
        ]
        
        if imageUrl != nil {
            data[Userkey.avatarUrl] = imageUrl!
        } else {
            data[Userkey.avatarUrl] = currentUser.avaterUrl?.absoluteString
        }
        
        /// Todo change email via firebase admin
    
        FirebaseReference(.User).document(uid).updateData(data) { (error) in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let user = FBUser(dic: data) else {return}
            completion(.success(user))
        }
        
    }
    static func logOut(userInfo :UserInfo, completion : @escaping(Result<Bool, Error>) -> Void) {
        
        let currentUser = userInfo.user
        let value = [Userkey.fcmToken : FieldValue.delete()]
        
        FirebaseReference(.User).document(currentUser.uid).updateData(value) { (error) in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            do {
                try Auth.auth().signOut()
                completion(.success(true))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
 
}


