//
//  SettingsView.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/02/14.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var userInfo : UserInfo

    var body: some View {
        NavigationView {
            
            Form {
                Section{
                    Picker(selection: $userInfo.themeIndex, label: Text("テーマ")) {
                        ForEach(0 ..< userInfo.themes.count ) { i in
                            Text("\(userInfo.themes[i].rawValue)")
                                .foregroundColor(.primary)
                            
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                }

                
                Section{
                    
                    Picker(selection: $userInfo.fontSize, label: Text("文字サイズ"), content: {
                        ForEach(4 ..< 25, id : \.self) { i in
                            Text("\(i)")
                                .foregroundColor(.primary)
                        }
                    })
                    .pickerStyle(WheelPickerStyle())
                }
            }
        
            .navigationBarHidden(true)
        }
        .navigationBarHidden(true)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
