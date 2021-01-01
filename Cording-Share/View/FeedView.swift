//
//  FeedView.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/01/01.
//

import SwiftUI

struct FeedView: View {
    
    @StateObject var vm = FeedViewModel()
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                Text("Feed")
                    .foregroundColor(.black)
                
            }
            .sheet(isPresented: $vm.showAddView, content: {
                AddPostView()
            })
            /// navigation Property
            
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(action: {vm.showAddView = true}, label: {
                Image(systemName: "plus")
                    .font(.system(size: 30))
                    .foregroundColor(.black)
                   
            }))
        }
       
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
