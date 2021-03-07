//
//  NewsView.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/03/07.
//

import SwiftUI
import Parma

struct NewsView: View {
    @EnvironmentObject var userInfo : UserInfo
    @StateObject var vm = NewsViewModel()
    
    var body: some View {
        
        NavigationView {
            VStack {
               
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing :15) {
                        ForEach(userInfo.modes, id : \.self) { lang in
                            
                            Button(action: {vm.currentTag = lang}) {
                                lang.image
                                    .LogoImageModifier(size: 45)
                            }
                  
                        }
                        Spacer()
                    }
                }
                .padding()
                
                Divider()
                    .background(Color.white)
               
                
                GeometryReader { geo in
                    ScrollView {
                        LazyVStack {
                            
                            ForEach(vm.articles) { article in
                                
                                ArtcleCell(artcle: article, logo: vm.currentTag.image)
                                    .frame( height: geo.size.height)
                            }
                        }
                        
                    }
                    
                }
                
                Spacer()
            }
            .onAppear {
                vm.ferchArticles()
            }
            
            
            /// navigation property
            .navigationBarHidden(true)
        }
        
        
    }
}

struct ArtcleCell : View {
    
    @State private var isExpand = false
    
    let artcle : Article
    var logo : Image
    
    var body: some View {
        
        VStack {
            Spacer()
            VStack {
                
                if isExpand {
                    
                    Text(artcle.title)
                        .padding()
                        .frame( height: 200)
                        .background(Color.black)
                        .cornerRadius(8)
                        .padding()
                    
                }
                
                HStack(spacing :15) {
                    
                    Image(systemName: "chevron.left.slash.chevron.right")
                        .rotationEffect(.degrees(isExpand ? 0: -180))
                        .font(.system(size: 18, weight: .regular))
                        .onTapGesture {
                            withAnimation(.spring()) {
                                isExpand.toggle()
                            }
                        }
                    
                    Image(systemName: "paperclip")
                        .font(.system(size: 18, weight: .regular))
                        .onTapGesture {
                            
                        }
                    
                    Spacer()
                    
                    logo
                        .LogoImageModifier(size: 30)
                    
                    
                }
                .padding()
                
            }
            .background(Color.primary.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .padding()
            .padding(.horizontal,36)
            .foregroundColor(.primary)
            .id(artcle.id)
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 1.0)) {
                    isExpand = true
                    
                }
            }
            .onDisappear {
                isExpand = false
            }
            
            Spacer()
            
            Divider()
                .background(Color.primary)
            
        }
        
    }
    
}



struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView()
    }
}
