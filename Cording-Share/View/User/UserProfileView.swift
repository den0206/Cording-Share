//
//  UserProfileView.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/01/14.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserProfileView: View {
    
    @EnvironmentObject var userInfo : UserInfo
    let user : FBUser
    
   
    var body: some View {
        
        NavigationView {
            
                VStack(spacing : 8) {
                    
                    WebImage(url: user.avaterUrl)
                        .resizable()
                        .placeholder{
                            Circle().fill(Color.gray)
                        }
                        .scaledToFill()
                        .clipped()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                    
                    Text(user.name)
                        .font(.system(size: 16,weight : .semibold))
                    
                    
                    ProfileActionButtonView(isCurrentUser: user.isCurrentUser)
                      
                    Divider()
                        .background(Color.primary)
                    
                    Spacer()
                }
                .padding()
                
                .navigationBarHidden(true)
                .navigationBarTitleDisplayMode(.inline)
        }
        
        
    }
    
    
}

struct ProfileActionButtonView: View {
    
    let isCurrentUser : Bool
    
    var body: some View {
        
        if isCurrentUser {
            NavigationLink(destination: UserEditView()) {
                Text("EditProfile")
                    .frame(width: 240, height: 40)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(20)
            }
        
        } else {
            HStack {
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Text("Follow")
                        .frame(width: 150, height: 40)
                        .background(Color.blue)
                        .foregroundColor(.white)
                })
                .cornerRadius(20)
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Text("Message")
                        .frame(width: 150, height: 40)
                        .background(Color.purple)
                        .foregroundColor(.white)
                })
                .cornerRadius(20)
            }
            
        }
        
    }
}


struct UserProfileView_Previews: PreviewProvider {
    

    static var previews: some View {
        UserProfileView(user: FBUser(uid: "", name: "", email: ""))
    }
}
