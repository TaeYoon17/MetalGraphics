//
//  Shader.metal
//  BarycentricCoordinates
//
//  Created by Developer on 4/29/24.
//

#include <metal_stdlib>
using namespace metal;

#include "MetalModel/definition.h"

struct Fragment{
    float4 position [[position]];
    float pointSize [[point_size]];
    float4 color;
};

vertex Fragment vertexShader(const device Vertex *vertexArray[[buffer(0)]],unsigned int vid [[vertex_id]]){
    Vertex ve = vertexArray[vid];
    Fragment frag;
    frag.color = ve.color;
    frag.position = float4(ve.position,0,1);
    frag.pointSize = 8;
    return frag;
}

fragment float4 fragmentShader(Fragment frag [[stage_in]]){
    return frag.color;
}
