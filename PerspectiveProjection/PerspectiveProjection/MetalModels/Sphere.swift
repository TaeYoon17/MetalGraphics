//
//  Circle.swift
//  PerspectiveProjection
//
//  Created by Developer on 4/21/24.
//

import Foundation
import simd
struct Sphere: Obj{
    var center: vector_float3
    var radius: Float32
    var phongMat: PhongMaterial = .init(amb: .zero, diff: .zero, spec: .zero)
    var alpha: Float32 = 0
    var ks: Float32 = 0
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
