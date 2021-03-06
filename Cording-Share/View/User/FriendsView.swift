//
//  FriendsView.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/03/06.
//

import SwiftUI
import SDWebImageSwiftUI

struct FriendsView : View {
    @EnvironmentObject var userInfo : UserInfo
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var vm : FriendsViewModel
    @State private var isFirstload = true
    
    var body: some View {
        
        VStack {
            
            NavigationLink(destination: UserProfileView(vm: UserProfileViewModel(user: vm.selectedFriend),isSheet : true), isActive: $vm.pushNav, label: {})
              
            
            if vm.status == .plane {
                List{
                    ForEach(vm.friends, id : \.uid) { friend in
                        
                        Button (action: {
                            vm.selectedFriend = friend
                        }) {
                            FriendCell(friend: friend)
                        }
                        .onAppear {
                            
                            if friend.uid == vm.friends.last?.uid {
                                vm.fetchFriends()
                            }
                        }
                       
                        
                    }
                    .onDelete(perform: vm.deleteFriend(offsets:))
                }
                .listStyle(PlainListStyle())
                
            } else {
                
                StatusView(status: vm.status, retryAction: {vm.fetchFriends()})
                
                
            }
            
            Spacer()
        }
        .foregroundColor(.primary)
        .onAppear(perform: {
            if isFirstload {
                vm.fetchFriends()
                isFirstload = false

            }
        })
        .onDisappear(perform: {
            if !vm.pushNav {
                print("Remove freinds")
                vm.friendsListner?.remove()
            }
        })

        
        //MARK: - navigation proprty
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Friends")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: !isMacOS ?  Button(action: {presentationMode.wrappedValue.dismiss()}) {
            Image(systemName:  "chevron.left")
                .foregroundColor(.primary)
        } : nil)
    }
}


struct FriendCell : View {
    let friend : FBUser
    
    var body: some View {
        
        HStack {
            
            WebImage(url: friend.avaterUrl)
                .resizable()
                .placeholder {
                    Circle().fill(Color.gray)
                }
                .frame(width: 60, height: 60)
                .clipShape(Circle())
            
            Spacer()
            
            Text(friend.name)
            
            Spacer()
            
        }
        .padding()
        .foregroundColor(.primary)
        
    }
}
