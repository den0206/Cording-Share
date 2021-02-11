//
//  EditPostView.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/01/13.
//

import SwiftUI

struct EditPostView: View {
   
    @EnvironmentObject var userInfo : UserInfo

    @Environment(\.presentationMode) var presentationMode
    @StateObject var vm = AddPostViewModel()
    var post : Post
    
    var body: some View {
        
  
            ZStack {
                
                if !vm.fullScreen {
                    
                    /// Z1
                    VStack {
                        HStack {
                            
                            Button(action:{presentationMode.wrappedValue.dismiss()}) {
                                Image(systemName: "chevron.left")
                                    
                            }
                            Button(action: {vm.fullScreenMode(userInfo: userInfo)}, label: {
                                Image(systemName: "arrow.up.left.and.arrow.down.right")
                                    .font(.system(size: 24))
                                
                            })
                            
                            Spacer()
                            
                            
                            TextIconView(mode: post.lang)
                                .onTapGesture {
                                    vm.showSelectView = true
                                }
                             
                            Spacer()
                            
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
                        
                        
                        ExampleView(code: $vm.text, lang: post.lang,withImage : false)
                            .onAppear {
                                vm.text = post.codeBlock
                            }
                    
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
                                    EditCommitButton(vm: vm)
                                }
                                .disabled(vm.text.isEmpty || !vm.didChangeStatus)
                                .padding()
                                
                            }
                          
                        }
                    }
                    
                    
                    
                    
                } else {
                    
                    /// Z1
                    ExampleView(code: $vm.text,  lang: post.lang,withImage : false)
                        .onAppear {
                            vm.text = post.codeBlock
                        }
                    
                    /// Z2
                    VStack {
                        Spacer()
                        
                        HStack {
                            
                            Spacer()
                            
                            NavigationLink(destination: AddDescriptionView(vm: vm)) {
                                EditCommitButton(vm: vm)
                            }
                            .disabled(vm.text.isEmpty || !vm.didChangeStatus)
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
            .onAppear(perform: {
                vm.editPost = post
            })
            
           
        
   
    }
    
}

//MARK: - Edit Button

struct EditCommitButton :View {
    
    @StateObject var vm : AddPostViewModel
    
    var body: some View {
        Text("Commit")
            .font(.caption2)
            .foregroundColor(.white)
            .frame(width: 55, height: 55)
            .background(vm.text.isEmpty || !vm.didChangeStatus ? Color.gray : Color.green)
            .opacity(vm.text.isEmpty || !vm.didChangeStatus  ? 0.3 : 1)
            .clipShape(Circle())
    }
}
