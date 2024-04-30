//
//  Hit.swift
//  BarycentricCoordinates
//
//  Created by Developer on 4/29/24.
//

import Foundation

struct Hit{
    var d: Float32
    var point: vector_float3
    var normal: vector_float3
    var obj: (any ObjProtocol)?
    var w: vector_float2!
}
