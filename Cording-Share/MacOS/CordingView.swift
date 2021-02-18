//
//  CordingView.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/02/14.
//

import SwiftUI

struct CordingView: View {
    
    @EnvironmentObject var userInfo : UserInfo
    @Environment(\.presentationMode) var presentationMode

    @StateObject var vm : MessageViewModel
    @State private var showSideMenu = false
    @State private var showSelectView = false
    
    var chatRoomId : String {
        return userInfo.chatRoomId
    }
    
    var withUser : FBUser {
        return userInfo.withUser
    }
    
    var body: some View {
        ZStack {
            /// Z1
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                        
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 24))
                    }
                    
                    Spacer()
                    
                    TextIconView(mode: userInfo.mode)
                        .onTapGesture {
                            showSelectView.toggle()
                        }
                        .sheet(isPresented: $showSelectView) {
                            /// force load View
                            vm.text = ""
                        } content: {
                            SelecteLanguageView().environmentObject(userInfo)

                        }

                    
                    Spacer()
                    
                    Button(action: {vm.fullScreenMode(userInfo: userInfo)}, label: {
                        Image(systemName: "arrow.up.left.and.arrow.down.right")
                            .font(.system(size: 24))
                        
                    })
                    
                    Button(action: {
                        withAnimation(.spring()) {
                            showSideMenu = true
                            userInfo.showTab = false
                        }
                    }, label: {
                        Image(systemName: "line.horizontal.3")
                            .font(.system(size: 24))
                    })
                    
                }
                .padding()
                .padding(.top , 6)
                .foregroundColor(.primary)
                .background(Color.clear)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                
                ExampleView(code: $vm.codeText, lang: userInfo.mode,withImage : false)
                
                Spacer()
            }
            
            
            /// Z2
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                            vm.sendCodeMessage(chatRoomId: chatRoomId, userInfo: userInfo, withUser: withUser, completion: {presentationMode.wrappedValue.dismiss()}
                            )
                        
                    }) {
                        CommitButton(text: $vm.codeText)
                    }
                    .disabled(vm.codeText.isEmpty)
                    .padding()
                    
                }
            }
        }
        .foregroundColor(.primary)
        .preferredColorScheme(.dark)
        
    }
}
