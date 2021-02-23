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
                .progressViewStyle(CircularProgressViewStyle(tint: Color.green))
                .foregroundColor(.green)
                .padding()
                .transition(AnyTransition.fade(duration: 0.5))
        } else {
            NavigationView {
                
                VStack {
                    
                    Rectangle()
                        .foregroundColor(.gray)
                        .edgesIgnoringSafeArea(.top)
                        .frame( height: 200)
                        .overlay(
                            VStack {
                                HStack {
                                    if isSheet {
                                        Button(action: {presentationMode.wrappedValue.dismiss()}) {
                                            Image(systemName: "chevron.left")
                                                .foregroundColor(.primary)
                                        }
                                        .padding()
                                        
                                    }
                                    
                                    
                                    Spacer()
                                }
                                Spacer()
                            }
                            
                        )
                    
                    
                    VStack {
                        WebImage(url: vm.user!.avaterUrl)
                            .resizable()
                            .placeholder{
                                Circle().fill(Color.gray)
                            }
                            .scaledToFill()
                            .clipped()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white,lineWidth: 4))
                            .shadow(color: .primary, radius: 10)
                    }
                    .offset(y: -100)
                    .padding(.bottom, -110)
                    
                    VStack {
                        Text(vm.user!.name)
                            .bold()
                            .font(.title)
                    }
                    .padding()
                    
                    .padding(.top,20)
                
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
                                
                                
                            }, label: {
                                Text("Message")
                                    .frame(width: 150, height: 40)
                                    .background(Color.purple)
                                    .foregroundColor(.white)
                            })
                            .cornerRadius(20)
                        }
                        
                    }
          
                    Spacer()
                }
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


