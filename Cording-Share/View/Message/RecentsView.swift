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
    @StateObject var vm : RecentsViewModel
    
    
    var body: some View {
        NavigationView {
            
            VStack {
                NavigationLink(destination: MessageView(), isActive: $userInfo.MSGPushNav, label: {})
                
                
                
                List(0 ..< vm.recents.count, id : \.self) { i in
                    
                    Button(action: {
                            userInfo.chatRoomId = vm.recents[i].chatRoomId
                            userInfo.withUser = vm.recents[i].withUser
                            userInfo.MSGPushNav = true}) {
                        RecentCell(recent: vm.recents[i])
                        
                    }
                    
                }
                
                Spacer()
            }
            .alert(isPresented: $vm.showALert, content: {
                errorAlert(message: vm.errorMessage)
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
            
            Text(recent.tmstring)
                .font(.caption2)
            
        }
        .padding()
        .foregroundColor(.primary)
        
    }
}
