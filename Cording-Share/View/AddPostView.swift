//
//  NewPostView.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2020/12/30.
//

import SwiftUI
import CodeMirror_SwiftUI


struct AddPostView: View {
    
    @EnvironmentObject var userInfo : UserInfo
    @StateObject var vm = AddPostViewModel()
    
    @State private var mode : CodeMode = CodeMode.swift
    
    var body: some View {
        
        if !vm.fullScreen {
            ZStack {
                /// Z1
                VStack {
                    HStack {
                        Button(action: {vm.fullScreenMode(userInfo: userInfo)}, label: {
                            Image(systemName: "arrow.up.left.and.arrow.down.right")
                                .font(.system(size: 24))
                                .foregroundColor(.primary)
                        })
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation(.spring()) {
                                vm.toggleSideMenu(userInfo: userInfo)
                            }
                        }, label: {
                            Image(systemName: "line.horizontal.3")
                                .font(.system(size: 24))
                                .foregroundColor(.primary)
                        })
                    }
                    .padding()
                    .padding(.top , 6)
                    .background(Color.clear)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    
                    CodeView(theme: userInfo.theme, code: $vm.text, mode: mode.mode(), fontSize: 12, showInvisibleCharacters: false, lineWrapping: false)
                }
                
                /// Z2 (SideMenu)
                
                SideMenu(vm: vm)
                
            }
            
        } else {
            
            ZStack {
                
                CodeView(theme: userInfo.theme, code: $vm.text, mode: mode.mode(), fontSize: 12, showInvisibleCharacters: false, lineWrapping: false)
                
                
                VStack {
                    Spacer()
                    
                    HStack {
                        
                        Spacer()
                        Button(action: {vm.fullScreenMode(userInfo: userInfo)}, label: {
                            Image(systemName: "arrow.down.right.and.arrow.up.left")
                               .font(.system(size: 24))
                               .foregroundColor(.primary)
                        })
                        .padding()
                    }
                }
               
            }
        }
  
    }
}

struct NewPostView_Previews: PreviewProvider {
    static var previews: some View {
        AddPostView()
    }
}


//MARK: - sideMenu

struct SideMenu : View {
    
    @EnvironmentObject var userInfo : UserInfo
    @StateObject var vm : AddPostViewModel
    
    let width = UIScreen.main.bounds.width
    
    var body: some View {
        
        
        HStack(spacing :20) {
            Spacer()
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button(action: {
                            withAnimation(.spring()) {
                                vm.toggleSideMenu(userInfo: userInfo)
                            }}, label: {
                                Image(systemName: "xmark")
                                    .font(.system(size: 22,weight : .bold))
                                    .foregroundColor(.black)
                            })
                }
                .padding()
                .padding(.top,4)
                
                VStack(spacing :4) {
                    
                    Picker(selection: $userInfo.modeIndex, label: Text(""), content: {
                        ForEach(0 ..< userInfo.modes.count) { i in
                            
                            Text("\(CodeMode.list()[userInfo.modeIndex])")
                        }
                    })
                    Text("Font Size")
                        .underline()
                    
                    Picker(selection: $userInfo.fontSize, label: Text(""), content: {
                        ForEach(4 ..< 25, id : \.self) { i in
                            Text("\(i)")
                                .foregroundColor(.black)
                        }
                    })
                    .labelsHidden()
                    
                    Text("Code Theme")
                        .underline()
                    
                    Picker(selection: $userInfo.themeIndex, label: Text(""), content: {
                        ForEach(0 ..< userInfo.themes.count ) { i in
                            Text("\(userInfo.themes[i].rawValue)")
                                .foregroundColor(.black)
                            
                        }
                    })
                    .labelsHidden()
                    
                }
                .foregroundColor(.black)
                .padding(.top)
                .padding(.leading,40)
                
                Spacer()
                
            }
            .frame(width: width - 100)
            .background(Color.gray)
            .offset(x: vm.showSideMenu ? 0 : width - 100)
        }
        .background(Color.black.opacity(vm.showSideMenu ? 0.3 : 0).onTapGesture {
            withAnimation(.spring()) {
                vm.toggleSideMenu(userInfo: userInfo)
            }
            
        })
    }
}


//Button(action: {
//                        guard let data = text.data(using: .utf8) else {return}
//
//                    print(String(data: data, encoding: .utf8)!)
//                        }, label: {
//                    /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
//                })
