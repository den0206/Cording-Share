//
//  PostDetailview.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/01/09.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostDetailview: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userInfo : UserInfo

    @StateObject var vm : PostDetailViewModel
    
    var body: some View {
        
        ZStack {
            
            if !vm.fullScreen {
                
                VStack {
                    
                    HStack {
                        
                        Button(action: {presentationMode.wrappedValue.dismiss()}) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.primary)
                        }
                        
                        WebImage(url: vm.post.user?.avaterUrl)
                            .resizable()
                            .placeholder{
                                Rectangle().fill(Color.gray)
                            }
                            .scaledToFill()
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                        
                        Spacer()
                        
                        Button(action: {vm.fullScreenMode()}) {
                            Image(systemName: "arrow.up.left.and.arrow.down.right")
                        }
                        
               
                    }
                    .padding(.top)
                    .padding(.horizontal)
                 
                    
                    HStack {
                        Spacer()
                        
                        /// datail
                        Text(vm.post.detailedTimestampString)
                        
                        Spacer()
                        
                        Button(action: {userInfo.copyText(text: vm.post.codeBlock)}) {
                            Image(systemName: "paperclip")
                                .font(.system(size: 22, weight: .regular))
                        }
                        
                    }
                    .padding()
                   
                    GeometryReader { geo in
                        
                        VStack {
                            ExampleView(code: .constant(vm.post.codeBlock), lang: vm.post.lang, fontSize: userInfo.fontSize)
                                .frame(height: (geo.size.height / 3) * 2)
                            
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
                    ExampleView(code: .constant(vm.post.codeBlock), lang: vm.post.lang, fontSize: userInfo.fontSize)
                    
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
            errorAlert(message: vm.errorMessage)
        })
        .onAppear {
            withAnimation(.spring()) {
                userInfo.showTab = false
                
            }
            vm.getPostUser()
        }
        .onDisappear {
            hideKeyBord()
            
            withAnimation(.spring()) {
                userInfo.showTab = true
            }
            
            
        }
        
        .navigationBarHidden(true)
    }
}
