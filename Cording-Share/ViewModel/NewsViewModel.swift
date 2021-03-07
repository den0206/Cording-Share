//
//  APIManager.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/03/07.
//

import Foundation
import CodeMirror_SwiftUI

final class NewsViewModel : ObservableObject{
    
    @Published var articles = [Article]()
    @Published var currentPage = 1
    @Published var currentTag : CodeMode = .swift
    
    var manager = NewsManager()
    
    func ferchArticles() {
        
        manager.fetchNews(lang: currentTag, currentPage: currentPage) { (result) in
            
            switch result {
            case .success(let array):
                
                DispatchQueue.main.async {
                    self.articles.append(contentsOf: array)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
  
    
    
}

