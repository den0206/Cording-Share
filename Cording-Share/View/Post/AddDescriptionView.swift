//
//  AddDescriptionView.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/01/09.
//

import SwiftUI
import SDWebImageSwiftUI

struct AddDescriptionView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userInfo : UserInfo
    @StateObject var vm : AddPostViewModel
    
    var body: some View {
        
        ZStack {
            
            /// Z1
            VStack {
                
                Label {
                    Text(userInfo.mode.rawValue)
                        .font(.title2)
                } icon: {
                    userInfo.mode.image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                        .clipShape(Circle())
                }
                .padding(.top,5)
                
                
                
                Divider()
                    .background(Color.primary)
                
                
                HStack(alignment: .top) {
                    WebImage(url: userInfo.user.avaterUrl)
                        .resizable()
                        .placeholder{
                            Rectangle().fill(Color.gray)
                        }
                        .scaledToFill()
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                    
                    TextArea(text: $vm.description, placeholder: "Add Comment")
                
                }
                .padding(.horizontal)
            
                
                Spacer()
            }
            
            /// Z2
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    
                    PushButton(vm: vm, action: {
                        vm.submitCode(userInfo: userInfo)
                    })
                }
                .padding()
            }
        }
        
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {presentationMode.wrappedValue.dismiss()}, label: {
            Image(systemName: "chevron.left")
                .foregroundColor(.primary)
        })
        )
    }
}

//MARK: - Submit Button
struct PushButton : View {
    
    @EnvironmentObject var userInfo : UserInfo
    @StateObject var vm : AddPostViewModel
    
    var action : () -> Void
    
    var body: some View {
        
        Button(action: {action()}) {
            Text("Push")
                .font(.caption2)
                .foregroundColor(.white)
                .frame(width: 55, height: 55)
                .background(vm.buttonColor)
                .clipShape(Circle())
        }
        .padding()
        
        
        
    }
}



