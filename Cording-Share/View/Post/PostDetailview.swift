//
//  PostDetailview.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/01/09.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostDetailview: View {
    
    enum ViewType {
        case Detail, Edit
    }
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userInfo : UserInfo
  
    @StateObject var vm : PostDetailViewModel
    @State private var showCodeView = false
    
    var body: some View {
    
            ZStack {
                if !vm.fullScreen {
                  
                    VStack {
                        HStack {
                            Button(action: {
                                userInfo.showTab = true

                                presentationMode.wrappedValue.dismiss()
                                
                            }) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.primary)
                            }
                            
                            
                            NavigationLink(destination: UserProfileView(vm: UserProfileViewModel(user: vm.post.user),isSheet : true))
                            {
                                WebImage(url: vm.post.user?.avaterUrl)
                                    .resizable()
                                    .placeholder{
                                        Rectangle().fill(Color.gray)
                                    }
                                    .scaledToFill()
                                    .frame(width: 30, height: 30)
                                    .clipShape(Circle())
                                   
                            }
                            
                            if vm.post.isCurrentUser {
                                Spacer()
                                
                                NavigationLink(destination: EditPostView(post: vm.post)) {
                                    Text("edit")
                                        .foregroundColor(.white)
                                        .font(.caption2)
                                        .frame(width: 50, height: 30)
                                        .background(Color.green)
                                        .cornerRadius(8)
                                        
                                }
                                
                                    
                                CustomDetailButton(title: "Delete", disable: true, backColor: .red, action: {vm.showDeleteAlert(userInfo: userInfo)})
                            }
                  
                            
                            Spacer()
                            
                         
                            
                            Button(action: {vm.fullScreenMode()}) {
                                Image(systemName: "arrow.up.left.and.arrow.down.right")
                            }
                            
                   
                        }
                        .padding(.top)
                        .padding(.horizontal)
                     
                        
                        HStack {
                            
                            Button(action: {userInfo.copyText(text: vm.post.codeBlock)}) {
                                Image(systemName: "paperclip")
                                    .font(.system(size: 22, weight: .regular))
                            }
                            
                         
                            
                            Spacer()
                            
                            /// datail
                            Text(vm.post.detailedTimestampString)
                                .font(.caption2)
                                                
                        }
                        .padding()
                       
                        GeometryReader { geo in
                            
                            VStack {
                                
                                if showCodeView {
                                    /// avoid delay navigation
                                    ExampleView(code: .constant(vm.post.codeBlock), lang: vm.post.lang)
                                        .frame(height: (geo.size.height / 3) * 2)
                                }
                               
                                Divider()
                                    .background(Color.primary)
                                
                                ScrollView(showsIndicators: true) {
                                    
                                    Text(vm.post.description)
                                        .font(.subheadline)
                                        .foregroundColor(Color.primary)
                                        .multilineTextAlignment(.leading)
                                        .padding()
                                }
                                
                            }
                          
                        }
                        
                        Spacer()

                    }
                    
                
                } else {
                    ZStack {
                        
                        /// Z1
                        ExampleView(code: .constant(vm.post.codeBlock), lang: vm.post.lang,withImage :false)
                        
                        /// Z2
                        VStack {
                            Spacer()
                            
                            HStack {
                                Spacer()
                                Button(action: {vm.fullScreenMode()}, label: {
                                    Image(systemName: "arrow.down.right.and.arrow.up.left")
                                        .font(.system(size: 24))
                                        .foregroundColor(.primary)
                                })
                                .padding()
                            }
                        }
                    }
                    
                }
            
            }
            
            .foregroundColor(.primary)
            .alert(isPresented: $vm.showALert, content: {
                vm.alert
            })
            .onAppear {
                withAnimation(.spring()) {
                    userInfo.showTab = false
                    
                }
                
                if vm.post.user == nil {
                    print("call")
                    vm.getPostUser()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    
                    withAnimation(.spring()) {
                        showCodeView = true
                    }

                }
            }
            .onDisappear {
                hideKeyBord()
                showCodeView = false
                
            }
            
            .navigationBarHidden(true)
      
      
    }
}
