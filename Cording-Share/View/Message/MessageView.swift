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
    @StateObject var vm = MessageViewModel()
    
    var chatRoomId : String {
        return userInfo.chatRoomId
    }
    
    var withUser : FBUser {
        return userInfo.withUser
    }
    
    var body: some View {
        VStack {
            
            ScrollView {
                
            }
            .padding(.vertical)
            
            MGTextfield(text: $vm.text) {
                print("Send")
            }
            .animation(.default)
            
        }
        .onAppear(perform: {
            userInfo.showTab = false
        })
        .onDisappear {
            userInfo.showTab = true
            
        }
        
        //MARK: - Navigation Prorety
        .navigationBarTitle(withUser.name)
        .navigationBarItems(trailing:
                                WebImage(url: withUser.avaterUrl)
                                .resizable()
                                .frame(width: 30, height: 30)
                                .clipShape(Circle())
        )
        
        
    }
}



struct  MGTextfield : View {
    
    @Binding var text : String
    @State var editing : Bool = false
    var sendAction : () -> Void
    
    var body: some View {
        HStack(spacing :15) {
            TextField("Enter Message", text: $text) { (editing) in
                self.editing = editing
            } onCommit: {
                self.editing = editing
            }
            .foregroundColor(.black)
            .padding(.horizontal)
            .frame(height : 45)
            .background(Color.primary.opacity(0.06))
            .clipShape(Capsule())
            
            if text != "" {
                Button(action: {self.sendAction()}) {
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
