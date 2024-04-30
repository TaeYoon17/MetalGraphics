//
//  PhongMaterial.swift
//  Shadow
//
//  Created by Developer on 4/25/24.
//

import Foundation
import simd
protocol PhongAvailable{
    var phongMat:PhongMaterial { get set }
    var alpha:Float32 {get set}
    var ks:Float32 { get set }
}
struct PhongMaterial{
    var amb: vector_float3
    var diff: vector_float3
    var spec: vector_float3
}
