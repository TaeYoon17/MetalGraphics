//
//  Hit.swift
//  RayTracingPractice
//
//  Created by Developer on 3/31/24.
//

import Foundation

struct Hit{
    var d: Float32 // 광선의 시작부터 충돌 지점까지의 거리
    var point: vector_float3
    var normal: vector_float3
    var obje: (any Obje)?
}
