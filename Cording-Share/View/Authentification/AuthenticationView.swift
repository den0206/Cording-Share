//
//  AuthenticationView.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/02/13.
//

import SwiftUI

struct AuthenticationView: View {
    
    @State private var loading = false
    
    var body: some View {
        
        if isMacOS {
            HStack {
                LoginView(isLoading: $loading)
                
                LoopBackgroundView()

            }
            .Loading(isShowing: $loading)
        } else {
            LoginView(isLoading: $loading)
        }
        
     
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
    }
}
