//
//  MessageCodeView.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/01/23.
//

import SwiftUI

struct MessageCodeView: View {
    
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
            
            if !vm.fullScreen {
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
                                SelecteLanguageView()

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
                
                MessageSideMenu(showSideMenu: $showSideMenu)
                
                /// Z3
                
                if !showSideMenu {
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
                
            } else {
                /// fullscreen
                
                /// Z1
                ExampleView(code: $vm.codeText, lang: userInfo.mode,withImage : false)
                
                /// Z2
                VStack {
                    Spacer()
                    
                    HStack {
                        
                        Spacer()
                        
                        Button(action: {vm.sendCodeMessage(chatRoomId: chatRoomId, userInfo: userInfo, withUser: withUser, completion: {presentationMode.wrappedValue.dismiss()})}) {
                            CommitButton(text: $vm.codeText)
                        }
                        .disabled(vm.codeText.isEmpty)
                        
                        Button(action: {vm.fullScreenMode(userInfo: userInfo)}) {
                            Image(systemName: "arrow.down.right.and.arrow.up.left")
                                .font(.system(size: 24))
                                .foregroundColor(.primary)
                        }
                        
                    }
                    .padding()
                }
                
            }
           
           
            
        }
        .Loading(isShowing: $vm.loading)
        .foregroundColor(.primary)
        .preferredColorScheme(.dark)
      
    }
}

struct MessageSideMenu : View {
    
    @EnvironmentObject var userInfo : UserInfo
    @Binding var showSideMenu : Bool
    
    let width = UIScreen.main.bounds.width
    
    var body: some View {
        
        
        HStack(spacing :20) {
            Spacer()
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button(action: {
                            withAnimation(.spring()) {
                                showSideMenu = false
                                userInfo.showTab = true
                            }}, label: {
                                Image(systemName: "xmark")
                                    .font(.system(size: 22,weight : .bold))
                                    .foregroundColor(.black)
                            })
                }
                .padding()
                .padding(.top,4)
                
                VStack(spacing :4) {
                    
                    Text("Font Size")
                        .underline()
                    
                    Picker(selection: $userInfo.fontSize, label: Text(""), content: {
                        ForEach(4 ..< 25, id : \.self) { i in
                            Text("\(i)")
                                .foregroundColor(.black)
                        }
                    })
                    .labelsHidden()
                    
                    Text("Code Theme")
                        .underline()
                    
                    Picker(selection: $userInfo.themeIndex, label: Text(""), content: {
                        ForEach(0 ..< userInfo.themes.count ) { i in
                            Text("\(userInfo.themes[i].rawValue)")
                                .foregroundColor(.black)
                            
                        }
                    })
                    .labelsHidden()
                    
                }
                .foregroundColor(.black)
                .padding(.top)
                .padding(.leading,40)
                
                Spacer()
                
            }
            .frame(width: width - 100)
            .background(Color.gray)
            .offset(x: showSideMenu ? 0 : width - 100)
        }
        .background(Color.black.opacity(showSideMenu ? 0.3 : 0).onTapGesture {
            withAnimation(.spring()) {
                showSideMenu = false
                userInfo.showTab = true
            }
            
        })
    }
}


