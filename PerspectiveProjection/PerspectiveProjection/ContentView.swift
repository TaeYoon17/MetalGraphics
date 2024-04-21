//
//  ContentView.swift
//  PerspectiveProjection
//
//  Created by Developer on 4/21/24.
//

import SwiftUI
import MetalKit
struct MetalView: UIViewRepresentable{
    func makeCoordinator() -> Renderer {
        Renderer(width: 370, height: 370)
    }
    func makeUIView(context: Context) -> some UIView {
        let metalView = MTKView(frame: .zero)
        metalView.preferredFramesPerSecond = 60
        metalView.enableSetNeedsDisplay = true
        metalView.framebufferOnly = false
        metalView.device = context.coordinator.device
        metalView.delegate = context.coordinator
        metalView.drawableSize = metalView.frame.size
        return metalView
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}
struct ContentView: View {
    var body: some View {
        MetalView().frame(width: 370,height: 370)
    }
}

#Preview {
    ContentView()
}
