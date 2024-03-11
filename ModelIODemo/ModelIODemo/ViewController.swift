//
//  ViewController.swift
//  ModelIODemo
//
//  Created by 김태윤 on 1/14/24.
//

import Cocoa
import ModelIO
/// 1. MDLAsset
/// 2. MDLMesh
/// 3. MDLVoxelArray
class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let asset = MDLAsset(url: .applicationDirectory)
        do{
            try asset.export(to: .applicationDirectory)
            
        }catch{
            print(error)
        }
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    func makeMesh(){
//        var mesh = MDLMesh()
//        mesh.generateLightMapVertexColorsWithLights(toConsider: [.init()], objectsToConsider: [.init()], vertexAttributeNamed: "helloworld")
//        mesh.generateLightMapTexture(withQuality: <#T##Float#>, lightsToConsider: <#T##[MDLLight]#>, objectsToConsider: <#T##[MDLObject]#>, vertexAttributeNamed: <#T##String#>, materialPropertyNamed: <#T##String#>)
//        mesh.addNormals(withAttributeNamed: <#T##String?#>, creaseThreshold: <#T##Float#>)
//        mesh.addTangentBasis(forTextureCoordinateAttributeNamed: <#T##String#>, normalAttributeNamed: <#T##String#>, tangentAttributeNamed: <#T##String#>)
    }
    func makeVoxel(){
        // 애셋으로부터 복셀들 불러오기
        var voxels = MDLVoxelArray(asset: <#T##MDLAsset#>, divisions: <#T##Int32#>, patchRadius: <#T##Float#>)
//        var data:Data? = voxel.voxels(within: <#T##MDLVoxelIndexExtent#>) // 특정 위치에서 복셀들 찾기
//        voxels.union(with: <#T##MDLVoxelArray#>) // 고정 지오메트리에 구성
//        var mesh = voxels.mesh(using: <#T##MDLMeshBufferAllocator?#>) // 복셀로부터 메시 만들기
        
    }
}

