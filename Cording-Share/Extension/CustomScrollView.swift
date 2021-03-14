//
//  CustomScrollView.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/03/10.
//

import SwiftUI

private struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {}
}

struct CustomScrollView<Content : View> : View {
    
    let axis : Axis.Set
    let showsIndicators: Bool
    let offsetChanges : (CGPoint) -> Void
    let content :Content
    
    init(axis : Axis.Set = .vertical, showsIndicators: Bool = true, offsetChanges : @escaping(CGPoint) -> Void = {_ in},         @ViewBuilder content: () -> Content
    ) {
        self.axis = axis
        self.showsIndicators = showsIndicators
        self.offsetChanges = offsetChanges
        self.content = content()
    }
    
    var body: some View {
        SwiftUI.ScrollView(axis, showsIndicators: showsIndicators) {
            GeometryReader { geo in
                Color.clear.preference(key : ScrollOffsetPreferenceKey.self,value: geo.frame(in: .named("scrollView")).origin)
            }.frame(width: 0, height: 0)
            content
        }
        .coordinateSpace(name: "scrollView")
        .onPreferenceChange(ScrollOffsetPreferenceKey.self, perform: offsetChanges)
    }
}


struct ChildSizeReader<Content: View>: View {
    @Binding var size: CGSize
    let content: () -> Content
    var body: some View {
        ZStack {
            content()
                .background(
                    GeometryReader { proxy in
                        Color.clear
                            .preference(key: SizePreferenceKey.self, value: proxy.size)
                    }
                )
        }
        .onPreferenceChange(SizePreferenceKey.self) { preferences in
            self.size = preferences
            print(size)
        }
    }
}

struct SizePreferenceKey: PreferenceKey {
    typealias Value = CGSize
    static var defaultValue: Value = .zero

    static func reduce(value _: inout Value, nextValue: () -> Value) {
        _ = nextValue()
    }
}

final class CustomScrollViewModel : ObservableObject {
    
    @Published var minY : CGFloat = 0
    @Published var startMinY : CGFloat = 0
    @Published var offsetSelf : CGFloat = 0
    @Published var headerOpacity : Double = 1
    @Published var headerSize : CGSize = .zero
    
    var showHeader : Bool {
        return headerOpacity == 1
    }
    
    
    func headerAnimation(_ value : CGFloat) {
        if value == 0 {
            withAnimation(Animation.easeOut(duration: 0.25)) {
                headerOpacity = 1
            }
            return
        }
        
        DispatchQueue.main.async {
            
            if self.startMinY == 0 {
                self.startMinY = self.minY
            }
            
            let offset = self.startMinY - self.minY
            
            if offset < 0 {
                self.headerOpacity = 1
                return
            }
            
            if offset > self.offsetSelf {
                
                if self.headerOpacity != 0 {
                    withAnimation(Animation.easeOut(duration: 0.25)) {
                        self.headerOpacity = 0
                    }
                }
            }
            
            if offset < self.offsetSelf {
                if self.headerOpacity != 1 {
                    withAnimation(Animation.easeOut(duration: 0.7)) {
                        self.headerOpacity = 1
                    }
                }
            }
         
            
            self.offsetSelf = offset
            
        }
    }
    
}

