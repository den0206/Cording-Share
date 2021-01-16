//
//  UserProfileView.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/01/14.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserProfileView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userInfo : UserInfo
    
    @StateObject var vm : UserProfileViewModel
    var isSheet : Bool = false
    
    var body: some View {
        
        if vm.user == nil {
            ProgressView("Loading...")
                .foregroundColor(.primary)
        } else {
            NavigationView {
                
                VStack(spacing : 8) {
                    
                    if isSheet {
                        HStack {
                            
                            Button(action: {presentationMode.wrappedValue.dismiss()}) {
                                Image(systemName: "xmark")
                                    .foregroundColor(.primary)
                            }
                            
                            Spacer()
                        }.padding()
                        
                    }
                  
                    WebImage(url: vm.user!.avaterUrl)
                        .resizable()
                        .placeholder{
                            Circle().fill(Color.gray)
                        }
                        .scaledToFill()
                        .clipped()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                    
                    Text(vm.user!.name)
                        .font(.system(size: 16,weight : .semibold))
                    
                    
                    if vm.user!.isCurrentUser {
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
                            
                            Button(action: {
                                
                                vm.startPrivateChat(userInfo: userInfo)
//                                DispatchQueue.main.async {
//                                    userInfo.tabIndex = 2
//                                    userInfo.MSGPushNav = true
//                                }
                                
                            }, label: {
                                Text("Message")
                                    .frame(width: 150, height: 40)
                                    .background(Color.purple)
                                    .foregroundColor(.white)
                            })
                            .cornerRadius(20)
                        }
                        
                    }
                    
                    Divider()
                        .background(Color.primary)
                    
                    Spacer()
                }
                .padding()
                
                .navigationBarHidden(true)

                
            }
         
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarHidden(true)
        
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
        UserProfileView(vm: UserProfileViewModel(user: FBUser(uid: "", name: "", email: "")))
    }
}


