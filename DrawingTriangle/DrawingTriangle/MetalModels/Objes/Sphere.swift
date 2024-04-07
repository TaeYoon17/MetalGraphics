//
//  Sphere.swift
//  RayTracingPractice
//
//  Created by Developer on 3/31/24.
//

import Foundation
import simd
struct Sphere{
    var center: vector_float3
    var radius: Float32
    var color: vector_float3
}
extension Sphere: Obje{
    // 구와 부딪힌 광선의 충돌 Hit 정보를 제공한다. 충돌하지 않으면 Hit 거리를 -1로 정의한다.
    func checkRayCollision(ray: inout Ray) -> Hit {
        let rayStart = ray.start
        var hit = Hit(d: -1, point: .init(0,0,0), normal: .init(0, 0, 0))
        
        let rayDir = ray.dir
        let b:Float32 = 2 * dot(rayDir, rayStart - self.center)
        let c:Float32 = dot(rayStart - self.center, rayStart - self.center) - pow(self.radius,2)
        let nabla = pow(b,2) / 4.0 - c
        
        if nabla >= 0.0{
            let d1 = -b / 2.0 + sqrtf(nabla)
            let d2 = -b / 2.0 - sqrtf(nabla)
            hit.d = min(d1, d2)
            hit.point = ray.start + ray.dir * hit.d
            hit.normal = normalize(hit.point - self.center)
        }
        return hit
    }
}
