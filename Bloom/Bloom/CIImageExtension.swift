//
//  UIImageExtension.swift
//  Bloom
//
//  Created by 김태윤 on 2/7/24.
//

import UIKit
import MetalKit
import simd
extension CIImage{
    static func makeMTLTexture(device: MTLDevice)-> MTLTexture?{
        guard let imageURL = Bundle.main.url(forResource: "lemonMan", withExtension: "png") else {
            print("이미지가 없음")
            return nil
        }
        let ciImage = CIImage(contentsOf: imageURL, options: nil)
        guard let cgImage:CGImage = ciImage?.cgImage else {return nil}
        let width = cgImage.width
        let height = cgImage.height
        let bitsPerComponent = 8 // 256 depth
        let bytesPerPixel = 4 // r,g,b,a
        let bytesPerRow = width * bytesPerPixel
        // 이미지 데이터를 그대로 읽어들인다. -> C 언어적인 요소가 들어가 있음
        let imageData = UnsafeMutableRawPointer.allocate(byteCount: width * height * bytesPerPixel, alignment: bytesPerPixel)
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
//  장치 종속적 색 공간의 색은 출력 장치에 표시될 때 변형되거나 다른 방식으로 수정되지 않으므로 색의 시각적 모양을 유지하려고 시도하지 않습니다.
//  따라서 장치 색 공간의 색상이 다른 출력 장치에 표시될 때 다르게 나타나는 경우가 많습니다. 이러한 이유로 색 보존이 중요한 경우에는 디바이스 색 공간을 사용하지 않는 것이 좋습니다.
        let bitmapInfo: UInt32 = CGImageAlphaInfo.noneSkipLast.rawValue // CGContext는 Enum의 RawValue(Int Type)으로 구분한다.
        guard let context = CGContext(data: imageData,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: bitsPerComponent,
                                      bytesPerRow: bytesPerRow,
                                      space: colorSpace,
                                      bitmapInfo: bitmapInfo) else {
            return nil
        }
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .rgba8Unorm, width: width, height: height, mipmapped: false)
        let texture = device.makeTexture(descriptor: textureDescriptor)
        let region = MTLRegionMake2D(0, 0, width, height)
        texture?.replace(region: region, mipmapLevel: 0, withBytes: imageData, bytesPerRow: bytesPerRow)
        // 데이터 할당을 해제한다.
        imageData.deallocate()
        return texture
    }
}
func getRGBValues() -> [Vertex]? {
    guard let imageURL = Bundle.main.url(forResource: "lemonMan", withExtension: "png") else {
        print("이미지가 없음")
        return nil
    }
    guard let ciImage = CIImage(contentsOf: imageURL, options: nil) else {return nil}
    let ciContext = CIContext(options: nil)
    guard let cgImage:CGImage = ciContext.createCGImage(ciImage, from: ciImage.extent) else {
        return nil
    }
    
    let width = Int(ciImage.extent.width)
    let height = Int(ciImage.extent.height)
    guard let data:CFData = cgImage.dataProvider?.data else {
        return nil
    }
    
    let pointer = CFDataGetBytePtr(data) // CFData를 포인터로 가져오는 작업
    let bytesPerPixel = 4
    let bytesPerRow = cgImage.bytesPerRow
    var vetecies:[Vertex] = []
    
    for y in 0..<height {
        for x in 0..<width {
            let pixelInfo = y * bytesPerRow + x * bytesPerPixel
            let red = Float(pointer![pixelInfo]) / 255.0
            let green = Float(pointer![pixelInfo + 1]) / 255.0
            let blue = Float(pointer![pixelInfo + 2]) / 255.0
            // 이미지 Coordinates to Metal Coordinates
            // 원본 이미지의 Row 배열이 [1,2,3,4,5]라면 현제 Vertex에 담긴 배열은 [5,4,3,2,1]이 된다.
            // 메탈은 하나의 Row를 동시에 읽기 때문에 y좌표만 반대로 바꾸어서() 2차원 배열에 담는다.
            vetecies.append(Vertex(position: .init(x: 2*(Float(x) / Float(width) - 0.5),
                                                   y: -2*(Float(y) / Float(height) - 0.5)),
                                   color: [red,green,blue,1]))
        }
    }
    let startTime = DispatchTime.now()
    makeBloom(vertices: &vetecies, width: width, height: height, th: 0.33,weight: 0.2)
    let endTime = DispatchTime.now()
    let nanoTime = endTime.uptimeNanoseconds - startTime.uptimeNanoseconds
    let executionTime = Double(nanoTime) / 1_000_000_000 // 초 단위로 변환
    print("Execution time: \(executionTime) seconds")
    return vetecies
}
var weights: [Float] = [0.0545,0.2442,0.4026,0.2442,0.0545]
func makeGaussianBlur(vertices: inout [Vertex],width:Int,height:Int){
    for i in (0..<5){
        vertices = makeBlurX(width: width, height: height, vertices: vertices)
    }
    for i in (0..<5){
        vertices = makeBlurY(width: width, height: height, vertices: vertices)
    }
}
func makeBlurX(width:Int,height:Int,vertices: [Vertex]) -> [Vertex]{
    var temp:[Vertex] = []
    for y in 0..<height {
        for x in 0..<width {
            var ve = Vertex(position: .init(x: -2*(Float(x) / Float(width) - 0.5),
                                            y: -2*(Float(y) / Float(height) - 0.5)),
                            color: .zero)
            var i:Int = 0
            var colorSimd = SIMD4<Float>()
            for var nx in (x-2 ... x+2){
                nx = if nx < 0 || nx >= width{ x } else {nx}
                colorSimd += vertices[y*width + nx].color * weights[i]
                i += 1
            }
            colorSimd.w = 1
            ve.color = colorSimd
            temp.append(ve)
        }
    }
    return temp
}
func makeBlurY(width:Int,height:Int,vertices: [Vertex]) -> [Vertex]{
    var temp:[Vertex] = []
    for y in 0..<height{
        for x in 0..<width{
            var ve = Vertex(position: .init(x: -2*(Float(x) / Float(width) - 0.5), y: -2*(Float(y) / Float(height) - 0.5)), color: .zero)
            var i:Int = 0
            var colorSimd = SIMD4<Float>()
            for var ny in (y-2 ... y+2){
                ny = if ny < 0 || ny >= height{ y } else {ny}
                colorSimd += vertices[ny*width + x].color * weights[i]
                i += 1
            }
            colorSimd.w = 1
            ve.color = colorSimd
            temp.append(ve)
        }
    }
    return temp
}

// Relative Luminance Y = R:0.2126 G:0.7152 B:0.0722
func makeBloom(vertices: inout[Vertex],width:Int,height:Int,th: Float,weight: Float){
    var thVe = removeTh(vertices: vertices, width: width, height: height, th: th)
    makeGaussianBlur(vertices: &thVe, width: width, height: height)
    for i in (0..<vertices.count){
        var veColor = vertices[i].color
        var blurColor = thVe[i].color
        var newColor = (veColor * weight) + blurColor
        newColor.clamp(lowerBound: .init(0, 0, 0, 0), upperBound: .init(1, 1, 1, 1))
        newColor.w = 1
        vertices[i].color = newColor
    }
}
func removeTh(vertices: [Vertex],width:Int,height:Int,th: Float)->[Vertex]{
    var vertices = vertices
    for y in (0..<height){
        for x in (0..<width){
            var color = vertices[y*width + x].color * simd_float4(0.2126, 0.7152, 0.0722, 1)
            let luminanceY = color.sum() - 1
            if luminanceY < th{
                vertices[y*width + x].color = .init(0, 0, 0, 1)
            }
        }
    }
    return vertices
}
