#version 120

uniform sampler2D texture;
uniform sampler2D desktop;
uniform vec2 screenSize;

varying vec2 uvCoord;

void main()
{
    vec4 color = texture2D(desktop, vec2(uvCoord.x, -uvCoord.y));
    vec4 tcolor = texture2D(texture, uvCoord);

    // Output the original colors without any blur effect
    gl_FragColor = color * tcolor;
}
