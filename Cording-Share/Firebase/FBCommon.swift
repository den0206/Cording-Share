//
//  FBCommon.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/03/13.
//

import Firebase
import SwiftUI

struct FireCommon {
    
    static let shared = FireCommon()
    
    func firestoreWithPagination<T : FBType>(ref : Query, lastDoc : Binding<DocumentSnapshot>, completion : @escaping(Result<[T], Error>) -> Void) {
        
        var arrays = [T]()
        
        ref.getDocuments { (snapshot, error) in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let snapshot = snapshot else {
                completion(.failure(FirestoreError.noDocumentSNapshot))
                return
            }
            
            guard !snapshot.isEmpty else {
                print("IS Empty")
                return
            }
            
            arrays = snapshot.documents.map({T(dic: $0.data())})
            completion(.success(arrays))
 
        }
    }

}
