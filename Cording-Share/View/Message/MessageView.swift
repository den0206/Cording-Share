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
    @State private var firstAppear = true
    
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
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.green))
                            .scaleEffect(1.5, anchor: .center)
                            .padding()
                            .transition(AnyTransition.fade(duration: 0.5))
                    }
                    
                    
                    ScrollViewReader { reader in
                        
                        LazyVStack {
                            
                            ForEach(0 ..< vm.messages.count, id : \.self) { i in
                                let message = vm.messages[i]
                                
                                MessageCell(vm: vm, message:$vm.messages[i], currentUser: userInfo.user, withUser: withUser)
                                    .onAppear {
                                        if message.id == vm.messages.first?.id {
                                            /// pgaintion
                                            if !firstAppear {
                                              
                                                vm.loadMessage(chatRoomId: chatRoomId, currentUser: userInfo.user) { (message) in
                                                    reader.scrollTo(message.id,anchor : .top)
                                                }
                                                
                                            } else {
                                                reader.scrollTo(vm.messages.last?.id, anchor: .bottom)
                                                firstAppear = false
                                            }
                                           
                                        }
                                     
                                    }
                            }
                            
                        }

                        .onChange(of: vm.listenNewChat) { (value) in
                            /// scroll to bottom get New Chat
                                print("morer")
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
            vm.addSgatusListner(chatRoomId: chatRoomId, currentUser: userInfo.user)
            vm.loadMessage(chatRoomId: chatRoomId, currentUser: userInfo.user)
            userInfo.showTab = false
        })
        .onDisappear {
            print("remove")
            vm.removeListner()
            userInfo.showTab = true
            
        }
        .alert(isPresented: $vm.showAlert, content: {
            vm.alert
        })
        
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
    @StateObject var vm : MessageViewModel
    
    @Binding var message : Message
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
//                        .blur(radius: 3.0)
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
                            
                            if !showDetail {
                                ExampleView(code: .constant(message.codeBlock), lang: message.lang!,tintColor : .white)
                                .frame( height: 150)
                            }
                            
                            /// Z2
                            HStack {
                                Button(action: {
                                    withAnimation(Animation.spring()) {
                                        showDetail = true
                                    }
                                        
                                    
                                }) {
                                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                                }
                                
                                Button(action: {isExpanding = false}) {
                                    Image(systemName: "xmark")
                                }
                            }
                            .foregroundColor(.white)
                            .padding(5)
                            
                            
                            
                        }
                    }
                    .padding()
                    .background(isCurrentUser ? Color.green : Color.gray)
                    .clipShape(BubbleShape(myMessage: isCurrentUser))
                    .fullScreenCover(isPresented: $showDetail) {
                        
                        /// detail code View
                       DetailCodeView(message: message, showDetail: $showDetail)
                        .environmentObject(userInfo)
                        
                    }
                    
                }
                
                
                if message.read {
                    Text("Read")
                        .font(.caption2)
                        .foregroundColor(.primary)
                }
                
                Text(message.tmstring)
                    .font(.caption2)
                    .foregroundColor(.primary)
                    .padding(!isCurrentUser ? .trailing : .leading, 10)
            }
            .contextMenu {
                
                Button(action: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        
                        switch message.type {
                        
                        case .text:
                            userInfo.copyText(text: message.text)
                        case .code:
                            userInfo.copyText(text: message.codeBlock)
                        }
                    }
                    
                }) {
                    Text("Copy")
                    Image(systemName:"paperclip")
                }
                
                if isCurrentUser {
                    Button(action: {
                        /// delete
                        vm.showDeleteALert(message: message, userInfo: userInfo, withUser: withUser)
                    }) {
                        Text("Delete")
                            .foregroundColor(.red)
                        Image(systemName: "trash")
                    }
                }
             
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
        .onAppear(perform: {
            if !message.read && !isCurrentUser {
                
                print("Reda")
                vm.updateMessage(message: message, chatRoomId: userInfo.chatRoomId, withUser: withUser)
                
                message.read = true
            }
            
        })
        .onDisappear{
            isExpanding = false
        }
        .padding(.horizontal,15)
        .id(message.id)
        .transition(AnyTransition.opacity.animation(.linear(duration: 0.7)))
        
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


struct DetailCodeView : View {
    
    let message : Message
    @Binding var showDetail : Bool
    
    var body: some View {
        
        VStack {
            HStack {
                Button(action: {showDetail = false}) {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                        
                }
                Spacer()
            }
            .padding()
        
            ExampleView(code: .constant(message.codeBlock), lang: message.lang!)
           
        }
        .preferredColorScheme(.dark)
       
    }
}
