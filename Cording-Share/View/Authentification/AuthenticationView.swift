//
//  AuthenticationView.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/02/13.
//

import SwiftUI

struct AuthenticationView: View {
    var body: some View {
        
        if isMacOS {
            HStack {
                LoginView()
                    .frame( maxWidth: .infinity, maxHeight: .infinity)
                
                Divider()
                
                VStack {
                    Spacer()
                }
                .frame(width: (getScreenSize.width / 1.8) / 2)

            }
        } else {
            LoginView()
        }
        
     
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
