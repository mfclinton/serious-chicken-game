/// @description Setup Entity

// --- Constants ---

GROUND_OBJECTS = [o_Rainbow, o_Entity_Block];

// --- State ---

// Entity State
current_health = MAX_HEALTH;
current_state = noone;
modifiers = ds_list_create();

// Time Scale
timescale = 1;

// Speed State
hsp = 0;
vsp = 0;

// Movement State
mov_hsp = 0;
mov_vsp = 0;

// Room State
enum EntityRoomState
{
	NEW,
	OUTSIDE_ROOM,
	INSIDE_ROOM
}

entity_room_state = EntityRoomState.NEW;

// --- Functions ---

// Health
function modify_health(value) {
	// No Modification
	if (value == 0)
		return;

	// Update Health	
    current_health = clamp(current_health + value, 0, MAX_HEALTH);

	// Events
	_on_health_modified(value);
}


// Movement
function update_speed() {
	// Update Speed
	var old_hsp = hsp;
	var old_vsp = vsp;
	
	// Process Move Speeds
	_set_move_hspeed();
	_set_move_vspeed();
	
	// Gravity
	_process_gravity();
	
	// Entity Speed
	_set_speed();
	
	// World Speed
	_process_world_speed();
	
	// Clamp
	_clamp_speed();
	
	// Events
	on_speed_changed(old_hsp, old_vsp);
}

function _set_move_hspeed() {

}

function _set_move_vspeed() {

}

function _set_speed() {
	hsp = mov_hsp;
	vsp = mov_vsp;
}

function _clamp_speed() {
	hsp = clamp(hsp, -TERMINAL_HSP, TERMINAL_HSP);
    vsp = clamp(vsp, -TERMINAL_VSP, TERMINAL_VSP);
}

function move_entity() {
    // Update position
	var old_x = x;
	var old_y = y;
	
	if (ENABLE_WALL_COLLISIONS)
		_set_position_with_collisions();
	else
		_set_position();
	
	// Events
	on_move(old_x, old_y);
}

function _set_position() {
	if (timescale == 0)
		return;

	x += hsp;
    y += vsp;
}

function _set_position_with_collisions() {
	if (timescale == 0)
		return;
	
	// New Position
	var new_x = x + hsp;
	var new_y = y + vsp;

    // Vertical
    if (place_meeting(x, new_y, GROUND_OBJECTS)) {
        while (!place_meeting(x, y + sign(vsp), GROUND_OBJECTS)) {
            y += sign(vsp);
        }
        vsp = 0;
		_on_vertical_collision();
    }
    y += vsp;

	// Horizontal
    x += hsp;
}

// Clamp Position
function clamp_in_bounds() {
	if (CLAMP_X_AXIS)
		x = clamp(x, 0, room_width - sprite_width);
	if (CLAMP_Y_AXIS)
		y = clamp(y, 0, room_height - sprite_height);
}


// Grounded
function is_grounded() {
	return place_meeting(x, y+1, GROUND_OBJECTS);
}

// On Ledge
function evaluate_ledge() {
	if (!is_on_ledge())
		return;
	
	_on_ledge_event();
}

function is_on_ledge() {
	var sprite_width_look_ahead = sprite_width * sign(hsp) / 2;
	return !place_meeting(x + hsp + sprite_width_look_ahead, y+1, GROUND_OBJECTS);
}

// Gravity
function _process_gravity() {
	// No Gravity
	if (GRAVITY == 0)
		return;
	
	// Grounded
	if (is_grounded() && mov_vsp >= 0)
	{
		mov_vsp = 0;
		return;
	}
	
	// Apply Gravity
    mov_vsp += GRAVITY * timescale * timescale;
}

// World Speed
function _process_world_speed() {
	if (!APPLY_WORLD_SPEED)
		return;
	
	hsp += o_GameManager.world_speed * timescale;
}

// Collision Resolution
function collision_resolution() {
	
	// Horizontal
    if (place_meeting(x, y, GROUND_OBJECTS)) {
		// Push Dir
		var dir = sign(mov_hsp);
		if (mov_hsp == 0)
			dir = -sign(o_GameManager.world_speed);
		
		// Push
        while (place_meeting(x, y, GROUND_OBJECTS)) {
            x -= dir;
        }
        mov_hsp = 0;
		hsp = 0;
		
		_on_horizontal_collision();
    }
}

// Set Timescale 
function set_timescale(new_timescale) {
	// Set Timescale
	image_speed = new_timescale;
	timescale = new_timescale;
	
	// Events
	on_timescale_changed();
}

// State
function update_state() {
	// Update State
	var prev_state = current_state;
	_set_current_state();
	
	// Events
	if (prev_state != current_state)
		on_state_changed(prev_state);
}

// Room State
function update_entity_room_state(new_entity_room_state) {
	// Update State
	var prev_state = entity_room_state;
	entity_room_state = new_entity_room_state;
	
	// Events
	if (prev_state != entity_room_state)
		_on_entity_room_state_changed();
}

function _set_current_state() {
	current_state = noone;
}

// Modifiers

function process_modifiers() {
	for (var i = ds_list_size(modifiers) - 1; i >= 0; i--) {
	    var modifier = modifiers[| i];
		modifier.step(modifier, self)
	}
}

function clean_up_modifers() {
	for (var i = ds_list_size(modifiers) - 1; i >= 0; i--) {
	    var modifier = modifiers[| i];
		modifier.clean();
	}
	
	ds_list_clear(modifiers);
}


// --- Events ---

// Health Modified Event
function _on_health_modified(value) { }

// Move Events
function on_speed_changed(old_hsp, old_vsp) { }
function on_move(old_x, old_y) { }

// State Changed Event
function on_state_changed(prev_state) { }

// Timescale Changed Event
function on_timescale_changed() { }

// Collision Events
function _on_horizontal_collision() { }
function _on_vertical_collision() { }

// Ledge Events
function _on_ledge_event() { }

// Room Events
function _on_entity_room_state_changed() { }