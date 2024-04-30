//
//  Triangle.swift
//  BarycentricCoordinates
//
//  Created by Developer on 4/29/24.
//

import Foundation

struct Triangle:ObjProtocol{
    var id: UUID = UUID()
    typealias vf3 = vector_float3
    var v0: vector_float3
    var v1: vector_float3
    var v2: vector_float3
    var uv0: vector_float2
    var uv1: vector_float2
    var uv2: vector_float2
    var phongMat: PhongMaterial
    var alpha: Float32
    var ks: Float32
    init(v0: vector_float3,
         v1: vector_float3,
         v2: vector_float3,
         uv0: vector_float2 = .zero,
         uv1: vector_float2 = .zero,
         uv2: vector_float2 = .zero,
         phongMat: PhongMaterial, alpha: Float32, ks: Float32) {
        self.v0 = v0
        self.v1 = v1
        self.v2 = v2
        self.uv0 = uv0
        self.uv1 = uv1
        self.uv2 = uv2
        self.phongMat = phongMat
        self.alpha = alpha
        self.ks = ks
    }
    func checkRayCollision(ray: inout Ray) -> Hit{
        var hit = Hit(d: -1, point: .init(0,0,0), normal: .init(0, 0, 0))
        var point = vector_float3()
        var faceNormal = vector_float3()
        var t:Float32 = 0
        var w0:Float32 = 0
        var w1:Float32 = 0
        if intersectRayTriangle(ray.start,ray.dir,point: &point,fN: &faceNormal,t:&t,w0:&w0,w1:&w1){
            hit.d = t
            hit.point = point
            hit.normal = faceNormal
            hit.w = .init(w0, w1)
        }
        return hit
    }
    func intersectRayTriangle(_ rayStart:vf3,_ rayDir: vf3,point:inout vf3,fN faceNormalize:inout vf3,
                              t:inout Float32,w0:inout Float32, w1:inout Float32) -> Bool{
        
        // 평면의 법선 벡터
        faceNormalize = simd_cross(v1 - v0, v2 - v0)
        if simd_dot(-rayDir, faceNormalize) < 0 { return false }
        if abs(simd_dot(rayDir, faceNormalize)) < 1e-2 { return false }
        t = (dot(v0,faceNormalize) - dot(rayStart,faceNormalize)) / dot(rayDir, faceNormalize)
        if t < 0.0 {return false} // 광선의 진행이 원하는 것과 반대로 진행됨
        
        // 광선이 평면에 만나는 점의 위치 벡터
        point = rayStart + rayDir * t
        
        // 작은 삼각형들의 법선 벡터
        // 방향만 확인하면 되기 때문에 normalize 생략 후 무게중심 좌표에 사용
//        let normal0 = simd_normalize(simd_cross(point - v2, v1 - v2))
//        let normal1 = simd_normalize(simd_cross(point - v0, v2 - v0))
//        let normal2 = simd_normalize(simd_cross(v1 - v0, point - v0))
        let cross0 = simd_cross(point - v2, v1 - v2)
        let cross1 = simd_cross(point - v0, v2 - v0)
        let cross2 = simd_cross(v1 - v0, point - v0)
        
        // 광선이 삼각형 내부에 없으면 false
        if simd_dot(cross0, faceNormalize) < 0 {return false}
        if simd_dot(cross1, faceNormalize) < 0 {return false}
        if simd_dot(cross2, faceNormalize) < 0 {return false}
        
        let area0 = length(cross0) * 0.5
        let area1 = length(cross1) * 0.5
        let area2 = length(cross2) * 0.5
        
        let areaSum = area0 + area1 + area2
        w0 = area0 / areaSum
        w1 = area1 / areaSum
        return true
    }
}
