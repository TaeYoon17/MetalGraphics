//
//  RayTracer.swift
//  RayTracingPractice
//
//  Created by Developer on 3/31/24.
//

import Foundation
import simd

final class Raytracer{
    let width:Int,height:Int
//    var sphere:Sphere
    var objes:[any Obje] = []
    init(width:Int,height:Int){
        self.width = width
        self.height = height
       let sphere = Sphere(center: .init(0.4, -0.4, 0.5), radius: 0.4, color: .init(0,1,0))
        let triangle = Triangle(v0: .init(-0.2, -0.2, 0.2), v1: .init(-0.2, 0.2, 0.2), v2: .init(0.2, 0.2, 0.2), color: .init(1, 0, 0))
        objes.append(sphere)
        objes.append(triangle)
    }
    func transformScreenToWorld(posScreen: vector_float2) -> vector_float3{
        let xScale = 2.0 / (Float32(width) - 1)
        let yScale = 2.0 / (Float32(height) - 1)
        let aspect = Float32(width) / Float32(height)
        return vector_float3(posScreen.x * xScale - 1.0 * aspect, -posScreen.y * yScale + 1.0, 0.0)
    }
    
    func render() -> [Vertex]{
        var vertices:[Vertex] = Array(repeating: .init(position: .zero, color: .zero), count: height * width)
        for j in (0..<height){
            for i in (0..<width){
                let pixelPosWorld = self.transformScreenToWorld(posScreen: .init(x: Float(i), y: Float(j)))
                let rayDir = vector_float3(0, 0, 1.0)
                var ray = Ray(start: pixelPosWorld, dir: rayDir)
                let positionColor = vector_float4(traceRay(ray: &ray), 1.0)
                vertices[j * width + i] = Vertex(position: .init(x: pixelPosWorld.x, y: pixelPosWorld.y), color: positionColor)
            }
        }
        return vertices
    }
}
fileprivate extension Raytracer{
    func traceRay(ray: inout Ray)->vector_float3{
        var color: vector_float3 = .zero
        let hit:Hit = findClosestCollision(ray: &ray,color:&color)
        if hit.d < 0{
            return .init(0, 0, 1)
        }else{
            print(hit.d)
            return color - (color * hit.d)
        }
    }
    func findClosestCollision(ray:inout Ray,color: inout vector_float3) -> Hit{
        var closestD:Float32 = 1000.0
        var closestHit = Hit(d: -1, point: .zero, normal: .zero)
        for obj in objes{
            let hit = obj.checkRayCollision(ray: &ray)
            if hit.d < 0.0{ continue }
            if hit.d < closestD {
                closestD = hit.d
                closestHit = hit
                closestHit.obje = obj
                color = obj.color
            }
        }
        return closestHit
    }
}
