//
//  Obj.swift
//  PerspectiveProjection
//
//  Created by Developer on 4/21/24.
//

import Foundation
import simd
protocol Obj{
    var phongMat: PhongMaterial { get set }
    var color: vector_float3 {get set}
    var alpha: Float32 { get set }
    var ks: Float32{ get set}
    func checkRayCollision(ray: inout Ray) -> Hit
}
