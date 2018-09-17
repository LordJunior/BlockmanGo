#version 100

attribute highp vec3 inPosition;
attribute vec4 inColor;
attribute vec2 inTexCoord;
attribute vec4 inTexCoord1;

uniform highp mat4 matWVP;
uniform vec4 fogParam;

uniform vec3 cameraPos;
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
	gl_Position = matWVP * vec4(inPosition, 1.0);

	texCoord_texture = inTexCoord;
	
	// lighting params
	float sky_light = max(0.35, smoothstep(0.0, 1.0, inTexCoord1.r));
	float block_light = inTexCoord1.b  * 0.5;
	float oa = 0.5;

	// lighting
	vec3 directL = sky_light *  mainLightColor.xyz * mainLightColor.w * oa;
	vec3 indirectL = subLightColor.xyz * subLightColor.w * sky_light * oa;
	float voxel_l = block_light * mix(4.0, 2.0, sky_light);
	voxel_l = voxel_l * oa * oa;
	vec3 voxel_light = vec3(voxel_l, voxel_l, voxel_l);
	lightColor.xyz =(directL + indirectL + voxel_light) * inColor.rgb;
	lightColor.w = ComputeFog(inPosition - cameraPos, fogParam.xyz);
}
