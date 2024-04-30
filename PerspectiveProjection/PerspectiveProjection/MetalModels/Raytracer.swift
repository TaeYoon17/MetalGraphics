//
//  Raytracer.swift
//  PerspectiveProjection
//
//  Created by Developer on 4/21/24.
//

import Foundation
import simd
final class Raytracer{
    let width:Int,height:Int
    var objs:[any Obj] = []
    var light: Light = .init(pos: .init(-0.75, 0.5, -1))
    let eye: vector_float3 = .init(0, 0, -1)
    
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
        let oneSphere = Sphere(center: .init(0, 0, 0.4),
                               radius: 0.4,
                               color: .init(1, 1, 0),
                               phongMat: PhongMaterial(amb: .init(0, 0.2, 1),diff: .init(0, 0, 1),spec: .init(0, 1, 1)),
                               alpha: 6,
                               ks:1
        )
        let twoSphere = Sphere(center: .init(0.2,0.2,0.6),
                               radius: 0.4,
                               color: .init(0, 1, 0),
                               phongMat: PhongMaterial(amb: .init(1, 0, 0), diff: .init(x: 0, y: 1, z: 0),spec: .init(0.4, 1, 0)),
                               alpha: 2,
                               ks:0.4
        )
        objs.append(oneSphere)
        objs.append(twoSphere)
    }
    func transformScreenToWorld(posScreen: vector_float2) -> vector_float3{
        let xScale = 2.0 / (Float32(width) - 1)
        let yScale = 2.0 / (Float32(height) - 1)
        let aspect = Float32(width) / Float32(height)
        return vector_float3(posScreen.x * xScale - 1.0 * aspect, -posScreen.y * yScale + 1.0, 0.0)
    }
    func render()->[Vertex]{
        var vertices:[Vertex] = Array(repeating: .init(position: .zero, color: .zero), count: height * width)
        for j in (0..<height){
            for i in (0..<width){
                let pixelPosWorld = self.transformScreenToWorld(posScreen: .init(x: Float(i), y: Float(j)))
                let rayDir = pixelPosWorld - eye
                var ray = Ray(start: pixelPosWorld, dir: rayDir)
                let positionColor = vector_float4(traceRay(ray:&ray),1.0)
                vertices[j * width + i] = Vertex(position: .init(x: pixelPosWorld.x, y: pixelPosWorld.y), color: positionColor)
            }
        }
        return vertices
    }
    
    func traceRay(ray:inout Ray) -> vector_float3{
        var hit = Hit(d: -1, point: .zero, normal: .zero)
        var closestD: Float32 = 1000.0
        for obj in objs {
            let nowHit = obj.checkRayCollision(ray: &ray)
            if nowHit.d < 0 { continue }
            if nowHit.d < closestD{
                closestD = nowHit.d
                hit = nowHit
                hit.obj = obj
            }
        }
        if hit.d < 0{
            return .zero
        }else{
            return phongColor(ray:ray,hit: hit)
        }
    }
    func phongColor(ray:Ray,hit: Hit) -> vector_float3 {
        /// Diffuse 설정
        guard let obj = hit.obj else {return .zero}
        let dirToLight = normalize(light.pos - hit.point)
        let diff = max(dot(hit.normal, dirToLight), 0)
        /// Specular 설정
        let reflectDir = 2 * dot(hit.normal, dirToLight) * hit.normal - dirToLight
        let specular = max(dot(-ray.dir, reflectDir),0)
        // 물체 특성에 따라 반짝이는 정도를 다르게 한다.
        let specularMat = pow(specular, obj.alpha)
        return obj.phongMat.amb + obj.phongMat.diff * diff + obj.phongMat.spec * specularMat * obj.ks
    }
}
