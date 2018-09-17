#version 100

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
uniform vec4 skyBlockLight;

varying vec4 lightColor;
varying vec2 texCoord;

float ComputeFog(vec3 camToWorldPos, vec3 param)
{
	float fdist = max(length(camToWorldPos) - param.x, 0.0);
	float density = clamp(clamp(fdist/(param.y-param.x), 0.0, 1.0) * param.z, 0.0, 1.0);
	return 1.0 - density;
}

void main(void)
{
	vec3 blockPos = (inPosition.xyz / 127.0 - 1.0) * 2.0;
	vec3 vNormal = inNormal.xyz / 127.0 - 1.0;
	vNormal = normalize(vNormal);

	vec4 vWorldPos = matWorld * vec4(blockPos, 1.0);
	vNormal = mat3(matWorld) * vNormal;
		
	texCoord = inTexCoord / 2048.0;
	
	gl_Position = matWVP * vec4(blockPos, 1.0);
	
	float sky_light = max(0.35, smoothstep(0.0, 1.0, skyBlockLight.r));
	float block_light = skyBlockLight.g * 0.5;
	float oa = skyBlockLight.b;

	// lighting
	float ndl = clamp(dot(mainLightDir, vNormal) + 0.25, 0.4, 1.0);
	vec3 directL = sky_light *  mainLightColor.xyz * mainLightColor.w * ndl * oa;
	vec3 indirectL = subLightColor.xyz * subLightColor.w * sky_light * oa;
	float voxel_l = block_light * mix(4.0, 2.0, sky_light);
	float fakeNdotL = clamp(abs(vNormal.z) + vNormal.y, 0.4, 1.0);
	voxel_l = voxel_l * (fakeNdotL * 0.5 + 0.5) * 0.5 * oa;
	vec3 voxel_light = vec3(voxel_l, voxel_l, voxel_l);
	lightColor.xyz =(directL + indirectL + voxel_light) * inColor.rgb;
	lightColor.w = ComputeFog(vWorldPos.xyz - cameraPos, fogParam.xyz);
}
