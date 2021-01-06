//
//  SignUpView.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2020/12/30.
//

import SwiftUI

struct SignUpView: View {
    
    @EnvironmentObject var userInfo : UserInfo
    @Environment(\.presentationMode) var presentationMode
    
    @State private var user = AuthUserViewModel()
    @State private var showPicker = false
    
    @State private var errorMessage = ""
    @State private var showAlert = false
    @State private var isLoading = false
    
    var body: some View {
        
        NavigationView {
            
            ScrollView(.vertical, showsIndicators: false, content: {
                
                if !user.selectedImage() {
                    Text(user.validImageText).font(.caption).foregroundColor(.red)
                        .padding(.top,10)
                }
                
                Button(action: {showPicker = true}) {
                    
                    if user.imageData.count == 0 {
                        
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .foregroundColor(.gray)
                    } else {
                        
                        Image(uiImage: UIImage(data: user.imageData)!)
                            .resizable().scaledToFill().clipShape(Circle())
                    }
                  
                }
                .frame(width: 140, height: 140)
                .padding(.vertical, 15)
                .sheet(isPresented: $showPicker) {
                    ImagePicker(image: $user.imageData)
                }
                
                Spacer()
                
                VStack {
                    
                    CustomTextField(text: $user.fullname, placeholder: "Fullname", imageName: "person")
                    
                    ValitationText(text: user.validNameText, confirm: !user.validNameText.isEmpty)
                    
                    
                    CustomTextField(text: $user.email, placeholder: "Email", imageName: "envelope")
                    
                    
                    ValitationText(text: user.validEmailText, confirm: !user.validEmailText.isEmpty)
                    
                    
                    CustomTextField(text: $user.password, placeholder: "Password", imageName: "lock",isSecure: true)
                    
                    
                    ValitationText(text: user.validPasswordText,confirm: !user.validPasswordText.isEmpty)
                    
                    
                    CustomTextField(text: $user.confirmPassword, placeholder: "Password confirmation", imageName: "lock",isSecure: true)
                    
                    
                    ValitationText(text: user.validConfirmPasswordText,confirm: !user.passwordMatch(_confirmPass: user.confirmPassword) )
                    
                    
                    Button(action: {registerUser()}) {
                        Text("Register")
                            .foregroundColor(.white)
                            .padding(.vertical,15)
                            .frame(width: 200)
                            .background(Color.green)
                            .cornerRadius(8)
                            .opacity(user.isSignupComplete ? 1 : 0.3)
                    }
                    .disabled(!user.isSignupComplete)
                    .padding()
                    .alert(isPresented: $showAlert, content: {
                        errorAlert(message: errorMessage)
                    })
                    
                }
                
                Spacer()
                
            })
            /// navigation Property
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(action: {presentationMode.wrappedValue.dismiss()}, label: {
                Image(systemName: "xmark")
                    .foregroundColor(.black)
            }))
        }
        .Loading(isShowing: $isLoading)
        .onTapGesture(perform: {
            hideKeyBord()
        })
    }
    
    
    //MARK: - create
    
    private func registerUser() {
        
        isLoading = true
        
        FBAuth.createUser(email: user.email, name: user.fullname, password: user.password, imageData: user.imageData) { (result) in

            switch result {

            case .success(let user):
                self.userInfo.user = user
            case .failure(let error):
                errorMessage = error.localizedDescription
                showAlert = true
            }
            
            isLoading = false
            
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}

//MARK: - ImagePicker

struct ImagePicker : UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var image : Data
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> some UIImagePickerController {
        
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
        
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    
    class Coordinator : NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        let parent : ImagePicker
        
        init(_ parent : ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let image = info[.originalImage] as? UIImage {
                
                let data = image.jpegData(compressionQuality: 0.2)
                
                let dataKB = Double(data!.count) / 1000.0
                
                print(dataKB)
                if dataKB < 1000.0 {
                    self.parent.image = data!
                } else {
                    return
                }
       
            }
            
            parent.presentationMode.wrappedValue.dismiss()

        }
        
        
        
    }
    
}
