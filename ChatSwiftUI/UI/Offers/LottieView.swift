//
//  LottieView.swift
//  ChatSwiftUI
//
//  Created by С02zt4kxmd6t on 22.09.2024.
//

import Lottie
import SwiftUI

struct LottieView: NSViewRepresentable {
    
    public init(lottieFile: String, loopMode: LottieLoopMode = .loop, autostart: Bool = true, contentMode: LottieContentMode = LottieContentMode.scaleAspectFit) {
        
        self.lottieFile = lottieFile
        self.loopMode = loopMode
        self.autostart = autostart
        self.contentMode = contentMode
    }
    
    let lottieFile: String
    let loopMode: LottieLoopMode
    let autostart: Bool
    let contentMode: LottieContentMode
    
    let animationView = LottieAnimationView()
    
    public func makeNSView(context: Context) -> some NSView {
        let theView = NSView()
      
        animationView.animation = LottieAnimation.named(lottieFile)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.backgroundBehavior = .pauseAndRestore
        

        if self.autostart{
            animationView.play()
        }
        
        theView.addSubview(animationView)
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.heightAnchor.constraint(equalTo: theView.heightAnchor).isActive = true
        animationView.widthAnchor.constraint(equalTo: theView.widthAnchor).isActive = true
        animationView.leadingAnchor.constraint(equalTo: theView.leadingAnchor).isActive = true
        animationView.trailingAnchor.constraint(equalTo: theView.trailingAnchor).isActive = true
        
        animationView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        animationView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        return theView
    }
    
    
    func pause(){
        animationView.pause()
    }
    
    func play(){
        animationView.play()
    }
    
    func stop(){
        animationView.stop()
    }
    
    public func updateNSView(_ nsView: NSViewType, context: Context) {
        
    }
}
