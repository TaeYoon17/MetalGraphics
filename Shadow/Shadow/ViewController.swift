//
//  ViewController.swift
//  Shadow
//
//  Created by Developer on 4/25/24.
//

import UIKit
import MetalKit
class ViewController: UIViewController {
    let mtkView = {
        let mtkView = MTKView(frame: .zero)
        mtkView.preferredFramesPerSecond = 60
        mtkView.colorPixelFormat = .bgra8Unorm
        mtkView.device = MTLCreateSystemDefaultDevice()
        mtkView.clearColor = .init(red: 0, green: 0, blue: 0, alpha: 1)
        mtkView.enableSetNeedsDisplay = true
        mtkView.framebufferOnly = false
        mtkView.drawableSize = mtkView.frame.size
        return mtkView
    }()
    lazy var renderer = Renderer(width: 300, height: 300)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addSubview(mtkView)
        mtkView.delegate = renderer
        renderer.view = mtkView
        mtkView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mtkView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mtkView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mtkView.widthAnchor.constraint(equalToConstant: 300),
            mtkView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
}
