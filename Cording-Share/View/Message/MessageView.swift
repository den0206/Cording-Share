//
//  MessageView.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/01/16.
//

import SwiftUI
import SDWebImageSwiftUI

struct MessageView: View {
    @EnvironmentObject var userInfo : UserInfo
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var vm = MessageViewModel()
    @State private var isEditing = false
    @State private var showSheet = false
    
    var chatRoomId : String {
        return userInfo.chatRoomId
    }
    
    var withUser : FBUser {
        return userInfo.withUser
    }
    
    //MARK: - View
    
    var body: some View {
        
        VStack {
            
            ZStack {
                
                /// Z1
                ScrollView {
                    
                    if vm.loading {
                        ProgressView()
                    }
                    
                    ScrollViewReader { reader in
                        
                        LazyVStack {
                            
                            ForEach(0 ..< vm.messages.count, id : \.self) { i in
                                MessageCell(message: vm.messages[i], currentUser: userInfo.user, withUser: withUser)
                                    .onAppear {
                                        if vm.messages[i].id == vm.messages.first?.id {
                                            /// pgaintion
                                            print("first")
                                            vm.loadMessage(chatRoomId: chatRoomId, currentUser: userInfo.user)
                                        }
                                    }
                            }
                          
                        }
                        .onChange(of: vm.messages) { (value) in
                            /// scroll to bottom get New Chat
                            reader.scrollTo(vm.messages.last?.id, anchor: .bottom)
                        }
                       
                    }
                }
                .padding(.vertical)
                
                
                /// Z2
                
                if isEditing  {
                    Color.black.opacity(0.6)
                        .onTapGesture {
                            hideKeyBord()
                        }
                    
                }
            }
            
            
            MGTextfield(text: $vm.text, editing: $isEditing) {
                vm.sendTextMessage(chatRoomId: chatRoomId, currentUser: userInfo.user, withUser: withUser)}
                buttonAction: {
                    showSheet = true
                }
                .animation(.default)
                .fullScreenCover(isPresented: $showSheet, onDismiss: {
                    vm.codeText = ""
                    userInfo.showTab = false
                }, content: {
                    MessageCodeView(vm: vm).environmentObject(userInfo)
                    
                })
            
            
        }
        .onAppear(perform: {
            vm.loadMessage(chatRoomId: chatRoomId, currentUser: userInfo.user)
            
            userInfo.showTab = false
        })
        .onDisappear {
            userInfo.showTab = true
            
        }
        
        //MARK: - Navigation Prorety
        .navigationBarTitle(withUser.name)
        .navigationBarBackButtonHidden(true)
        
        .navigationBarItems(
            leading: Button(action: {presentationMode.wrappedValue.dismiss()}, label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(.primary)
            }),
            trailing:
                WebImage(url: withUser.avaterUrl)
                .resizable()
                .frame(width: 30, height: 30)
                .clipShape(Circle())
        )
        
        
    }
}

//MARK: - Private Extension Views

struct MessageCell : View {
    
    @EnvironmentObject var userInfo : UserInfo
    
    let message : Message
    let currentUser : FBUser
    let withUser : FBUser
    
    @State private var isExpanding = false
    @State private var showDetail = false
    
    var isCurrentUser : Bool {
        return message.userID == currentUser.uid
    }
    
    
    var body: some View {
        HStack(spacing : 15) {
            
            if !isCurrentUser {
                WebImage(url: withUser.avaterUrl)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
            } else {
                Spacer()
            }
            
            VStack(alignment: isCurrentUser ? .trailing : .leading, spacing: 5) {
                
                switch message.type {
                
                case .text :
                    Text(message.text)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .background(isCurrentUser ? Color.green : Color.gray)
                        .clipShape(BubbleShape(myMessage: isCurrentUser))
                case .code :
                    
                    ZStack(alignment: .topTrailing) {
                        
                        if !isExpanding {
                            
                            Button(action: {isExpanding = true}) {
                                
                                TextIconView(text: "Code Preview", image: Image(systemName: "chevron.left.slash.chevron.right"),font: .caption2,size: 20)
                                    .foregroundColor(.primary)
                            }
                        } else {
                            /// Z1
                            ExampleView(code: .constant(message.codeBlock), lang: message.lang!)
                                .frame( height: 150)
                                .onTapGesture {
                                    showDetail = true
                                }
                            
                            /// Z2
                            Button(action: {isExpanding = false}) {
                                Image(systemName: "xmark")
                                    .foregroundColor(.white)
                                    .padding(5)
                            }
                            
                            
                        }
                    }
                    .padding()
                    .background(isCurrentUser ? Color.green : Color.gray)
                    .clipShape(BubbleShape(myMessage: isCurrentUser))
                    .sheet(isPresented: $showDetail) {
                        
                        /// detail code View
                        VStack {
                            HStack {
                                Button(action: {showDetail = false}) {
                                    Image(systemName: "xmark")
                                        .foregroundColor(.white)
                                        .padding(5)
                                }
                                
                                Spacer()
                            }
                            
                            ExampleView(code: .constant(message.codeBlock), lang: message.lang!)
                                .onTapGesture {
                                    showDetail = true
                                }
                            
                        }
                        .padding()
                        .preferredColorScheme(.dark)
                        .environmentObject(userInfo)
                        
                    }
                    
                }
                
                
                Text(message.tmstring)
                    .font(.caption2)
                    .foregroundColor(.primary)
                    .padding(!isCurrentUser ? .trailing : .leading, 10)
            }
            
            if isCurrentUser {
                WebImage(url: currentUser.avaterUrl)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
            } else {
                Spacer()
            }
            
        }
        .padding(.horizontal,15)
        .id(message.id)
    }
}



struct MGTextfield : View {
    
    @Binding var text : String
    @Binding var editing : Bool
    var sendAction : () -> Void
    var buttonAction : () -> Void
    
    var body: some View {
        HStack() {
            
            Button(action: {buttonAction()}) {
                Image(systemName: "plus")
                    .foregroundColor(.primary)
            }
            .padding(.leading,10)
            
            TextField("Enter Message", text: $text) { (editing) in
                self.editing = editing
            } onCommit: {
                self.editing = editing
            }
            .foregroundColor(.primary)
            .padding(.horizontal)
            .frame(height : 45)
            .background(Color.gray.opacity(0.6))
            .clipShape(Capsule())
            
            if text != "" {
                Button(action: {
                    hideKeyBord()
                    self.sendAction()
                }) {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 22))
                        .foregroundColor(.white)
                        .frame(width: 45, height: 45)
                        .background(Color.green)
                        .clipShape(Circle())
                }
                .padding(.trailing, 5)
            }
            
        }
        .padding(.bottom, 5)
    }
}
