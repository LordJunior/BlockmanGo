#version 100

#define MAX_BONE_NUM 60

attribute vec4 inPosition;
attribute vec3 inNormal;
attribute vec2 inTexCoord;
attribute vec4 inBlendIndices;
attribute vec3 inBlendWeights;

uniform mat4 matWVP;
uniform mat4 matWorld;

uniform vec4 fogParam;
uniform vec3 cameraPos;
uniform vec3 mainLightDir;
uniform vec4 mainLightColor;
uniform vec4 subLightColor;
uniform vec4 skyBlockOa;
uniform vec4 boneMatRows[3*MAX_BONE_NUM];

varying vec4 lightColor;
varying vec2 texCoord;

vec3 MulBone3( vec3 vInputPos, int nMatrix, float fBlendWeight )
{
    vec3 vResult;
    vResult.x = dot( vInputPos, boneMatRows[3*nMatrix+0].xyz );
    vResult.y = dot( vInputPos, boneMatRows[3*nMatrix+1].xyz );
    vResult.z = dot( vInputPos, boneMatRows[3*nMatrix+2].xyz );
    return vResult * fBlendWeight;
}

vec3 MulBone4( vec4 vInputPos, int nMatrix, float fBlendWeight )
{
    vec3 vResult;
    vResult.x = dot( vInputPos, boneMatRows[(3*nMatrix)+0].xyzw );
    vResult.y = dot( vInputPos, boneMatRows[(3*nMatrix)+1].xyzw );
    vResult.z = dot( vInputPos, boneMatRows[(3*nMatrix)+2].xyzw );
    return vResult * fBlendWeight;
}

float ComputeFog(vec3 camToWorldPos, vec3 param)
{
	float fdist = max(length(camToWorldPos) - param.x, 0.0);
	float density = clamp(clamp(fdist/(param.y-param.x), 0.0, 1.0) * param.z, 0.0, 1.0);
	return 1.0 - density;
}

void main(void)
{
	vec3 vPos;
	vec3 vNormal;
	vec4 vWorldPos;
    ivec3 BoneIndices;

	BoneIndices.x = int(inBlendIndices.x);
	BoneIndices.y = int(inBlendIndices.y);
	BoneIndices.z = int(inBlendIndices.z);
	
  	vPos = MulBone4(inPosition, BoneIndices.x, inBlendWeights.x)
  	 + MulBone4(inPosition, BoneIndices.y, inBlendWeights.y)
  	 + MulBone4(inPosition, BoneIndices.z, inBlendWeights.z);
	
	vNormal = MulBone3(inNormal, BoneIndices.x, inBlendWeights.x)
	 + MulBone3(inNormal, BoneIndices.y, inBlendWeights.y)
	 + MulBone3(inNormal, BoneIndices.z, inBlendWeights.z);
	// blend vertex position & normal
	vNormal = normalize(mat3(matWorld)*vNormal);
	
	vWorldPos = matWorld * vec4(vPos, 1.0);
	
	gl_Position = matWVP * vec4(vPos, 1.0);
	texCoord = inTexCoord;
	
	// skylight, blocklight, oa
	float sky_light = max(0.35, smoothstep(0.0, 1.0, skyBlockOa.x));
	float block_light = skyBlockOa.y  * 0.5;
	float oa = skyBlockOa.z;
	float ndl = clamp(dot(mainLightDir, vNormal) + 0.25, 0.4, 1.0);
	vec3 directL = sky_light *  mainLightColor.xyz * mainLightColor.w * ndl * oa;
	vec3 indirectL = subLightColor.xyz * subLightColor.w * sky_light * oa;
	float voxel_l = block_light * mix(4.0, 2.0, sky_light);
	float fakeNdotL = clamp(abs(vNormal.z) + vNormal.y, 0.4, 1.0);
	voxel_l = voxel_l * (fakeNdotL * 0.5 + 0.5) * 0.5 * oa;
	vec3 voxel_light = vec3(voxel_l, voxel_l, voxel_l);
	lightColor.xyz =(directL + indirectL + voxel_light);
	lightColor.w = ComputeFog(vWorldPos.xyz - cameraPos, fogParam.xyz);
}
