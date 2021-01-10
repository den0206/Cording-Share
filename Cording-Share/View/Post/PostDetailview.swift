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
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                        
                        Spacer()
                        
                        /// lang Image
                        vm.post.lang.image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                        
                        Button(action: {vm.fullScreenMode()}) {
                            Image(systemName: "arrow.up.left.and.arrow.down.right")
                        }
                    }
                    .padding()
                 
                    
                    HStack {
                        Spacer()
                        
                        if vm.post.user != nil {
                            Text(vm.post.user!.name)

                        }
                        
                        Spacer()
                        
                        Button(action: {userInfo.copyText(text: vm.post.codeBlock)}) {
                            Image(systemName: "paperclip")
                                .font(.system(size: 22, weight: .regular))
                        }
                        
                    }
                    .padding()
                   

                    ExampleView(loading: $vm.loading, code: .constant(vm.post.codeBlock), mode: vm.post.lang.mode(), fontSize: userInfo.fontSize)
                        


                    Spacer()
                }
                
            
            } else {
                ZStack {
                    
                    /// Z1
                    ExampleView(loading: $vm.loading, code: .constant(vm.post.codeBlock), mode: vm.post.lang.mode(), fontSize: userInfo.fontSize)
                    
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
