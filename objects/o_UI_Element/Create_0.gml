/// @description UI Element Setup Configuration

// --- Constants ---

enum UIElementState {
    DEFAULT,
    SELECTED,
    PRESSED
}


// --- Properties ---

// State
current_state = UIElementState.DEFAULT;

// Events
on_press_callbacks = [];
on_release_callbacks = [];
on_selected_callbacks = [];
on_unselected_callbacks = [];


// --- Main Draw Functions ---

// Draw State
function draw_state() {
	if (current_state == UIElementState.DEFAULT)
		_draw_default_state();
	else if (current_state == UIElementState.SELECTED)
		_draw_selected_state();
	else if (current_state == UIElementState.PRESSED)
		_draw_pressed_state();
}

// Draw
function _draw() {
	if (BACKGROUND_VISIBLE)
		_draw_bg();

	if (TEXT != "")
		_draw_text();
}

// Draw BG
function _draw_bg() {
	draw_self();
}

// Draw Text
function _draw_text() {
	// Set Font
    draw_set_font(FONT);
	
	// Set Font Pos
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

	// Calculate Text Scale
    var max_width = sprite_width;
    var max_height = sprite_height;
    var text_scale = min(max_width / string_width(TEXT), max_height / string_height(TEXT)) * TEXT_SCALE_MULTIPLIER;
	
	if (TEXT_SCALE > 0)
		text_scale = TEXT_SCALE;
    
	// Draw Text
    draw_text_transformed(x + TEXT_OFFSET_X, y + TEXT_OFFSET_Y, TEXT, text_scale, text_scale, 0);
    
    // Reset Settings
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

// Draw With Opacity
function _draw_helper(color, opacity) {
	// Set Color and Opacity
	draw_set_color(color);
	draw_set_alpha(opacity);
	
	// Draw
    _draw();
	
	// Reset Color and Opacity
	draw_set_color(c_white); 
    draw_set_alpha(1);
}


// --- Draw State Functions ---

function _draw_default_state() {
	_draw_helper(c_gray, 1);
}

function _draw_selected_state() {
	_draw_helper(c_dkgray, 1);
}

function _draw_pressed_state() {
	_draw_helper(c_black, 1);
}


// --- State Management ---

function _update_state(new_state) {
	// Update State
	var prev_state = current_state;
	current_state = new_state;
	
	// Events
	if (prev_state != current_state)
		_on_state_changed(prev_state);
}


// --- Input Event Helpers ---

function subscribe_event(event_list, callback) {
	array_push(event_list, callback);
}

function _trigger_event(event_list) {
	for (var i = 0; i < array_length(event_list); i++) {
		event_list[i]();
	}
}


// --- Event Callbacks ---

// State Event
function _on_state_changed(prev_state) { }

// Input Events
function on_press() {
	_update_state(UIElementState.PRESSED);
	_trigger_event(on_press_callbacks);
}

function on_release() {
	_update_state(UIElementState.SELECTED);
	_trigger_event(on_release_callbacks);
}

function on_selected() {
	_update_state(UIElementState.SELECTED);
	_trigger_event(on_selected_callbacks);
}

function on_unselected() {
	_update_state(UIElementState.DEFAULT);
	_trigger_event(on_unselected_callbacks);
}
