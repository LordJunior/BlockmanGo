#version 100

attribute vec4 inPosition;
attribute vec4 inNormal;
attribute vec2 inTexCoord;
attribute vec4 inColor;

uniform mat4 matWVP;
uniform vec4 sectionPos;
uniform vec4 fogParam;
uniform vec4 uvTime;

uniform vec3 cameraPos;
uniform vec3 nightVersion;
uniform vec3 mainLightDir;
uniform vec4 mainLightColor;
uniform vec4 subLightColor;

varying vec4 lightColor;
varying vec2 texCoord_texture;

float ComputeFog(vec3 camToWorldPos, vec3 param)
{
	float fdist = max(length(camToWorldPos) - param.x, 0.0);
	float density = clamp(clamp(fdist/(param.y-param.x), 0.0, 1.0) * param.z, 0.0, 1.0);
	return 1.0 - density;
}

void main(void)
{
	vec3 blockPos;
	blockPos = inPosition.xyz / 15.0;
	
	vec3 vNormal;
	vNormal = inNormal.xyz / 127.0 - 1.0;
	vNormal = normalize(vNormal);

	texCoord_texture = inTexCoord / 2048.0;
	texCoord_texture = texCoord_texture + vec2(uvTime.xy * uvTime.zw);

	float sky_light = inPosition.w / 255.0 + nightVersion.x;
	// sky light correction.
	sky_light = clamp(sky_light, 0.35, 1.0);

	float block_light = (inNormal.w / 255.0 + nightVersion.y) * 0.5;
	
	float oa = inColor.a * 0.5  + nightVersion.z;

	// output position.
	blockPos = sectionPos.xyz + blockPos;
	gl_Position = matWVP * vec4(blockPos, 1.0);

	// Direct Lightting.
	vec3 directL;
	// 0.25 is SSS_INTENSITY
	float ndl = clamp(dot(mainLightDir, vNormal) + 0.25, 0.4, 1.0);
	directL = sky_light *  mainLightColor.xyz * mainLightColor.w * ndl * oa;
	
	// Indirect Lightting.
	vec3 indirectL = subLightColor.xyz * subLightColor.w * sky_light * oa;

	// block(point) lightting
	float voxel_l = block_light * mix(4.0, 2.0, sky_light);
	
	// calculate fake N*L
	float fakeNdotL = clamp(abs(vNormal.z) + vNormal.y, 0.0, 1.0);
	voxel_l = voxel_l * (fakeNdotL * 0.5 + 0.5) * 0.5 * oa;
	vec3 voxel_light = vec3(voxel_l, voxel_l, voxel_l);

	lightColor.xyz =(directL + indirectL + voxel_light) * inColor.rgb;
	lightColor.w = ComputeFog(blockPos - cameraPos, fogParam.xyz);
}
