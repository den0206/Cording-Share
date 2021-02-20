//
//  LoopMovieView.swift
//  Cording-Share
//
//  Created by 酒井ゆうき on 2021/02/20.
//

import SwiftUI
import AVFoundation

struct LoopBackgroundView : View {
    
    var body: some View {
        LoopMoviewView()
            .overlay(Color.white.opacity(0.5))
            .blur(radius: 1)
    }
}

struct LoopMoviewView : UIViewRepresentable {
    
    func makeUIView(context: Context) -> some UIView {
        return LoopPlayerView(frame: .zero)
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}


final class LoopPlayerView : UIView {
    
    private var playerLayer = AVPlayerLayer()
    private var playerLooper : AVPlayerLooper?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let iValue = Int.random(in: 1 ... 2)
        
        guard let fileUrl = Bundle.main.url(forResource: "code-\(iValue)", withExtension: "mp4") else {
            print("no URL")
            return
        }
        
        let item = AVPlayerItem(url: fileUrl)
        
        let player = AVQueuePlayer(playerItem: item)
        player.isMuted = true
        playerLayer.player = player
        playerLayer.videoGravity = AVLayerVideoGravity(rawValue: AVLayerVideoGravity.resize.rawValue)
        layer.addSublayer(playerLayer)
        
        playerLooper = AVPlayerLooper(player: player, templateItem: item)
        
        player.play()
        
    }
    
 
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
