#version 100

attribute vec3 inPosition;
attribute vec4 inColor;

uniform mat4 matWVP;

varying vec4 color;

void main(void)
{
	gl_Position = matWVP * vec4(inPosition, 1.0);

	color = inColor;
}

