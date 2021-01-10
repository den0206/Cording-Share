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
            
            ScrollView {
               VStack {
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
            /// navigation Propety
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
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
    @State private var isExpand = false
    
    var  post : Post
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                post.lang.image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
                
                Spacer()
                
                NavigationLink(destination:  PostDetailview(vm: PostDetailViewModel(post: post))) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 22, weight: .regular))
                        .foregroundColor(.primary)
                }
                
            }
            .padding()
            
            ExampleView(code: .constant(post.codeBlock), mode: post.lang.mode(), fontSize: 12)
                .frame( height: 150)
            
            
            HStack(spacing :15) {
                Spacer()
                
                Image(systemName: "paperclip")
                    .font(.system(size: 22, weight: .regular))
                    .onTapGesture {
                        userInfo.copyText(text: post.codeBlock)
                    }
                
                Image(systemName: "chevron.down")
                    .rotationEffect(.degrees(isExpand ? -180 : 0))
                    .font(.system(size: 22, weight: .regular))
                    .foregroundColor(.primary)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            isExpand.toggle()
                        }
                    }
                
            }
            .padding()
            
            if isExpand {
                Text(post.description)
                    .font(.subheadline)
                    .foregroundColor(Color.primary)
                    .multilineTextAlignment(.leading)
                    .padding(.trailing, 32)
            }
            
            
            Divider()
                .background(Color.primary)
            
        }
        
        .padding(.horizontal,12)
        .foregroundColor(.primary)
        
        
    }
}
