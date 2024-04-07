//
//  ContentView.swift
//  DrawingTriangle
//
//  Created by Developer on 4/8/24.
//

import SwiftUI
import MetalKit
struct MetalView: UIViewRepresentable{
    func makeCoordinator() -> Renderer {
        Renderer()
    }
    func makeUIView(context: Context) -> MTKView {
        let view = MTKView(frame: .zero)
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("디바이스가 없음!!")
        }
        context.coordinator.view = view
        view.device = device
        view.delegate = context.coordinator
        view.preferredFramesPerSecond = 60
        view.enableSetNeedsDisplay = true
        view.framebufferOnly = false
        view.drawableSize = view.frame.size
        return view
    }
    func updateUIView(_ uiView: MTKView, context: Context) { }
}

struct ContentView: View {
    var body: some View {
        MetalView().frame(width: 300,height: 300)
    }
}

#Preview {
    ContentView()
}
