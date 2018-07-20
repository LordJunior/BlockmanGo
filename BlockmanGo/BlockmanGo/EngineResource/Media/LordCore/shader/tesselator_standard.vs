#version 100

attribute vec3 inPosition;
attribute vec2 inTexCoord;

uniform mat4 matWVP;
uniform vec4 fogParam[3];

varying vec4 oFogColor;
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
	oFogColor =  vec4(fogParam[1].rgb, ComputeFog(inPosition-fogParam[2].xyz, fogParam[0].xyz));
}


