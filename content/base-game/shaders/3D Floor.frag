#pragma header

uniform float curveX;
uniform float curveY;

void main() {
    vec2 pos = openfl_TextureCoordv;
    vec2 newPos = vec2((openfl_TextureCoordv.x * (1.0 - openfl_TextureCoordv.y)) + ((openfl_TextureCoordv.x + curveX) * openfl_TextureCoordv.y), openfl_TextureCoordv.y * (1 + curveY));
    gl_FragColor = texture2D(bitmap, newPos);
}