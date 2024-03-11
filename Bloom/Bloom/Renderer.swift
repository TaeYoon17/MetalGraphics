//
//  Renderer.swift
//  Bloom
//
//  Created by 김태윤 on 2/7/24.
//

import Foundation
import MetalKit

final class Renderer:NSObject,MTKViewDelegate{
    var view: MainView
    var device: MTLDevice!
    var metalCommandQueue:MTLCommandQueue!
    let pipelineState: MTLRenderPipelineState!
    var vertexBuffer: MTLBuffer
    var vetices: [Vertex]!
//    var imageTexture:
    init(view:MainView) {
        self.view = view
        if let device = MTLCreateSystemDefaultDevice(){
            self.device = device
        }
        self.metalCommandQueue = device.makeCommandQueue()
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        let library = device.makeDefaultLibrary()
        pipelineDescriptor.vertexFunction = library?.makeFunction(name: "vertexShader")
        pipelineDescriptor.fragmentFunction = library?.makeFunction(name: "fragmentShader")
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        do{
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        }catch{
            fatalError("Don't made pipelineState")
        }
        
        self.vetices = getRGBValues()!
        // 하나의 도형을 만든 버퍼
        vertexBuffer = device.makeBuffer(bytes: vetices, length: vetices.count * MemoryLayout<Vertex>.stride,options: [])!
        super.init()
    }
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable else { return }
        let commandBuffer:MTLCommandBuffer? = metalCommandQueue.makeCommandBuffer()
        
        let renderPassDescriptor = view.currentRenderPassDescriptor
        renderPassDescriptor?.colorAttachments[0].clearColor = MTLClearColorMake(0, 0, 0, 1)
        renderPassDescriptor?.colorAttachments[0].loadAction = .clear // MTLLoadAction
        renderPassDescriptor?.colorAttachments[0].storeAction = .store // MTLStoreAction
        
        let renderEncoder:MTLRenderCommandEncoder? = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor!)
        renderEncoder?.setRenderPipelineState(pipelineState)
        renderEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderEncoder?.drawPrimitives(type: .point, vertexStart: 0, vertexCount: vetices.count)
        renderEncoder?.endEncoding()
        
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
