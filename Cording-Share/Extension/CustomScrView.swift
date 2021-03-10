//
//  CustomScrollView.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/03/10.
//

import SwiftUI

struct CustomScrView: View {
    @State private var currentPosition : CGPoint = CGPoint(x: 0, y: 0)
    
    var body: some View {
        VStack {
            CustomScrollView(axis: .vertical, showsIndicators: false, offsetChanges: {currentPosition = $0}) {
                ForEach(0..<100) { i in
                    Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.")
                }
            }
            
            Text("\(currentPosition.x)")
            Text("\(currentPosition.y)")
        }
    }
}

