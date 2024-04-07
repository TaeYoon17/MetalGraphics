//
//  Obje.swift
//  DrawingTriangle
//
//  Created by Developer on 4/8/24.
//

import Foundation
import simd
protocol Obje: Hashable{
//    var amb: vector_float3 { get set }
//    var dif: vector_float3 {get set}
//    var spec: vector_float3 {get set}
    func checkRayCollision(ray: inout Ray) -> Hit
    var color: vector_float3 {get set}
}
