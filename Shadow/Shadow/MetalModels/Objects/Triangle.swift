//
//  Triangle.swift
//  Shadow
//
//  Created by Developer on 4/25/24.
//

import Foundation
struct Triangle:ObjProtocol,PhongAvailable{
    typealias vf3 = vector_float3
    var v0: vector_float3
    var v1: vector_float3
    var v2: vector_float3
    var phongMat: PhongMaterial
    var alpha: Float32
    var ks: Float32
    func checkRayCollision(ray: inout Ray) -> Hit{
        var hit = Hit(d: -1, point: .init(0,0,0), normal: .init(0, 0, 0))
        var point = vector_float3()
        var faceNormal = vector_float3()
        var t:Float32 = 0
        if intersectRayTriangle(ray.start,ray.dir,point: &point,fN: &faceNormal,t:&t){
            hit.d = t
            hit.point = point
            hit.normal = faceNormal
        }
        return hit
    }
    func intersectRayTriangle(_ rayStart:vf3,_ rayDir: vf3,point:inout vf3,fN faceNormalize:inout vf3,t:inout Float32) -> Bool{
        
        // 평면의 법선 벡터
        faceNormalize = simd_cross(v1 - v0, v2 - v0)
        if simd_dot(-rayDir, faceNormalize) < 0 { return false }
        if abs(simd_dot(rayDir, faceNormalize)) < 1e-2 { return false }
        t = (dot(v0,faceNormalize) - dot(rayStart,faceNormalize)) / dot(rayDir, faceNormalize)
        if t < 0.0 {return false} // 광선의 진행이 원하는 것과 반대로 진행됨
        
        // 광선이 평면에 만나는 점의 위치 벡터
        point = rayStart + rayDir * t
        
        // 작은 삼각형들의 법선 벡터
        let normal0 = simd_normalize(simd_cross(point - v2, v1 - v2))
        let normal1 = simd_normalize(simd_cross(point - v0, v2 - v0))
        let normal2 = simd_normalize(simd_cross(v1 - v0, point - v0))
        
        // 광선이 삼각형 내부에 없으면 false
        if simd_dot(normal0, faceNormalize) < 0 {return false}
        if simd_dot(normal1, faceNormalize) < 0 {return false}
        if simd_dot(normal2, faceNormalize) < 0 {return false}
        
        return true
    }
}

