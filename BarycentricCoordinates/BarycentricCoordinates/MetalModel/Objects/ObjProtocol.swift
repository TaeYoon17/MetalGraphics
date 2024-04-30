//
//  ObjProtocol.swift
//  BarycentricCoordinates
//
//  Created by Developer on 4/29/24.
//

import Foundation
protocol ObjProtocol:Identifiable{
    var id:UUID { get set }
    var alpha: Float32{ get set }
    var ks:Float32 { get set }
    func checkRayCollision(ray: inout Ray) -> Hit

    var phongMat:PhongMaterial{get set}
}
