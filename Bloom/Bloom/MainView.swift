//
//  ContentV.swift
//  Bloom
//
//  Created by 김태윤 on 2/7/24.
//

import Foundation
import UIKit
import SwiftUI
import MetalKit
struct MainView: UIViewRepresentable{
    func updateUIView(_ uiView: MTKView, context: Context) {}
    
    func makeUIView(context: Context) -> MTKView {
        let mtkView = MTKView(frame: .zero)
        mtkView.delegate = context.coordinator
        mtkView.preferredFramesPerSecond = 60
        mtkView.enableSetNeedsDisplay = true
        if let metalDevice = MTLCreateSystemDefaultDevice(){
            mtkView.device = metalDevice
        }
        mtkView.framebufferOnly = false
        mtkView.drawableSize = mtkView.frame.size
        return mtkView
    }
    func makeCoordinator() -> Renderer {
        Renderer(view: self)
    }
}
