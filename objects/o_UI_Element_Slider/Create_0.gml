/// @description Implement Volume Slider

// --- Inheritance ---

event_inherited();


// --- Properties ---

// Events
on_p_modified_callbacks = [];


// --- State ---

current_p = 0;
alpha = 1;


// --- Input Functions ---

function check_input() {
	// Keys
	var key_left = keyboard_check(vk_left) || keyboard_check(ord("A"));
	var key_right = keyboard_check(vk_right) || keyboard_check(ord("D"));
	var key_up = keyboard_check(vk_up) || keyboard_check(ord("W"));
	var key_down = keyboard_check(vk_down) || keyboard_check(ord("S"));
	
    key_delta = SLIDER_HORIZONTAL_DIR ? (key_right - key_left) : (key_up - key_down);
	
	// Mouse P
	mouse_p_x = (mouse_x - x + (sprite_width / 2)) / sprite_width;
	mouse_p_y = (mouse_y - y + (sprite_height / 2)) / sprite_height;
	
	mouse_p_x = clamp(mouse_p_x, 0, 1);
	mouse_p_y = clamp(mouse_p_y, 0, 1);
}


function process_key_input() {	
	// Set Volume
	var new_p = clamp(current_p + key_delta * SLIDER_KEY_SENSITIVITY, 0, 1);
	set_p(new_p);
}


function process_mouse_input() {
	// Mouse Percentage
	var new_p = SLIDER_HORIZONTAL_DIR ? mouse_p_x : mouse_p_y;
	set_p(new_p);
}

function process_input() {
	if (current_state == UIElementState.PRESSED)
		process_mouse_input();
	else if (current_state == UIElementState.SELECTED)
		process_key_input();
}


// --- Draw Functions ---

function draw_handle() {
	// Get Handle Position
    var handle_x = x;
	var handle_y = y;

    if (SLIDER_HORIZONTAL_DIR)
        handle_x = x + sprite_width * (current_p - 0.5);
    else
        handle_y = y + sprite_height * (current_p - 0.5);
    
    // Draw Handle
    draw_sprite(SLIDER_HANDLE_SPRITE, 0, handle_x, handle_y);
}

function _draw_slider_fill() {
    // Activate Shader
    shader_set(shader_slider_fill);

	// Configure Shader
	configure_shader_slider_fill(current_p, SLIDER_HORIZONTAL_DIR, alpha);

    // Draw Sprite
    draw_self();

    // Reset Shader
    shader_reset();
}


// --- Helpers ---

function set_p(new_p) {
	// Update P
	var old_p = current_p;
	current_p = new_p;
	
	// Events
	on_p_modified(old_p);
}


function _trigger_p_modified_events() {
	for (var i = 0; i < array_length(on_p_modified_callbacks); i++) {
		on_p_modified_callbacks[i](current_p);
	}
}


// --- Events ---

function on_p_modified(old_p) {
	_trigger_p_modified_events();
}

// --- Overrides ---

function _draw_bg() {
	_draw_slider_fill();
}
