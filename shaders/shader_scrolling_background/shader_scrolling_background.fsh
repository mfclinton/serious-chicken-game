//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float uv_x_offset;

void main()
{
	// UV
	vec2 uv = v_vTexcoord;
    uv.x = fract(uv.x + uv_x_offset);
	
    gl_FragColor = v_vColour * texture2D( gm_BaseTexture, uv );
}
