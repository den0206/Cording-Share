//
//  SelecteLanguageView.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/01/03.
//

import SwiftUI
import CodeMirror_SwiftUI

struct SelecteLanguageView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        VStack {
            HStack {
                Button(action: {presentationMode.wrappedValue.dismiss()}) {
                    Image(systemName: "xmark")
                        .font(.system(size: 24))
                        .foregroundColor(.primary)
                        .padding()
                }
                
                Spacer()
            }
            
            ForEach(CodeMode.codeModes, id : \.self) { mode in
                
                ModeCell(codeMode: mode)
            }
            
            Spacer()
            
        }
        .preferredColorScheme(.dark)
    }
}

struct ModeCell : View {
    
    @EnvironmentObject var userInfo : UserInfo
    @Environment(\.presentationMode) var presentationMode
    var codeMode : CodeMode
    
    
    var body: some View {
        
        Button(action: {
            userInfo.setCodeMode(codeMode: codeMode)
            presentationMode.wrappedValue.dismiss()
        }) {
            VStack {
                HStack {
                    Text("∙ \(codeMode.rawValue)")
                        .font(.headline)
                        .padding(.leading,10)
                    
                    Spacer()
                    
                    if codeMode == userInfo.mode {
                        Image(systemName: "checkmark.circle")
                            .font(.system(size: 24))
                            .padding(.trailing,10)
                    }
                }
                
                CustomLine()
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                    .frame( height: 1)
            }
        }
        .foregroundColor(.primary)
    }
}

struct SelecteLanguageView_Previews: PreviewProvider {
    static var previews: some View {
        SelecteLanguageView()
    }
}
