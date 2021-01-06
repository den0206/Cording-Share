//
//  FeedView.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/01/01.
//

import SwiftUI
import CodeMirror_SwiftUI

struct FeedView: View {
    
    @EnvironmentObject var userInfo : UserInfo

    @StateObject var vm = FeedViewModel()
    
    var body: some View {
        
        NavigationView {
            
            ScrollView {
                
                LazyVStack {
                    ForEach(0 ..< vm.posts.count , id : \.self) { i in
                        
                        PostCell(post: vm.posts[i])
                        
                    }
                }
                
            }
            .onAppear {
                vm.fetchPosts(userId: userInfo.user.uid)
            }
            .alert(isPresented: $vm.showalert, content: {
                errorAlert(message: vm.errorMessage)
            })
            
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("Feeds")
     
        }
       
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}

//MARK: - Post Cell

struct PostCell : View {
    
    @EnvironmentObject var userInfo : UserInfo
    @State private var loading = true
    var post : Post
    
    var body: some View {
        
        VStack {
            
            ZStack {
                if loading {
                    ProgressView("Loading...")
                        .foregroundColor(.primary)
                }
             
                CodeView(theme: userInfo.theme, code: .constant(post.codeBlock), mode: post.lang.mode(), fontSize: 12, showInvisibleCharacters: false, lineWrapping: false)
                    .onLoadSuccess {
                        loading = false
                    }.onLoadFail({ (error) in
                        print("Load failed : \(error.localizedDescription)")
                        loading = false
                    })
                    .disabled(true)
            }
                
            
            Divider()
                .background(Color.primary)
            
        }
        .frame( height: 100)

       
    }
}
