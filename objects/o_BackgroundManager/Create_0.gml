// --- Config ---

scroll_speed_x = .05;

transition_speed = 0.005;

// --- State ---

// Transition
cur_sprite = s_Clouds_Background_Light;
next_sprite = s_Clouds_Background_Light;

transition_progress = 0;

// Scroll
scroll_x = 0;


// --- Draw ---

function draw_background() {
    _draw_stretched_sprite(cur_sprite);
}

function draw_transitioned_background() {
	if (transition_progress <= 0)
		return;
	
    _draw_stretched_sprite(next_sprite, transition_progress);
}

function _draw_stretched_sprite(sprite, alpha = 1) {
	var scale_x = room_width / sprite_get_width(sprite);
    var scale_y = room_height / sprite_get_height(sprite);
    
	// Shader
	shader_set(shader_scrolling_background);

	// UV X Offset
	var uv_x_offset = scroll_x / sprite_get_width(cur_sprite);
	configure_shader_scrolling_background(uv_x_offset)
	
	// Draw
    draw_sprite_ext(
        sprite,
        0,
        0,
        0,
        scale_x,
        scale_y,
        0,
        c_white,
        alpha
    );
	
	// Reset Shader
	shader_reset();
}

// --- Transition ---

function update_transition_progress() {
	// Is Transitioning
	var is_transitioning = cur_sprite != next_sprite && next_sprite != noone;
    if (!is_transitioning)
		return;
	
	// Update Transition Progress
	transition_progress += transition_speed;
	transition_progress = clamp(transition_progress, 0, 1);
}

function check_transition_completed() {
	if(transition_progress < 1)
		return;
		
	// Update Sprite
	cur_sprite = next_sprite;
	next_sprite = noone;
	transition_progress = 0;
	
	// Trigger Event
	_on_transition_completed();
}

// --- Scroll ---

function process_scroll() {
	scroll_x += scroll_speed_x;	
}

// --- Events ---

function _on_transition_completed() {
	
}
