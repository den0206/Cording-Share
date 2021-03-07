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
                            Image(systemName:  "chevron.left")
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
                                alert = errorAlert(message: error.localizedDescription)
                                
                                if error as? FirestoreError == FirestoreError.duplicateName {
                                    
                                    user.fullname = user.currentUser?.name ?? ""
                                }
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
        
        
        FBAuth.logOut(userInfo : userInfo) { (result) in
            switch result {
            
            case .success(let bool):
                print("Success, \(bool)")
                self.userInfo.user = FBUser(uid: "", name: "", email: "", fcmToken: "", searchId: "")
                self.userInfo.configureStateDidChange()
//                self.userInfo.isUserauthenticated = .signOut
            case .failure(let error):
                print("Error")
                self.alert = errorAlert(message: error.localizedDescription)
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

