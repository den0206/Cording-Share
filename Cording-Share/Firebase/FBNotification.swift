//
//  FBMessage.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/01/17.
//

import Foundation

struct FBNotification {
    
    static func getBadgeCount(user : FBUser, completion : @escaping(Int) -> Void) {
        
        var badgeCount : Int = 0
        
        let query = FirebaseReference(.Recent).whereField(RecentKey.userId, isEqualTo: user.uid).whereField(RecentKey.counter, isNotEqualTo: 0)
     
        query.getDocuments { (snapshot, error) in
            
            guard let snapshot = snapshot else {completion(badgeCount);return}
            
            guard !snapshot.isEmpty else {
                print("Counter is 0")
                completion(badgeCount);
                return}

            snapshot.documents.forEach { (doc) in
                
                let data = doc.data()
                let conter = data[RecentKey.counter] as! Int
                
                print(conter)
                badgeCount += conter
            }
            
            completion(badgeCount)
        }
     
    }
    
    //MARK: - SendNotification
    
    static func sendNotification(toToken : String, title : String = "New Message", text : String,badgCount : Int) {
        
        guard toToken != "" else {print("No Token"); return}
        
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString : [String : Any] = ["to" : toToken,
                                             "priority": "high",
                                             "notification" : ["title" : title, "body" : text,"badge" : badgCount,"sound": "default"],
                                             "data" : ["user" : "test_id"]]
        
  
        
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=\(FCMKey.legacyServerKey)", forHTTPHeaderField: "Authorization")
        print(paramString)
    
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
        
    }
}
