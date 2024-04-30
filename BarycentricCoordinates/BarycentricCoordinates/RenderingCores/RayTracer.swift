//
//  RayTracer.swift
//  BarycentricCoordinates
//
//  Created by Developer on 4/29/24.
//

import Foundation
import simd
import MetalKit
protocol RayTracerProtocol{
    var width:CGFloat{get set}
    var height:CGFloat{get set}
    init(width:CGFloat,height:CGFloat)
    func transformScreenToWorld(posScreen: vector_float2) -> vector_float3
    func render() -> [Vertex]
}
final class RayTracer:RayTracerProtocol{
    var width:CGFloat;var height:CGFloat
    var objes:[any ObjProtocol] = []
    var light:Light = .init(position: .init(-0.75, 0.5, 0))
    let eye:vector_float3 = .init(0, 0, -1)
    var tempID: (any ObjProtocol)?
    init(width: CGFloat,height:CGFloat){
        self.width = width
        self.height = height
        let triangle = Triangle(v0: .init(-0.5, -0.5, 0), v1: .init(0,0.5,0), v2: .init(0.5,-0.5,0), phongMat: .init(amb: .init(0.5, 0.5, 0.5), diff: .init(0.2, 0.2, 0.2), spec: .init(0.2, 0.2, 0.2)), alpha: 9, ks: 8)
        objes.append(triangle)
        self.tempID = triangle
    }
    func transformScreenToWorld(posScreen: vector_float2) -> vector_float3 {
        let xScale = 2.0 / (Float32(width) - 1)
        let yScale = 2.0 / (Float32(height) - 1)
        let aspect = Float32(width) / Float32(height)
        return vector_float3(posScreen.x * xScale - 1.0 * aspect, -posScreen.y * yScale + 1.0, 0.0)
    }
    
    func render() -> [Vertex] {
        let width = Int(width); let height = Int(height)
        var vertices:[Vertex] = Array(repeating: .init(position: .zero, color: .zero), count: height * width)
        for j in (0..<height){
            for i in(0..<width){
                let pixelPosWorld = self.transformScreenToWorld(posScreen: .init(x: Float(i), y: Float(j)))
                let rayDir = pixelPosWorld - eye
                var ray = Ray(start: pixelPosWorld, dir: rayDir)
                let positionColor = vector_float4(traceRay(ray: &ray), 1.0)
                vertices[j * width + i] = Vertex(position: .init(x: pixelPosWorld.x, y: pixelPosWorld.y), color: positionColor)
            }
        }
        return vertices
    }
}
fileprivate extension RayTracer{
    func traceRay(ray: inout Ray)->vector_float3{
        let hit:Hit = findClosestCollision(ray: &ray)
        if hit.d < 0{
            return .init(0, 0, 0)
        }else{
            var pointColor:vector_float3 = hit.obj?.phongMat.amb ?? .zero
            if hit.obj?.id == self.tempID?.id{
                let color0 = vector_float3(1, 0, 0)
                let color1 = vector_float3(0,1,0)
                let color2 = vector_float3(0,0,1)
                let w0 = hit.w.x
                let w1 = hit.w.y
                let w2 = 1 - w0 - w1
                pointColor = color0 * w0 + color1 * w1 + color2 * w2
            }
            var phongColor = phongColor(ray: ray, hit: hit)
            phongColor = phongColor + pointColor
            let toLightDir = normalize(light.position - hit.point)
            var toLightRay = Ray(start: hit.point + toLightDir * 1e-4 , dir: toLightDir)
            let lightHit:Hit = findClosestCollision(ray: &toLightRay)
            if lightHit.d < 0{ // 충돌이 존재하지 않았다. => PhongColor 반환
                return phongColor
            }
            // 충돌이 존재했다 => 그림자 반환
            guard let objAmbColor = hit.obj?.phongMat.amb else {fatalError("해당 객체가 ambient가 존재하지 않음")}
            return objAmbColor
        }
    }
    func phongColor(ray:Ray,hit:Hit) -> vector_float3{
        guard let obj = hit.obj else {return .zero}
        let dirToLight = normalize(light.position - hit.point)
        let diff = max(dot(hit.normal, dirToLight), 0)
        /// Specular 설정
        let reflectDir = 2 * dot(hit.normal, dirToLight) * hit.normal - dirToLight
        let specular = max(dot(-ray.dir, reflectDir),0)
        // 물체 특성에 따라 반짝이는 정도를 다르게 한다.
        let specularMat = pow(specular, obj.alpha)
        return obj.phongMat.amb + obj.phongMat.diff * diff + obj.phongMat.spec * specularMat * obj.ks
    }
    func findClosestCollision(ray:inout Ray) -> Hit{
        var closestD:Float32 = 1000.0
        var closestHit = Hit(d: -1, point: .zero, normal: .zero)
        for obj in objes{
            let hit = obj.checkRayCollision(ray: &ray)
            if hit.d < 0.0{ continue }
            if hit.d < closestD {
                closestD = hit.d
                closestHit = hit
                closestHit.obj = obj
            }
        }
        return closestHit
    }
}
