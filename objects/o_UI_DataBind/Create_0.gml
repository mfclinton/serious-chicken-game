// --- Constants ---

enum DATABIND_STATES {
	INACTIVE,
	DISABLED,
	ENABLED
}

// --- Config ---

// State References
inactive_icon_sprite = noone;
disabled_icon_sprite = noone;
enabled_icon_sprite = noone;

// Anim Config
text_animation_speed = .15;

// UI References
icon_sprite = noone;
text_font = noone;

// UI Position Config
icon_y_offset = 0;
text_y_offset = 8;

icon_scale = 1.5
text_scale = 0.14

// --- State ---

value = 0;
state = DATABIND_STATES.INACTIVE;

// --- Draw Functions ---

function process_draw() {
	// Icon
	if (SHOW_ICON && icon_sprite != noone)
		_draw_icon();

	// Text
	if (SHOW_TEXT)
		_draw_text();
}

function _draw_icon() {
	draw_sprite_ext(
		icon_sprite,
		0,
		x,
		y + icon_y_offset,
		icon_scale,
		icon_scale,
		0,
		c_white,
		1
	);
}

function _draw_text() {
	draw_set_font(text_font);
	draw_set_color(make_color_rgb(255, 194, 28));

	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);

	var text = string(floor(value));
	draw_text_transformed(
	    x,
		y + text_y_offset,
	    text, 
	    text_scale, 
	    text_scale, 
	    0
	);
}

function _get_state_sprite() {
	switch(state) {
		case DATABIND_STATES.INACTIVE:
			return inactive_icon_sprite;
		case DATABIND_STATES.DISABLED:
			return disabled_icon_sprite;
		case DATABIND_STATES.ENABLED:
			return enabled_icon_sprite;
		default:
			return icon_sprite;
    }
}

// --- Step Functions ---

function update_target_value() {
	// Get Target Value
	var target_value = _get_target_value();
	if (value == target_value || target_value == undefined)
		return;
		
	// Move Towards
	var value_delta = sign(target_value - value) * text_animation_speed;
	value += value_delta;
	
	// Lock To
	if (abs(target_value - value) < text_animation_speed)
		value = target_value;

	// Event
	_on_value_updated(value_delta);
}

function update_target_state() {
	// Check State Change
	var target_state = _get_target_state();
	if (state == target_state)
		return;
	
	// Update State
	var old_state = state;
	state = target_state;

	// Update Sprite
	icon_sprite = _get_state_sprite();

	// Event
	_on_state_updated(old_state);
}

// --- Data Functions ---

function _get_target_value() { }

function _get_target_state() { }

// --- Update Functions ---

function _on_value_updated(value_delta) {
	
}

function _on_state_updated(old_state) {
	
}
