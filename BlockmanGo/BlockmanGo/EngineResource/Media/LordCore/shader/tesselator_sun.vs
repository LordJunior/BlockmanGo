#version 100

attribute vec3 inPosition;
attribute vec2 inTexCoord;

uniform mat4 matWorld;
uniform mat4 matWVP;

varying vec2 texCoord;

void main(void)
{
	vec4 worldPos = matWorld * vec4(inPosition, 1.0);
	gl_Position = matWVP * worldPos;
	
	texCoord = inTexCoord;
}



