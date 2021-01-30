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
                LazyVStack {
                    ForEach(vm.posts)  { post in
                        
                        NavigationLink(destination: PostDetailview(vm: PostDetailViewModel(post: post))) {
                            
                            PostCell(post: post)
                                .onAppear {
                                    if post.id == vm.posts.last?.id {
                                        print(vm.reachLast)
                                        vm.fetchPost()
                                    }
                                }
                        }
                        
                    }
                    .listStyle(PlainListStyle())
                    .padding(.top,10)
                    
                }
            }
            
            /// navigation Propety
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
            
        }
        .onAppear {
            vm.fetchPost()
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
    @State private var isExpand = false
    
    var  post : Post
    
    var body: some View {
        
        VStack {
        
            HStack {
                if !isExpand {
                post.lang.image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
                }
                
                 Spacer()
                
                Text(post.tmstring)
                    .font(.caption2)
                
            }
            .padding()
            
            
            if isExpand {
        
                ExampleView(code: .constant(post.codeBlock), lang: post.lang, fontSize: 12)
                    .frame( height: 150)
                    .disabled(true)
                    .padding()
        
            }
            
            Text(post.description)
                .font(.subheadline)
                .foregroundColor(Color.primary)
                .multilineTextAlignment(.leading)
                .padding(.trailing, 32)
                .padding(.top)
            
        
            HStack(spacing :15) {
        
                Image(systemName: "chevron.left.slash.chevron.right")
                    .rotationEffect(.degrees(isExpand ? 0: -180))
                    .font(.system(size: 18, weight: .regular))
                    .onTapGesture {
                        withAnimation(.spring()) {
                            isExpand.toggle()
                        }
                    }
        
                Image(systemName: "paperclip")
                    .font(.system(size: 18, weight: .regular))
                    .onTapGesture {
                        userInfo.copyText(text: post.codeBlock)
                    }
        
                Spacer()
        
        
            }
            .padding()
            
            
           
        
        }
        .background(Color.primary.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .padding()
        .padding(.horizontal,12)
        .foregroundColor(.primary)
      
        
    }
}


