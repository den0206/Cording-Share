//
//  UserEditView.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/01/10.
//

import SwiftUI
import SDWebImageSwiftUI
import CodeMirror_SwiftUI

struct UserEditView: View {
  
    @EnvironmentObject var userInfo : UserInfo
    @State private var user = AuthUserViewModel()
    
    @State private var showPicker = false
    @State private var showAlert = false
    @State private var alert : Alert = Alert(title: Text("")) {
        didSet {
            showAlert.toggle()
        }
    }
    
    var body: some View {
        
            ScrollView {
                
                Spacer().frame(height: 30)
                
                
                Button(action: {showPicker.toggle()}) {
                    
                    if  user.imageData.count != 0 {
                        Image(uiImage: UIImage(data: user.imageData)!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                    } else {
                        
                    WebImage(url: userInfo.user.avaterUrl)
                        .resizable()
                        .placeholder {
                            Circle().fill(Color.gray)
                        }
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                    }
                }
                .padding(.vertical,10)
                .sheet(isPresented: $showPicker) {
                    ImagePicker(image: $user.imageData)
                }
                
                
                VStack {
                    CustomTextField(text: $user.fullname, placeholder: "Fullname", imageName: "person")
                        .onAppear {
                            user.fullname = userInfo.user.name
                        }
                    
                    
                    ValitationText(text: user.validNameText, confirm: !user.validNameText.isEmpty)
                    
                    
                    CustomTextField(text: $user.email, placeholder: "Email", imageName: "envelope")
                        .onAppear {
                            user.email = userInfo.user.email
                        }
                    
                    
                    ValitationText(text: user.validEmailText, confirm: !user.validEmailText.isEmpty)
                
                }
                .padding()
                
       
                VStack(spacing : 15) {

                    CustomButton(title: "Save", disable: user.didChangeStatus, action: {
                        
                        userInfo.loading = true
                        
                        FBAuth.editUser(currentUser: userInfo.user, vm: user) { (result) in
                            
                            switch result {
                            
                            case .success(let user):
                                self.userInfo.user = user
                                self.user.currentUser = user
                                
                            case .failure(let error):
                                alert = errorAlert(message: error.localizedDescription)
                            }
                            
                            userInfo.loading = false

                        }
                    })

                    CustomButton(title: "Log Out", disable: true, backColor: .red, action: {
                        alert = Alert(title: Text("確認"), message: Text("ログアウトしますか?"), primaryButton: .cancel(Text("キャンセル")), secondaryButton: .default(Text("OK"), action: {
                            
                            logOut()
                        }))
                    })
                }

                Spacer()
                
            }
            .onAppear {
                user.currentUser = userInfo.user
            }
            .alert(isPresented: $showAlert, content: {
                alert
            })

    }
    
    //MARK: - Funcions
    
    private func logOut() {
        
        FBAuth.logOut { (result) in
            switch result {
            
            case .success(let bool):
                print("Success, \(bool)")
                self.userInfo.user = FBUser(uid: "", name: "", email: "")
                self.userInfo.isUserauthenticated = .signOut
            case .failure(let error):
                
                print(error.localizedDescription)
            }
        }
        
    }
}

struct UserEditView_Previews: PreviewProvider {
    static var previews: some View {
        UserEditView()
    }
}

//NavigationView {
//
//    Form {
//        Section {
//
//            Picker(selection: $userInfo.modeIndex, label: Text("Lang"), content: {
//                ForEach(0 ..< userInfo.modes.count ) { i in
//                    Text("\(userInfo.modes[i].rawValue)")
//                }
//            })
//
//
//            Picker(selection: $userInfo.fontSize, label: Text("Font Size"), content: {
//                ForEach(4 ..< 25, id : \.self) { i in
//                    Text("\(i)")
//                }
//            })
//
//            Picker(selection: $userInfo.themeIndex, label: Text("Code Theme"), content: {
//                ForEach(0 ..< userInfo.themes.count ) { i in
//                    Text("\(userInfo.themes[i].rawValue)")
//
//                }
//            })
//
//        }
//    }
//}
