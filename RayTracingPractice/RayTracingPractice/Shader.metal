//
//  Shader.metal
//  RayTracingPractice
//
//  Created by Developer on 3/31/24.
//

#include <metal_stdlib>
using namespace metal;

#include "MetalModels/definition.h"
struct Fragment{
    float4 position [[position]];
    float pointSize [[point_size]];
    float4 color;
};


vertex Fragment vertexShader(const device Vertex *vertexArray[[buffer(0)]],unsigned int vid [[vertex_id]]){
    Vertex input = vertexArray[vid];
    Fragment output;
    // 마지막이 0이면 벡터, 1이면 정점
    output.position = float4(input.position.x,input.position.y,0,1);
    output.color = float4(input.color);
    output.pointSize = 8;
    return output;
}
fragment float4 fragmentShader(Fragment input [[stage_in]]){
    return input.color;
}
