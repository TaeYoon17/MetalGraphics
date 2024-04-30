//
//  ViewController.swift
//  BarycentricCoordinates
//
//  Created by Developer on 4/29/24.
//

import UIKit
import MetalKit
final class ViewController: UIViewController {
    let mtkView = {
        let view = MTKView(frame: .zero)
        view.preferredFramesPerSecond = 60
        view.framebufferOnly = false
        view.clearColor = .init(red: 0, green: 0, blue: 0, alpha: 1)
        view.drawableSize = view.frame.size
        view.autoResizeDrawable = true
        view.colorPixelFormat = .bgra8Unorm
        return view
    }()
    let renderer = Renderer(width: 300, height: 300)
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(mtkView)
        mtkView.translatesAutoresizingMaskIntoConstraints = false
        mtkView.delegate = renderer
        mtkView.device = renderer.device
        NSLayoutConstraint.activate([
            mtkView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mtkView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mtkView.widthAnchor.constraint(equalToConstant: 300),
            mtkView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }


}

