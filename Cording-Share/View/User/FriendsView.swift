//
//  FriendsView.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/03/06.
//

import SwiftUI

struct FriendsView : View {
    @EnvironmentObject var userInfo : UserInfo
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var vm : FriendsViewModel
  
    
    var body: some View {
        
        VStack {
        
            if vm.friends.isEmpty {
                Spacer()
                Text("No Friends")
            } else {
                List{
                    ForEach(vm.friends, id : \.uid) { friend in
                        
                        Text(friend.name)
                            .foregroundColor(.primary)
                    }
                }
                
            }
          
            Spacer()
        }
        .foregroundColor(.primary)
        .onAppear(perform: {
            vm.fetchFriends()
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
