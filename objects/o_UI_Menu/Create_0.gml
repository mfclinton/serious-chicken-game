/// @description o_UI_Menu Create Script

// --- Constants ---

enum NavigationType {
    VERTICAL,
    HORIZONTAL,
	GRID
}


// --- Configuration ---

// Input Config
NAVIGATION_TYPE = NavigationType.VERTICAL;

// --- State ---

// Elements
current_index = 0;
element_list = [];

// Grid
grid_shape = []

// Input
index_delta = 0;

trigger_held = false;
trigger_released = false;

// State Audio Manager
audio_manager_on_selected = new AudioManager([SOUND_ON_SELECTED], 0);
audio_manager_on_pressed = new AudioManager([SOUND_ON_PRESSED], 0);
audio_manager_on_released = new AudioManager([SOUND_ON_RELEASED], 0);

// Selector Settings
blink_timer = 0;
blink_visible = true;

blink_timer_visible_duration = -1;
blink_timer_hidden_duration = 60 * 0.5;

// --- Setup ---

function add_element(element) {
	// Get Index
	var index = array_length(element_list);
	
	// Events
	array_push(element.on_selected_callbacks, create_selected_callback(index)); 
		
	// Add Element
	array_push(element_list, element);
	
	// Default Selected
	if (index == current_index)
		element_list[index].on_selected();
	
	// Result
	return index;
}

function add_element_audio_callbacks(element) {
	// Add Audio Event
	array_push(element.on_selected_callbacks, audio_manager_on_selected.play_random);
	array_push(element.on_press_callbacks, audio_manager_on_pressed.play_random);
	array_push(element.on_release_callbacks, audio_manager_on_released.play_random);
}


function create_element(obj, layer_name, configure_element_func) {
	// Create Element
	var element = instance_create_layer(0, 0, layer_name, obj);
	
	// Add Element to Menu
	var element_idx = add_element(element);
	
	// Configure Element
	configure_element_func(element, element_idx);
	
	// Add Audio Callbacks
	add_element_audio_callbacks(element);
	
	// Result
	return element;
}


function delete_menu() {
	// Delete UI Elements
	for (var i = 0; i < array_length(element_list); i++) {
	    instance_destroy(element_list[i]);
	}
}

// --- Overlay ---

function draw_screen_overlay() {
	if (!DRAW_OVERLAY)
		return;

	// Draw Overlay
    draw_set_alpha(0.2);
    draw_set_color(c_black);
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_alpha(1);
}

// --- Input Handling ---

function check_input() {
	// Vertical Input
	var up_pressed = keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
	var down_pressed = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"));
	var mov_vertical = down_pressed - up_pressed;

	// Horizontal Input
	var key_left = keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A"));
	var key_right = keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"));
	var mov_horizontal = key_right - key_left;
	
	// Navigation Input
	_update_index_delta(mov_horizontal, mov_vertical);
		
	// Trigger Input
	trigger_held = keyboard_check(vk_space) || keyboard_check(vk_enter) || keyboard_check(ord("E"));
	trigger_released = keyboard_check_released(vk_space) || keyboard_check_released(vk_enter) || keyboard_check_released(ord("E"))
}

function _update_index_delta(mov_horizontal, mov_vertical) {
	index_delta = 0;
	if (mov_horizontal == 0 && mov_vertical == 0)
		return;
	
	if (NAVIGATION_TYPE == NavigationType.VERTICAL)
		index_delta = mov_vertical;
	else if (NAVIGATION_TYPE == NavigationType.HORIZONTAL)
		index_delta = mov_horizontal;
	else if (NAVIGATION_TYPE == NavigationType.GRID)
		_calculate_grid_index_delta(mov_horizontal, mov_vertical);
}

function _calculate_grid_index_delta(mov_horizontal, mov_vertical) {
	// Grid Pos
	var grid_pos = _calculate_row_col_grid_index(current_index);
	
	// New Grid Pos
	var new_row_idx = grid_pos[0] + mov_vertical;
	var new_col_idx = grid_pos[1] + mov_horizontal;
	
	// Index Delta
	var new_index = _convert_grid_index_to_flat_index(new_row_idx, new_col_idx);
	index_delta = new_index - current_index; 
}

function _calculate_row_col_grid_index(index) {
	var total_elements = 0;
	var prev_total_elements = 0;
	for (var i = 0; i < array_length(grid_shape); ++i) {
		prev_total_elements = total_elements;
		total_elements += grid_shape[i];
		if (index < total_elements) {
			row_idx = i;
			col_idx = index - prev_total_elements;
			break;
		}
	}
	
	return [row_idx, col_idx];	
}

function _convert_grid_index_to_flat_index(_row, _col) {
	// Setup
	var num_rows = array_length(grid_shape);

	// New Row
	var new_row = (_row + num_rows) % num_rows;

	// New Col
	var new_row_num_cols = grid_shape[new_row];
	var new_col = _col;
	
	// Account for Row
    var index = 0;
    for (var i = 0; i < new_row; i++) {
        index += grid_shape[i];
    }
	
	// Account for Col
	index += new_col;

    return index;
}

function process_navigation_input() {
	// No Input
	if (index_delta == 0)
		return;
	
	var new_index;
	var new_index;
	if (CAN_LOOP_AROUND)
	    new_index = (current_index + index_delta + array_length(element_list)) % array_length(element_list);
	else
	    new_index = clamp(current_index + index_delta, 0, array_length(element_list) - 1);
	
	set_selected(new_index);
}

function process_trigger_input() {
	if (trigger_held)
		_on_selected_pressed();
	else if (trigger_released)
		_on_selected_released();
}

// --- Selected Handlers ---

function set_selected(new_index) {
	if (new_index == current_index)
		return;
	
	// Update Index
	var prev_index = current_index;
	current_index = new_index;
	
	// Events
	_on_selected_changed(prev_index);
}

function _on_selected_changed(prev_index) {
	// Update Selected
	element_list[prev_index].on_unselected();
	element_list[current_index].on_selected();
}

function _on_selected_pressed() {
	element_list[current_index].on_press();
}

function _on_selected_released() {
	element_list[current_index].on_release();
}

// --- Selector ---

function update_selector() {
	blink_timer++;
	
	// Get Blink Timer
	var blink_timer_toggle_thresh = blink_timer_visible_duration;
	if (!blink_visible)
		blink_timer_toggle_thresh = blink_timer_hidden_duration;

	// Toggle Blink
	if (blink_timer >= blink_timer_toggle_thresh && blink_timer_toggle_thresh > 0) {
		blink_visible = !blink_visible;
		blink_timer = 0;
	}
}

function draw_selector() {
    if (!SHOW_SELECTOR || !blink_visible)
        return;
    
	// Selected Element
    var selected_element = element_list[current_index];
    
    // Get Sprite Metadata
    var elem_width = sprite_get_width(selected_element.sprite_index);
    var elem_height = sprite_get_height(selected_element.sprite_index);
    
    // Padding
    var padding = 5;
    draw_sprite_ext(
        SELECTOR_SPRITE,
        0,
        selected_element.x - padding,
        selected_element.y - padding,
        (elem_width + padding * 2) / sprite_get_width(SELECTOR_SPRITE),
        (elem_height + padding * 2) / sprite_get_height(SELECTOR_SPRITE),
        0,
        c_white,
        1
    );
}


// --- Helpers ---

function create_selected_callback(i) {
	var closure = { menu: id, index: i }
    var func =  function() {
		menu.set_selected(index);
    };
	
	return method(closure, func);
}
