//
//  NewsView.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/03/07.
//

import SwiftUI

struct NewsView: View {
    @EnvironmentObject var userInfo : UserInfo
    @StateObject var vm = NewsViewModel()
    @StateObject var scVM = CustomScrollViewModel()
    
    
    var body: some View {
        
        NavigationView {
            ZStack(alignment: .top) {
                
                ChildSizeReader(size: $scVM.headerSize) {
                    NewsHeaderView(vm: vm)
                        .opacity(scVM.headerOpacity)
                        .onChange(of: scVM.minY, perform: {scVM.headerAnimation($0)})
                }
               
            
                if vm.status == .plane {
                    GeometryReader { geo in
                        CustomScrollView(offsetChanges: {scVM.minY = $0.y}) {
                            ScrollViewReader { reader in
                                LazyVStack {
                                    
                                    ForEach(vm.articles) { article in
                                        
                                        Button(action: {
                                            openUrl(artcle: article)
                                        }) {
                                            ArtcleCell(artcle: article, logo: vm.currentTag.image)
                                        }
                                        .id(article.id)
                                        .onAppear(perform: {
                                            if article.id == vm.articles.last?.id {
                                                vm.ferchArticles()
                                            }
                                        })
                                        .frame( height: geo.size.height)
                                    }
                                }
                                .onReceive(vm.$scrollTo) { (action) in
                                    guard !vm.articles.isEmpty else {return}
                                    withAnimation {
                                        switch action {
                                        case .top :
                                            reader.scrollTo(vm.articles.first?.id, anchor: .top)
                                        case .none:
                                            return
                                        }
                                    }
                                }
                                
                            }
                        }
                        
                    }
                    .offset(y:scVM.showHeader ? scVM.headerSize.height : 0)
                    .overlay(vm.loading ? GreenProgressView() : nil)
                } else {
                    StatusView(status: vm.status, retryAction: {print("Fetch")})
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
    
    private func openUrl(artcle : Article) {
        
        guard let url = URL(string: artcle.url) else {return}
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        
    }
    
//    private func headerAnimatiuon(_ value : CGFloat) {
//        if value == 0 {
//            withAnimation(Animation.easeOut(duration: 0.25)) {
//                headerOpacity = 1
//            }
//            return
//        }
//
//        DispatchQueue.main.async {
//
//            if startMinY == 0 {
//                startMinY = minY
//            }
//
//            let offset = startMinY - minY
//
//            if offset < 0 {
//                headerOpacity = 1
//                return
//            }
//
//            if offset > offsetSelf {
//
//                if headerOpacity != 0 {
//                    withAnimation(Animation.easeOut(duration: 0.25)) {
//                        headerOpacity = 0
//                    }
//                }
//            }
//
//            if offset < offsetSelf {
//                if headerOpacity != 1 {
//                    withAnimation(Animation.easeOut(duration: 0.7)) {
//                        headerOpacity = 1
//                    }
//                }
//            }
//
//
//            offsetSelf = offset
//
//        }
//
//
//    }
}

struct NewsHeaderView : View {
    @EnvironmentObject var userInfo : UserInfo
    @StateObject var vm : NewsViewModel
    
    var body: some View {
        
       
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing :15) {
                ForEach(userInfo.modes, id : \.self) { lang in
                    
                    Button(action: {
                        if vm.currentTag == lang {
                            vm.scrollTo = .top
                        } else {
                            vm.changeTag(lang: lang)
                        }
                        
                        
                    }) {
                        lang.image
                            .LogoImageModifier(size: 45,isFocus : vm.currentTag == lang)
                    }
                    
                }
                Spacer()
            }
        }
        .padding()
        
        
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
