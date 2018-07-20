#version 100

attribute vec3 inPosition;
attribute vec3 inNormal;
attribute vec4 inColor;
attribute vec2 inTexCoord;

uniform mat4 matWVP;
uniform mat4 matWorld;
uniform mat4 matTexture1;
uniform mat4 matTexture2;
uniform vec4 fogParam[3];
uniform vec3 mainLightDir;
uniform vec4 mainLightColor;
uniform vec3 subLightDir;
uniform vec4 subLightColor;
uniform vec4 brightness;
uniform vec4 ambient;

varying vec4 oFogColor;
varying vec4 color;
varying vec2 texCoord1;
varying vec2 texCoord2;

float ComputeFog(vec3 camToWorldPos, vec3 param)
{
	float fdist = max(length(camToWorldPos) - param.x, 0.0);
	float density = clamp(clamp(fdist/(param.y-param.x), 0.0, 1.0) * param.z, 0.0, 1.0);
	return 1.0 - density;
}

void main(void)
{
	vec4 vWorldPos;
	vec3 vNorm;
	vec4 vTexture;
	vec4 vEnchantTex;

	vWorldPos = matWorld * vec4(inPosition, 1.0);
	vNorm = mat3(matWorld) * inNormal;
	vNorm = normalize(vNorm);
	
	gl_Position = matWVP * vec4(inPosition, 1.0);

	vTexture.xy = inTexCoord;
	vTexture.z = 1.0;
	vTexture.w = 1.0;
	vEnchantTex = matTexture1 * vTexture;
	texCoord1 = vEnchantTex.xy;
	vEnchantTex = matTexture2 * vTexture;
	texCoord2 = vEnchantTex.xy;
	
	float mainParam = max(dot(mainLightDir, vNorm), 0.0);
	float subParam = max(dot(subLightDir, vNorm), 0.0);

	color = mainParam * mainLightColor + subParam * subLightColor;
	color = (color + ambient) * inColor * brightness;
	oFogColor =  vec4(fogParam[1].rgb, ComputeFog(vWorldPos.xyz - fogParam[2].xyz, fogParam[0].xyz));
}
