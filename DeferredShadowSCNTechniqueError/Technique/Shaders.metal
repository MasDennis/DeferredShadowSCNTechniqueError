#include <metal_stdlib>
using namespace metal;
#include <SceneKit/scn_metal>

constexpr sampler s = sampler(coord::normalized,
                              r_address::clamp_to_edge,
                              t_address::repeat,
                              filter::linear);

struct CustomNode {
    float4x4 modelViewProjectionTransform;
};

struct VertexIn
{
    float4 position [[attribute(SCNVertexSemanticPosition)]];
    float4 normal [[attribute(SCNVertexSemanticNormal)]];
};

struct VertexOut
{
    float4 position [[position]];
    float2 uv;
    float4 normal;
};

vertex VertexOut colour_overlay_vertex(VertexIn in [[stage_in]],
                                  constant CustomNode& scn_node [[buffer(0)]])
{
    VertexOut out;
    out.position = scn_node.modelViewProjectionTransform * float4(in.position.xyz, 1.0);
    return out;
};

fragment half4 colour_overlay_fragment(VertexOut in [[stage_in]],
                                  texture2d<float, access::sample> colorSampler [[texture(0)]])
{
    return half4(0.0, 1.0, 0.0, 1.0);
};

vertex VertexOut combine_vertex(VertexIn in [[stage_in]],
                                constant SCNSceneBuffer& scn_frame [[buffer(1)]])
{
    VertexOut out;
    out.position = in.position;
    out.uv = float2( (in.position.x + 1.0) * 0.5, 1.0 - (in.position.y + 1.0) * 0.5 );
    return out;
};

fragment half4 combine_fragment(VertexOut vert [[stage_in]],
                                texture2d<float, access::sample> colorSampler [[texture(0)]],
                                texture2d<float, access::sample> overlaySampler [[texture(1)]])
{
    float4 fragmentColor = colorSampler.sample(s, vert.uv);
    float4 overlayColor = overlaySampler.sample(s, vert.uv);
    
    if (overlayColor.g < 1.0 ) {
        return half4(fragmentColor);
    }
    
    return half4(overlayColor);
}
