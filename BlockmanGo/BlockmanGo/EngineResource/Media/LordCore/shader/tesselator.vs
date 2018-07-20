#version 100

attribute highp vec3 inPosition;
attribute vec4 inColor;
attribute vec2 inTexCoord;
attribute vec4 inTexCoord1;

uniform highp mat4 matWVP;
uniform vec4 fogParam[3];

varying vec4 oFogColor;
varying vec4 color;
varying vec2 texCoord_texture;
varying vec2 texCoord_lightmap;

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
	texCoord_lightmap.x = inTexCoord1.r;  // block light
	texCoord_lightmap.y = inTexCoord1.b;  // sky light
	
	color = inColor;
	oFogColor =  vec4(fogParam[1].rgb, ComputeFog(inPosition-fogParam[2].xyz, fogParam[0].xyz));
}

