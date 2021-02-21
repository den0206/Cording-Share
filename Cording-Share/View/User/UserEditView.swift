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
    @Environment(\.presentationMode) var presentationMode
    @State private var user = AuthUserViewModel()
    @State private var filePicker : DocumentPicker?

    
    @State private var showPicker = false
    @State private var showAlert = false
    @State private var alert : Alert = Alert(title: Text("")) {
        didSet {
            showAlert.toggle()
        }
    }
    
    var body: some View {
        
            ScrollView {
                
                HStack {
                    
                    if !isMacOS {
                        Button(action: {presentationMode.wrappedValue.dismiss()}) {
                            Image(systemName: "arrowshape.turn.up.backward")
                                .foregroundColor(.primary)
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                
                Spacer().frame(height: 30)
                
                Button(action: {
                    if !isMacOS {
                        showPicker.toggle()
                    } else {
                        presentDocumentPicker()
                    }
                    
                }) {
                    
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
                    if !isMacOS {
                        ImagePicker(image: $user.imageData)

                    }
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
                        print(userInfo.loading)
                        FBAuth.editUser(currentUser: userInfo.user, vm: user) { (result) in
                            
                            switch result {
                            
                            case .success(let user):
                                self.userInfo.user = user
                                self.user.currentUser = user
                                
                            case .failure(let error):
                                print(error.localizedDescription)
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
            .preferredColorScheme(.dark)
            .onAppear {
                user.currentUser = userInfo.user
                filePicker = DocumentPicker({ (img) in
                    user.imageData = img
                })
            }
            .alert(isPresented: $showAlert, content: {
                alert
            })
        
            .navigationBarHidden(true)
            .navigationBarTitleDisplayMode(.inline)

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
    
    func presentDocumentPicker() {
       
        guard let filePicker = filePicker else {return}
        
        let viewController = UIApplication.shared.windows[0].rootViewController!
        let controller = filePicker.vc
        viewController.present(controller, animated: true, completion: nil)
        
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
