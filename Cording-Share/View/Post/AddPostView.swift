//
//  NewPostView.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2020/12/30.
//

import SwiftUI

struct AddPostView: View {
    
    
    @EnvironmentObject var userInfo : UserInfo
    @StateObject var vm = AddPostViewModel()

    var body: some View {
        
        NavigationView {
            ZStack {
                
                if !vm.fullScreen {
                    
                    /// Z1
                    VStack {
                        HStack {
                            
                            Button(action: {vm.fullScreenMode(userInfo: userInfo)}, label: {
                                Image(systemName: "arrow.up.left.and.arrow.down.right")
                                    .font(.system(size: 24))
                                
                            })
                            
                            Spacer()
                            
                            
                            TextIconView(mode: userInfo.mode)
                           
                            Spacer()
                            
                            Button(action: {vm.showSelectView = true}) {
                                Image(systemName: "chevron.left.slash.chevron.right")
                                
                            }
                            
                            Button(action: {
                                withAnimation(.spring()) {
                                    vm.toggleSideMenu(userInfo: userInfo)
                                }
                            }, label: {
                                Image(systemName: "line.horizontal.3")
                                    .font(.system(size: 24))
                            })
                        }
                        .padding()
                        .padding(.top , 6)
                        .foregroundColor(.primary)
                        .background(Color.clear)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                        .sheet(isPresented: $vm.showSelectView) {
                            SelecteLanguageView()
                        }
                        
                        
                        ExampleView(code: $vm.text, lang: userInfo.mode,withImage : false)
                    
                    }
                    
                    
                    
                    /// Z2 (SideMenu)
                    
                    SideMenu(vm: vm)
                    
                    /// Z3
                    
                    if !vm.showSideMenu {
                        VStack {
                            Spacer()
                            
                            HStack {
                                Spacer()
                                NavigationLink(destination: AddDescriptionView(vm: vm)) {
                                    CommitButton(text: $vm.text)
                                }
                                .disabled(vm.text.isEmpty)
                                .padding()
                            
                            }
                          
                        }
                    }
                    
                    
                    
                    
                } else {
                    
                    /// Z1
                    ExampleView(code: $vm.text, lang: userInfo.mode,withImage : false)
                    
                    /// Z2
                    VStack {
                        Spacer()
                        
                        HStack {
                            
                            Spacer()
                            
                            NavigationLink(destination: AddDescriptionView(vm: vm)) {
                                CommitButton(text: $vm.text)
                            }
                            .disabled(vm.text.isEmpty)
                            .padding()
                        
                          
                         
                            Button(action: {vm.fullScreenMode(userInfo: userInfo)}, label: {
                                Image(systemName: "arrow.down.right.and.arrow.up.left")
                                    .font(.system(size: 24))
                                    .foregroundColor(.primary)
                            })
                            
                        }
                        .padding()
                    }
                    
                    
                }
            }
            .alert(isPresented: $vm.showAlert) {
                vm.alert
            }
            
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
        }
   
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

//MARK: - Submit Button
struct CommitButton : View {
    
    @Binding var text : String

    
    var buttonColor : Color {
        if text.isEmpty {
            return Color.gray
        } else {
            return Color.green
        }
    }
    
    var body: some View {
      
                Text("Commit")
                    .font(.caption2)
                    .foregroundColor(.white)
                    .frame(width: 55, height: 55)
                    .background(buttonColor)
                    .opacity(text.isEmpty ? 0.3 : 1)
                    .clipShape(Circle())
 
                
    }
}




