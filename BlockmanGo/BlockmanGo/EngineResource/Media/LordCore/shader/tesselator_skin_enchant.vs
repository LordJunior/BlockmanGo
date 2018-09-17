#version 100

#define MAX_BONE_NUM 60

attribute vec4 inPosition;
attribute vec4 inNormal;
attribute vec2 inTexCoord;
attribute vec4 inColor;

uniform mat4 matWVP;
uniform mat4 matWorld;
uniform vec4 fogParam;
uniform vec3 cameraPos;
uniform vec3 mainLightDir;
uniform vec4 mainLightColor;
uniform vec4 subLightColor;
uniform vec4 extraSkyBlockLight;
uniform vec4 extraVertexColor;
uniform mat4 matTexture1;
uniform mat4 matTexture2;
uniform vec4 texAtlas;

uniform vec4 boneMatRows[3*MAX_BONE_NUM];

varying vec4 lightColor;
varying vec2 texCoord1;
varying vec2 texCoord2;

vec3 MulBone3(vec3 vInputPos, int nMatrix)
{
    vec3 vResult;
    vResult.x = dot( vInputPos, boneMatRows[3*nMatrix+0].xyz );
    vResult.y = dot( vInputPos, boneMatRows[3*nMatrix+1].xyz );
    vResult.z = dot( vInputPos, boneMatRows[3*nMatrix+2].xyz );
    return vResult;
}

vec3 MulBone4(vec4 vInputPos, int nMatrix)
{
    vec3 vResult;
    vResult.x = dot( vInputPos, boneMatRows[(3*nMatrix)+0].xyzw );
    vResult.y = dot( vInputPos, boneMatRows[(3*nMatrix)+1].xyzw );
    vResult.z = dot( vInputPos, boneMatRows[(3*nMatrix)+2].xyzw );
    return vResult;
}

float ComputeFog(vec3 camToWorldPos, vec3 param)
{
	float fdist = max(length(camToWorldPos) - param.x, 0.0);
	float density = clamp(clamp(fdist/(param.y-param.x), 0.0, 1.0) * param.z, 0.0, 1.0);
	return 1.0 - density;
}

void main(void)
{
	vec3 blockPos = (inPosition.xyz / 127.0 - 1.0) * 8.0;
	vec3 vNormal = inNormal.xyz / 127.0 - 1.0;
	vNormal = normalize(vNormal);
	vec2 texCoord = inTexCoord / 2048.0;
	vec3 color = inColor.rgb / 255.0;
	color *= extraVertexColor.rgb;
	int BoneIndices = int(inColor.a);
	
	vec4 vTexture;
	vec4 vEnchantTex;
	vTexture.x = (texCoord.x - texAtlas.x) / texAtlas.z;
	vTexture.y = (texCoord.y - texAtlas.y) / texAtlas.w;
	vTexture.z = 1.0;
	vTexture.w = 1.0;
	vEnchantTex = matTexture1 * vTexture;
	texCoord1 = vEnchantTex.xy;
	vEnchantTex = matTexture2 * vTexture;
	texCoord2 = vEnchantTex.xy;
		
	vec3 vPos = MulBone4(vec4(blockPos, 1.0), BoneIndices);
	vec4 vWorldPos = matWorld * vec4(vPos, 1.0);
	vNormal = MulBone3(vNormal, BoneIndices);
	vNormal = mat3(matWorld) * vNormal;
	
	gl_Position = matWVP * vec4(vPos, 1.0);
	
	// lighting params
	// sky light correction.
	float sky_light = max(0.35, smoothstep(0.0, 1.0, (inPosition.w / 255.0) * extraSkyBlockLight.r));
	float block_light = (inNormal.w / 255.0)  * 0.5 * extraSkyBlockLight.g;
	float oa = 0.5 * extraSkyBlockLight.b;

	// lighting
	float ndl = clamp(dot(mainLightDir, vNormal) + 0.25, 0.4, 1.0);
	vec3 directL = sky_light *  mainLightColor.xyz * mainLightColor.w * ndl * oa;
	vec3 indirectL = subLightColor.xyz * subLightColor.w * sky_light * oa;
	float voxel_l = block_light * mix(4.0, 2.0, sky_light);
	float fakeNdotL = clamp(abs(vNormal.z) + vNormal.y, 0.4, 1.0);
	voxel_l = voxel_l * (fakeNdotL * 0.5 + 0.5) * 0.5 * oa;
	vec3 voxel_light = vec3(voxel_l, voxel_l, voxel_l);
	lightColor.xyz =(directL + indirectL + voxel_light) * color.rgb;
	lightColor.w = ComputeFog(vWorldPos.xyz - cameraPos, fogParam.xyz);
}

