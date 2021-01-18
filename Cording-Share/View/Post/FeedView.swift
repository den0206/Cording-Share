//
//  FeedView.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/01/01.
//

import SwiftUI

struct FeedView: View {
    
    @EnvironmentObject var userInfo : UserInfo
    @StateObject var vm = FeedViewModel()
    
    var body: some View {
        
        NavigationView {
            
    
                List(0 ..< vm.posts.count , id : \.self)  { i in
                    
                    NavigationLink(destination: PostDetailview(vm: PostDetailViewModel(post: vm.posts[i]))) {
                        PostCell(post: vm.posts[i])
                    }
                  
                }
                .listStyle(PlainListStyle())
                .padding(.top,10)

                /// navigation Propety
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarHidden(true)
           
        }
        .onAppear {
            vm.fetchPosts(userId: userInfo.user.uid)
        }
        .alert(isPresented: $vm.showalert, content: {
            errorAlert(message: vm.errorMessage)
        })
       
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
    @State private var isExpand = true
    
    var  post : Post
    
    var body: some View {
        
        VStack {
//            ExampleView(code: .constant(post.codeBlock), lang: post.lang, fontSize: 12)
//                .frame( height: 150)
//                .disabled(true)
//
            
            HStack(spacing :15) {
                
                Image(systemName: "chevron.down")
                    .rotationEffect(.degrees(isExpand ? -180 : 0))
                    .font(.system(size: 22, weight: .regular))
                    .foregroundColor(.primary)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            isExpand.toggle()
                        }
                    }
                
                Image(systemName: "paperclip")
                    .font(.system(size: 22, weight: .regular))
                    .onTapGesture {
                        userInfo.copyText(text: post.codeBlock)
                    }
                
                Spacer()
                
                Text(post.tmstring)
                    .font(.caption2)
                
            }
            .padding()
            
            if isExpand {
                Text(post.description)
                    .font(.subheadline)
                    .foregroundColor(Color.primary)
                    .multilineTextAlignment(.leading)
                    .padding(.trailing, 32)
            }
            
            
        }
        
        .padding(.horizontal,12)
        .foregroundColor(.primary)
        
        
    }
}
