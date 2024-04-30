//
//  Renderer.swift
//  BarycentricCoordinates
//
//  Created by Developer on 4/29/24.
//

import Foundation
import MetalKit

final class Renderer: NSObject{
    weak var view: MTKView!
    var device: MTLDevice! // MetalAPI를 적용하기 위한 실 기기 추상화한 객체
    private var commandQueue: MTLCommandQueue!
    private var pipelineState: MTLRenderPipelineState!
    private var vertexBuffer: MTLBuffer!
    private var vertices:[Vertex]! // 메탈 쉐이더와 구현부 둘 다 공통으로 알아야하는 데이터 구조
    private let rayTracer:RayTracer
    init(width:CGFloat,height:CGFloat){
        guard let device = MTLCreateSystemDefaultDevice() else {fatalError("디바이스가 없다")}
        self.device = device
        self.commandQueue = device.makeCommandQueue()
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        let library = device.makeDefaultLibrary()
        pipelineDescriptor.vertexFunction = library?.makeFunction(name: "vertexShader")
        pipelineDescriptor.fragmentFunction = library?.makeFunction(name: "fragmentShader")
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        do{
            self.pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        }catch{fatalError("fail to make pipelineState")}
        self.rayTracer = RayTracer(width: width, height: height)
        vertices = rayTracer.render()
        vertexBuffer = device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Vertex>.stride,options: [])
    }
}
extension Renderer:MTKViewDelegate{
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) { }
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable else {return}
        let commandBuffer: MTLCommandBuffer? = commandQueue.makeCommandBuffer()
        let renderPassDescriptor = view.currentRenderPassDescriptor
        renderPassDescriptor?.colorAttachments[0].clearColor = MTLClearColorMake(0, 0, 0, 1)
        renderPassDescriptor?.colorAttachments[0].loadAction = .clear
        renderPassDescriptor?.colorAttachments[0].storeAction = .store
        
        let renderEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor!)
        renderEncoder?.setRenderPipelineState(self.pipelineState)
        renderEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderEncoder?.drawPrimitives(type: .point, vertexStart: 0, vertexCount: vertices.count)
        renderEncoder?.endEncoding()
        
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
