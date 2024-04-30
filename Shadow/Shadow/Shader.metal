//
//  Shader.metal
//  Shadow
//
//  Created by Developer on 4/25/24.
//

#include <metal_stdlib>
using namespace metal;

#include "MetalModels/definition.h"

struct Fragment{
    // 어느 위치에 있는 값인지 알려줘야 vertex쉐이더의 Return 타입으로 사용할 수 있다.
    float4 position [[position]];
    // 한 정점을 Fragment로 표현할 때 찍어줄 점의 크기
    float pointSize [[point_size]];
    float4 color;
};
vertex Fragment vertexShader(const device Vertex *vertexArray[[buffer(0)]],unsigned int vid [[vertex_id]]){
    Vertex ve = vertexArray[vid];
    Fragment frag;
    frag.color = ve.color;
    // 동차 좌표계에서 위치 좌표를 표현함
    frag.position = float4(ve.position,0,1);
    frag.pointSize = 8;
    return frag;
}
// 색상이 float4이다
fragment float4 fragmentShader(Fragment frag [[stage_in]]){
    return frag.color;
}
