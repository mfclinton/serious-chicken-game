// --- Shader ---

function configure_shader_slider_fill(p, slider_horizontal_dir, alpha) {
	// Get UV Percentages
	var uv_ps = _calculate_uv_percentages(p)
	var shader_p = slider_horizontal_dir ? uv_ps[0] : uv_ps[1];
	
	// Set Fill Direction
	var cutoff_axis_location = shader_get_uniform(shader_slider_fill, "cutoff_axis");
	shader_set_uniform_i(cutoff_axis_location, !slider_horizontal_dir);

    // Set Fill Percentage
	var fill_percentage_location = shader_get_uniform(shader_slider_fill, "fill_percentage");
	shader_set_uniform_f(fill_percentage_location, shader_p);

	// Set Fill Color
	var fill_color_location = shader_get_uniform(shader_slider_fill, "fill_color");
	shader_set_uniform_f(fill_color_location, 1, 0, 0, 1);
	
	// Set Alpha
	var fill_alpha_location = shader_get_uniform(shader_slider_fill, "alpha");
	shader_set_uniform_f(fill_alpha_location, alpha);
}

function configure_shader_scrolling_background(uv_x_offset) {
	// Set UV Offset
	var uv_x_offset_location = shader_get_uniform(shader_scrolling_background, "uv_x_offset");
	shader_set_uniform_f(uv_x_offset_location, uv_x_offset);
}

// --- Helpers ---

function _calculate_uv_percentages(p) {
    // Get UVs
    var _tex = sprite_get_texture(sprite_index, image_index);
    var _uvs = texture_get_uvs(_tex);
    
    var uv_left = _uvs[0];
    var uv_top = _uvs[1];
    var uv_right = _uvs[2];
    var uv_bottom = _uvs[3];

    // Inverse Lerp
    var horizontal_p = uv_left + (uv_right - uv_left) * p;
    var vertical_p = uv_top + (uv_bottom - uv_top) * p;	

    // Return both values as an array
    return [horizontal_p, vertical_p];
}
