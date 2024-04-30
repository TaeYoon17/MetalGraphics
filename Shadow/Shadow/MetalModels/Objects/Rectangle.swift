//
//  Rectangle.swift
//  Shadow
//
//  Created by Developer on 4/25/24.
//

import Foundation
struct Rectangle:ObjProtocol,PhongAvailable{
    typealias vf3 = vector_float3
    let triangle1: Triangle
    let triangle2: Triangle
    var phongMat: PhongMaterial
    var alpha: Float32
    var ks: Float32
    init(v0:vf3,v1:vf3,v2:vf3,v3:vf3,phongMat:PhongMaterial,alpha:Float32,ks:Float32){
        triangle1 = .init(v0: v0, v1: v1, v2: v2, phongMat: phongMat,alpha: alpha,ks: ks)
        triangle2 = .init(v0: v0, v1: v2, v2: v3, phongMat: phongMat,alpha: alpha,ks: ks)
        self.alpha = alpha
        self.ks = ks
        self.phongMat = phongMat
    }
    func checkRayCollision(ray: inout Ray) -> Hit {
        let hit1 = triangle1.checkRayCollision(ray: &ray)
        let hit2 = triangle2.checkRayCollision(ray: &ray)
        if hit1.d >= 0 && hit2.d >= 0{
            return hit1.d > hit2.d ? hit2 : hit1
        }else if hit1.d >= 0{
            return hit1
        }else{
            return hit2
        }
    }
}
