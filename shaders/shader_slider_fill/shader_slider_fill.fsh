//
// Fragment shader for slider fill effect
//

// Passed from Vertex Shader
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

// Uniforms
uniform int cutoff_axis; // 0 = X, 1 = Y
uniform float fill_percentage;
uniform vec4 fill_color;
uniform float alpha;

void main()
{
    // Texture Color
    vec4 tex_color = texture2D(gm_BaseTexture, v_vTexcoord) * v_vColour;

    // Cutoff
	bool before_cutoff_x = (cutoff_axis == 0 && v_vTexcoord.x <= fill_percentage);
	bool before_cutoff_y = (cutoff_axis == 1 && v_vTexcoord.y <= fill_percentage);
    if (before_cutoff_x || before_cutoff_y) {
        tex_color *= fill_color;
	}
	else {
		tex_color *= vec4(0,0,0,1);	
	}
	
	// Multiply Alpha
	tex_color *= vec4(1, 1, 1, alpha);
	
	// Set Color
    gl_FragColor = tex_color;
}
