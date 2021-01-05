//
//  FeedView.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/01/01.
//

import SwiftUI

struct FeedView: View {
    
    @EnvironmentObject var userInfo : UserInfo

    @StateObject var vm = FeedViewModel()
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                Text("Feed")
                    .foregroundColor(.primary)
                
            }
            .alert(isPresented: $vm.showalert, content: {
                
                Alert(title: Text("Error"), message: Text(vm.errorMessage), dismissButton: .default(Text("OK")))
            })
            .onAppear {
                vm.fetchPosts(userId: userInfo.user.uid)
            }
           
        
        }
       
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
