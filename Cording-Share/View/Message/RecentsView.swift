//
//  RecentsView.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/01/16.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase

struct RecentsView: View {
    
    @EnvironmentObject var userInfo : UserInfo
    @StateObject var vm = RecentsViewModel()
    @State private var firstLoad = true
    
    var body: some View {
        NavigationView {
            
            VStack {
                NavigationLink(destination: MessageView(), isActive: $userInfo.MSGPushNav, label: {})
        
                List(vm.recents) { recent in
                    
                    Button(action: {
                            userInfo.chatRoomId = recent.chatRoomId
                            userInfo.withUser = recent.withUser
                            userInfo.MSGPushNav = true}) {
                        RecentCell(recent:recent)
                        
                    }
                    
                }
                .listStyle(PlainListStyle())
                
                Spacer()
            }
            .alert(isPresented: $vm.showALert, content: {
                errorAlert(message: vm.errorMessage)
            })
            .onAppear(perform: {
                if firstLoad {
                    vm.fetchRecents(userInfo: userInfo)
                    firstLoad = false
                }
                 
            })
           
            
            .navigationBarTitle(Text("Messages"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct RecentCell : View {
    
    let recent : Recent
    
    var body: some View {
        
        HStack {
            
            WebImage(url: recent.withUser.avaterUrl)
                .resizable()
                .placeholder {
                    Circle().fill(Color.gray)
                }
                .frame(width: 60, height: 60)
                .clipShape(Circle())
            
            Spacer()
            
            VStack() {
                Text(recent.withUser.name)
                
                Spacer()
                
                Text(recent.lastMessage)
                    .font(.caption)
                    .lineLimit(1)
            }
            
            Spacer()
            
            VStack(spacing : 10) {
                
                if recent.counter > 0 {
                    
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 30, height: 30)
                        .overlay(Text("\(recent.counter)"))
                }
               
                
                Text(recent.tmstring)
                    .font(.caption2)
                
            }
           
            
        }
        .padding()
        .foregroundColor(.primary)
        
        
    }
}
