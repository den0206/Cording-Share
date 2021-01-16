//
//  MainTabView.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2020/12/31.
//

import SwiftUI

struct MainTabView: View {
    
    @EnvironmentObject var userInfo : UserInfo
    
    var body: some View {
        VStack {
            ZStack {
                switch userInfo.tabIndex {
                case 0 :
                    FeedView()
                case 1 :
                    AddPostView()
                case 2 :
                    RecentsView()
                case 3 :
                    UserProfileView(user: userInfo.user)
                default:
                    Color.secondary.colorInvert()
                    Text("No View")
                }
            }
            
            if userInfo.showTab {
                CustomTab(index: $userInfo.tabIndex)
                    .frame(height: 70)
                    .animation(.spring())
            }
        }
        .Loading(isShowing: $userInfo.loading)
        .showHUD(isShowing: $userInfo.showHUD)
        .edgesIgnoringSafeArea(.all)
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}

struct CustomTab : View {
    
    @Binding var index : Int
    
    var body: some View {
        
        HStack {
            tabButton(function: {index = 0}, systemImageName: "doc.richtext", title: "View", number: 0, index: index)
            
            Spacer(minLength : 15)
            
            tabButton(function: {index = 1}, systemImageName: "chevron.left.slash.chevron.right", title: " Post", number: 1, index: index)

            Spacer(minLength: 15)
            
            tabButton(function: {index = 2}, systemImageName: "message.circle", title: "Message", number: 2, index: index)
            
            Spacer(minLength : 15)
            
            tabButton(function: {index = 3}, systemImageName: "person.crop.circle", title: "Profile", number: 3, index: index)

        }
        .padding(.top,-10)
        .padding(.horizontal,25)
        .background(Color(.systemGroupedBackground))
        
    }
}

struct tabButton : View {
    
    var function : () ->Void
    var systemImageName : String
    var title : String
    var number : Int
    var index : Int
    
    var body: some View {
        
        VStack {
            Button(action: {function()}) {
                
                if index != number {
                   Image(systemName: systemImageName)
                    .font(.system(size: 22))
                    .foregroundColor(.gray)
                    .padding(.top,3)
                } else {
                    Image(systemName: systemImageName)
                        .frame(width: 25, height: 23)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .offset(y: -5)
                }
            }
            
            Text(title)
                .foregroundColor(Color.primary.opacity(0.8))
        }
    }
}


//systemImageName: "gearshape",
