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
    
    var isFromMessage : Bool = false
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
                    
                    VStack(spacing : 4) {
                        Text(vm.user!.name)
                            .bold()
                            .font(.title)
                        
                        Text("Search ID")
                        
                        Text(vm.user.searchId == "" ? "No SearchID" : vm.user.searchId)
                        
                    }
                    .padding()
                    
                    .padding(.top,20)
                
                    if vm.user!.isCurrentUser {
                        
                        HStack {
                            NavigationLink(destination: UserEditView()) {
                                Text("EditProfile")
                                    .modifier(ProfileButtonModifier(color: Color.green))
                                    .cornerRadius(20)
                            }
                            
                            NavigationLink(destination: FriendsView(vm : FriendsViewModel(user: vm.user))) {
                                
                                Text("Friends")
                                    .modifier(ProfileButtonModifier(color: Color.blue))
                                    .cornerRadius(20)
                            }
                        }
                      
                        
                        
                        
                    } else {
                        HStack {
                            Button(action: {vm.addfriend(userInfo: userInfo)}, label: {
                                Text(vm.user.isFriend ? "- Follow" : "+ Friend")
                                    .modifier(ProfileButtonModifier(color: vm.user.isFriend ? Color.red : Color.blue))
                            })
                            .cornerRadius(20)
                            .opacity(!vm.buttonEnable ? 0 : 1)
                            .disabled(!vm.buttonEnable)
                            .onAppear {
                                if !vm.didAppear {
                                    vm.checkFriend(userInfo: userInfo)
                                    vm.didAppear = true
                                }
                            }
                            
                            Button(action: {
                                if !isFromMessage {
                                    vm.startPrivateChat(userInfo: userInfo)
                                } else {
                                    presentationMode.wrappedValue.dismiss()
                                }
                                
                                
                            }, label: {
                                Text("Message")
                                    .modifier(ProfileButtonModifier(color: Color.green))
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

//MARK: - Custom Modifier

struct ProfileButtonModifier : ViewModifier {
    
    let color : Color
    
    func body(content: Content) -> some View {
        content
            .frame(width: 150, height: 40)
            .background(color)
            .foregroundColor(.white)
    }
}

struct UserProfileView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        UserProfileView(vm: UserProfileViewModel(user: FBUser(uid: "", name: "", email: "", fcmToken: "", searchId: "")))
    }
}


