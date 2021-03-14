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
    @State private var showSearch = false
    
    var body: some View {
        NavigationView {
            
            VStack {
                NavigationLink(destination: MessageView(), isActive: $userInfo.MSGPushNav, label: {})
                
                if vm.status == .plane {
                    List {
                        ForEach(vm.recents) { recent in
                            
                            Button(action: {
                                userInfo.chatRoomId = recent.chatRoomId
                                userInfo.withUser = recent.withUser
                                userInfo.MSGPushNav = true
                                
                                /// update badgeCount
                                vm.updateBadgCunt(recent: recent)
                                
                            }) {
                                RecentCell(recent:recent)
                            }
                            .onAppear {
                                if recent.id == vm.recents.last?.id {
                                    vm.fetchRecents()
                                }
                            }
                            
                        }
                        //                        .onDelete(perform: vm.deleteRecents(at:))
                    }
                    .listStyle(PlainListStyle())
                } else {
                    StatusView(status: vm.status, retryAction: {vm.fetchRecents()})
                 
                }
                
                
                Spacer()
            }
            .onAppear(perform: {
                if firstLoad {
                    vm.addListner()
                    vm.fetchRecents()
                    firstLoad = false
                    
                    FBNotification.getBadgeCount(user: userInfo.user) { (badge) in
                        UIApplication.shared.applicationIconBadgeNumber = badge
                    }
                    
                    
                }
            })
            
            //MARK: - Navigation Propery
            .navigationBarTitle(Text("Messages"))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing:
                                    Button(action: {showSearch = true}) {
                                        Image(systemName: "plus")
                                            .foregroundColor(.primary)
                                    }
                                    .sheet(isPresented: $showSearch) {
                                        /// show Search user
                                        SearchUserView().environmentObject(userInfo)
                                    }
            )
            
            
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
