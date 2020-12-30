//
//  NewPostView.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2020/12/30.
//

import SwiftUI
import CodeMirror_SwiftUI


struct NewPostView: View {
    
    @State private var text : String = ""
    @State private var mode : CodeMode = CodeMode.swift
    
    private var themes = CodeViewTheme.allCases.sorted {
        return $0.rawValue < $1.rawValue
    }
    
    var body: some View {
            
        VStack {
            
            HStack {
                Spacer()
                
                Button(action: {
                        guard let data = text.data(using: .utf8) else {return}
                    
                    print(String(data: data, encoding: .utf8)!)
                        }, label: {
                    /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
                })
            }
            
            
            CodeView(theme: themes[0], code: $text, mode: mode.mode(), fontSize: 12, showInvisibleCharacters: false, lineWrapping: true)
              
            
            
            
        }
            
        
       
    }
}

struct NewPostView_Previews: PreviewProvider {
    static var previews: some View {
        NewPostView()
    }
}
