//
//  APIManager.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/03/07.
//

import Foundation
import CodeMirror_SwiftUI

final class NewsViewModel : ObservableObject{
    
    enum ScrollTo {
        case top
    }
    
    @Published var articles = [Article]()
    @Published var currentPage = 1
    @Published var currentTag : CodeMode = .swift
    @Published var loading = false
   
    @Published var scrollTo : ScrollTo? = nil
    
    var manager = NewsManager()
    let limit = 5
    
    func ferchArticles() {
        
        if currentPage == 1 {
            loading = true
        }
        
        manager.fetchNews(lang: currentTag, currentPage: currentPage, per_page: limit) { (result) in
            
            switch result {
            case .success(let array):
                
                DispatchQueue.main.async {
                    self.articles.append(contentsOf: array)
                    self.currentPage += 1
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
            
            if self.loading {
                DispatchQueue.main.async {
                    self.loading = false

                }
            }
        }
    }
    
  
    
    func changeTag(lang : CodeMode) {
        currentTag = lang
        currentPage = 1
        articles.removeAll()
        
        ferchArticles()
    }
    
   
    
}

