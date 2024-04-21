//
//  Hit.swift
//  PerspectiveProjection
//
//  Created by Developer on 4/21/24.
//

import Foundation
import simd
struct Hit{
    var d: Float32
    var point: vector_float3
    var normal: vector_float3
    var obj: (any Obj)?
}
