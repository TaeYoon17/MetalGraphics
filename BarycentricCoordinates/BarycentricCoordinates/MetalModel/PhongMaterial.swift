//
//  PhongMaterial.swift
//  BarycentricCoordinates
//
//  Created by Developer on 4/29/24.
//

import Foundation
import simd

protocol PhongProtocol{
    var phongMat: PhongMaterial { get set }
    var alpha:Float32 { get set }
    var ks: Float32 { get set }
}
struct PhongMaterial{
    var amb: vector_float3
    var diff: vector_float3
    var spec: vector_float3
}
