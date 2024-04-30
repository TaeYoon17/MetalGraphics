//
//  ObjeProtocol.swift
//  Shadow
//
//  Created by Developer on 4/25/24.
//

import Foundation
protocol ObjProtocol{
    var alpha:Float32 {get set}
    var ks:Float32 { get set }
    func checkRayCollision(ray: inout Ray) -> Hit

    var phongMat:PhongMaterial{get set}
}
