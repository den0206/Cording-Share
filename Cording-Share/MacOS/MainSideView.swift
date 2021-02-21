//
//  MainSideView.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/02/13.
//

import SwiftUI

struct MainSideView: View {
    
    @EnvironmentObject var userInfo : UserInfo
    
    init() {
        UINavigationBar.appearance().tintColor = .white
    }

    var body: some View {
        
        
        NavigationView {
            
            SideBar()
                .navigationViewStyle(DoubleColumnNavigationViewStyle())
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarHidden(true)
               
            
        }
        .Loading(isShowing: $userInfo.loading)
        .foregroundColor(.primary)
        .frame( maxWidth: .infinity, maxHeight: .infinity)
        
    }
}

struct SideBar : View {
    
    @EnvironmentObject var userInfo : UserInfo
    
    init() {
        
        let bg = UIView()
        bg.backgroundColor = UIColor.clear
        UITableView.appearance().backgroundColor = UIColor.clear
        UITableViewCell.appearance().selectionStyle = .none
        UITableViewCell.appearance().selectedBackgroundView = bg
    }
    
    var body: some View {
        List {
            
            NavigationLink(destination: AllChatsView()) {
                Label("Message", systemImage: "message")
            }

            
            NavigationLink(destination:  UserProfileView(vm : UserProfileViewModel(user: userInfo.user))) {
                Label("Profile", systemImage: "person.crop.circle")
            }
            
            
            NavigationLink(destination: SettingsView()) {
                Label("Settings", systemImage: "gearshape")
            }
        }
        .padding()
        .padding(.top,20)
        .listItemTint(.clear)
        .listRowBackground(Color.black)
        .accentColor(.clear)
      
    }
}

struct SideTabButton : View {
    
    var imageName : String
    var title : String
    var index : Int
    
    @Binding var selectedIndex : Int
    
    var body: some View {
        
        Button(action: {withAnimation{selectedIndex = index}}) {
            
            VStack(spacing :7) {
                
                Image(systemName: imageName)
                    .font(.system(size: 16,weight : .semibold))
                    .foregroundColor(selectedIndex == index ? .primary : .gray)
                
                Text(title)
                    .fontWeight(.semibold)
                    .font(.system(size: 11))
                    .foregroundColor(selectedIndex == index ? .primary : .gray)
            }
            .padding(.vertical,8)
            .frame(width: 70)
            .contentShape(Rectangle())
            .background(Color.primary.opacity(selectedIndex == index ? 0.15 : 0))
            .cornerRadius(10)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
}

struct MainSideView_Previews: PreviewProvider {
    static var previews: some View {
        MainSideView()
    }
}


struct AllChatsView : View {
    
    @EnvironmentObject var userInfo : UserInfo
    @State private var firstLoad = true
    @StateObject var vm = RecentsViewModel()
    
    var body: some View {
        
        NavigationView {
            
            ScrollView {
                LazyVStack {
                    NavigationLink(destination: MessageView(), isActive: $userInfo.MSGPushNav, label: {})

                    ForEach(vm.recents) { recent in
                        Button(action: {
                                userInfo.chatRoomId = recent.chatRoomId
                                userInfo.withUser = recent.withUser
                                userInfo.MSGPushNav = true
                        }) {
                            RecentCell(recent: recent)
                        }
                        
                        Divider()
                    }
                }
                
            }
            .padding(.top,50)
        

            .onAppear(perform: {
                if firstLoad {
                    vm.fetchRecents(userInfo: userInfo)
                    firstLoad = false
                }
                 
            })
            .navigationBarHidden(true)
        
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarHidden(true)
     
     
    }
}
