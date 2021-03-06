//
//  SearchUserView.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/02/28.
//

import SwiftUI
import SDWebImageSwiftUI

struct SearchUserView: View {
    
    @EnvironmentObject var userInfo : UserInfo
    @Environment(\.presentationMode) var presentationMode
    @StateObject var vm = SearchUserViewModel()
    
    var body: some View {
        VStack {
            HStack {
                
                Button(action: {presentationMode.wrappedValue.dismiss()}, label: {Image(systemName: "xmark")})
                    .padding(.leading)
                
                SearchField(searchText: $vm.seachText, action: {vm.searchUser(userInfo: userInfo)})
                    .padding(.vertical, 8)
            }
           
            
            Divider()
            
            Spacer()
            
            if vm.searchedUser == nil {
                Text("No User")
            } else {
                DetailUserView(user: $vm.searchedUser, buttonEnable: $vm.buttonEnable,messageAction: messageAction,followAction: followAction)
            }
            
            Spacer()
        }
        .foregroundColor(.primary)
        .preferredColorScheme(.dark)
        .alert(isPresented: $vm.showAlert) {
            vm.alert
        }
        .showHUD(isShowing: $vm.showHUD, Text("Add Friends!"))
    }
    
    
    //MARK: - messageAction
    
    private func messageAction() {
        vm.startPrivateChat(userInfo: userInfo) {
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    private func followAction() {
        vm.addFriend(userInfo: userInfo)
    }
}

struct SearchField : View {
    
    @Binding var searchText : String
    @State private var isSearchng : Bool = false
    
    var action : () -> Void
    
    var body: some View {
        HStack {
            
            HStack {
                TextField("Search", text: $searchText)
                    .autocapitalization(.none)
                    .padding(.leading,24)
                    .onTapGesture {
                        isSearchng = true
                    }
            }
            .padding()
            .background(Color(.systemGray3))
            .cornerRadius(12)
            .padding(.trailing)
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                    Spacer()
                    
                    if isSearchng {
                        Button(action: {
                            self.searchText = ""
                            self.isSearchng = false
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .padding(.vertical)
                        }
                    }
                }
                .padding(.leading,12)
                .padding(.trailing,32)
                .foregroundColor(.primary)
            )
            .transition(.move(edge: .trailing))
            .animation(.spring())
            
            if isSearchng {
                Button(action: {
                    action()
                }) {
                    Text("Search")
                        .foregroundColor(.primary)
                }
                .disabled(searchText == "" ? true : false)
                .padding(.trailing,24)
                .padding(.leading,0)
                .transition(.move(edge: .trailing))
                .animation(.spring())
            }
            
        }
    }
}

struct DetailUserView : View {

    @Binding var user : FBUser!
    @Binding var buttonEnable : Bool

    var messageAction : (() -> Void?)? = nil
    var followAction : (() -> Void?)? = nil
    
    var body: some View {
        
        VStack {
            WebImage(url: user.avaterUrl)
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
        .padding()
        
        VStack {
            Text(user.name)
                .bold()
                .font(.title)
            
        }
        .padding()
        .padding(.top,20)
        
        if user.isCurrentUser {
            Text("このユーザーはあなたです。")
            
        } else {
            HStack {
                Button(action: {
                    if followAction != nil {
                        followAction!()
                    }
                }, label: {
                    Text(user.isFriend ? "- Friend" : "+ Friend")
                        .frame(width: 150, height: 40)
                        .background(user.isFriend ? Color.red : Color.blue)
                        .foregroundColor(.white)
                })
                .cornerRadius(20)
                .opacity(!buttonEnable ? 0 : 1)
                .disabled(!buttonEnable)
                
                Button(action: {
                    if messageAction != nil {
                        messageAction!()
                    }
                    
                }, label: {
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
struct SearchUserView_Previews: PreviewProvider {
    static var previews: some View {
        SearchUserView()
    }
}
