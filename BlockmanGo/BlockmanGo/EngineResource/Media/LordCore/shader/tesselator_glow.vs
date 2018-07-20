#version 100

attribute vec3 inPosition;
attribute vec4 inColor;

uniform mat4 matWorld;
uniform mat4 matWVP;

varying vec4 color;

void main(void)
{
	vec4 worldPos = matWorld * vec4(inPosition, 1.0);
	gl_Position = matWVP * worldPos;
	
	color = inColor;
}



