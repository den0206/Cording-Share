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
                
                LoopBackgroundView()

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
