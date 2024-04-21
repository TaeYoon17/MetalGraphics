//
//  Renderer.swift
//  PerspectiveProjection
//
//  Created by Developer on 4/21/24.
//

import Foundation
import MetalKit

final class Renderer:NSObject{
    weak var view: MTKView!
    var device:MTLDevice!
    var commandQueue: MTLCommandQueue!
    var pipelineState:MTLRenderPipelineState!
    var vertexBuffer: MTLBuffer!
    var vertices:[Vertex]!
    let rayTracer:Raytracer
    init(width:Int,height:Int) {
        self.rayTracer = Raytracer(width: width, height: height)
        guard let device = MTLCreateSystemDefaultDevice() else {fatalError("Don't have device")}
        self.device = device
        self.commandQueue = device.makeCommandQueue()
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        let library = device.makeDefaultLibrary()
        pipelineDescriptor.vertexFunction = library?.makeFunction(name: "vertexShader")
        pipelineDescriptor.fragmentFunction = library?.makeFunction(name: "fragmentShader")
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        do{
            self.pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        }catch{
            fatalError("fail to make pipelineState")
        }
        self.vertices = rayTracer.render()
        self.vertexBuffer = device.makeBuffer(bytes: vertices,length: vertices.count * MemoryLayout<Vertex>.stride,options: [])!
        super.init()
    }
}

extension Renderer:MTKViewDelegate{
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) { }
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable else {return}
        print("drawing")
        let commandBuffer: MTLCommandBuffer? = commandQueue.makeCommandBuffer()
        
        let renderPassDescriptor = view.currentRenderPassDescriptor
        renderPassDescriptor?.colorAttachments[0].clearColor = MTLClearColorMake(0, 0, 0, 1)
        renderPassDescriptor?.colorAttachments[0].loadAction = .clear
        renderPassDescriptor?.colorAttachments[0].storeAction = .store
        
        let renderEncoder: MTLRenderCommandEncoder? = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor!)
        renderEncoder?.setRenderPipelineState(pipelineState)
        renderEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderEncoder?.drawPrimitives(type: .point, vertexStart: 0, vertexCount: vertices.count)
        renderEncoder?.endEncoding()
        
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
