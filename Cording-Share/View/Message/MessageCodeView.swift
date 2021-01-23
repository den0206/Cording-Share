//
//  MessageCodeView.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/01/23.
//

import SwiftUI

struct MessageCodeView: View {
    
    @EnvironmentObject var userInfo : UserInfo
    @Environment(\.presentationMode) var presentationMode
    @StateObject var vm : MessageViewModel
    
    var body: some View {
        
        ZStack {
            VStack {
                HStack {
                    Button(action: {
                        vm.text = ""
                        presentationMode.wrappedValue.dismiss()
                        
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 24))
                    }
                    
                    Spacer()
                    
                    TextIconView(text: userInfo.mode.rawValue, image: userInfo.mode.image)
                    
                    Spacer()
                    
                }
                .padding()
                .padding(.top , 6)
                .foregroundColor(.primary)
                .background(Color.clear)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                
                ExampleView(code: $vm.text, lang: userInfo.mode,withImage : false)
                
                Spacer()
            }
            .foregroundColor(.primary)
            .preferredColorScheme(.dark)
            
            
        }
      
    }
}


