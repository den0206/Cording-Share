//
//  RecentsView.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/01/16.
//

import SwiftUI

struct RecentsView: View {
    @EnvironmentObject var userInfo : UserInfo

    var body: some View {
        NavigationView {
            
            VStack {
                
                NavigationLink(destination: MessageView(), isActive: $userInfo.MSGPushNav) {
                    Text("Recents")
                }
              
                
                Spacer()
            }
            
            .navigationBarTitle(Text("Messages"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct RecentsView_Previews: PreviewProvider {
    static var previews: some View {
        RecentsView()
    }
}
