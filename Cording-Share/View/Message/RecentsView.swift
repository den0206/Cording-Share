//
//  RecentsView.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/01/16.
//

import SwiftUI

struct RecentsView: View {
    var body: some View {
        NavigationView {
            
            VStack {
                Text("Recents")
                
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
