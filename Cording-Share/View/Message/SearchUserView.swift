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
    @StateObject var vm = SearchUserViewModel()
    
    var body: some View {
        VStack {
            
            SearchField(searchText: $vm.seachText, action: {vm.searchUser()})
                .padding(.vertical, 8)
            
            Divider()
            
            Spacer()
            if vm.searchedUser == nil {
                Text("No User")
            } else {
                DetailUserView(user: vm.searchedUser!)
            }
            
            Spacer()
        }
        .foregroundColor(.primary)
        .preferredColorScheme(.dark)
        .alert(isPresented: $vm.showAlert) {
            vm.alert
        }
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
            .padding(.horizontal)
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
                .padding(.horizontal,32)
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
    
    let user : FBUser
    
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
                    
                    print("Message")
                    
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
