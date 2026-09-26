/// @description Override Player Entity Setup

// --- Inheritance ---
event_inherited();

// --- Constants ---

enum PLAYER_STATES {
	IDLE,
	JUMPING,
	FALLING,
	WALKING,
	GLIDING,
	DEAD
}


// --- State ---

// Player State
current_state = PLAYER_STATES.IDLE;

// Jump State
jump_buffer_timer = 0;

jump_counter = 0;
jump_timer = 0;

grounded_counter = 0;

// Glide State
glide_toggle = false;

// Off Screen State
offscreen_frames_counter = 0;


// Initial Visual Modifier
var loadout = global.loadouts[global.selected_loadout_index];
ds_list_add(modifiers, loadout.modifier);


// --- Input Events ---

function check_input() {
	// No Input When Dead
	if (current_state == PLAYER_STATES.DEAD) {
		reset_input();
		return;
	}
	
	// Get Input
    key_left = keyboard_check(vk_left) || keyboard_check(ord("A"));
    key_right = keyboard_check(vk_right) || keyboard_check(ord("D"));
	key_jump = keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
	key_jump_hold = keyboard_check(vk_space) || keyboard_check(vk_up) || keyboard_check(ord("W"));
	key_glide_toggle_pressed = keyboard_check_pressed(vk_shift);
}

function reset_input() {
	key_left = false;
    key_right = false;
	key_jump = false;
	key_jump_hold = false;
	key_glide_toggle_pressed = false;
}


// --- Movement Processing ---
function _calculate_target_hsp() {
	// Target Speed
	var target_hsp = (key_right - key_left) * MOVE_SPEED * timescale;
    
	// Touching Wall
	if (place_meeting(x + sign(target_hsp), y, GROUND_OBJECTS)) {
		target_hsp = 0;
	}
	
	return target_hsp;
}


function process_jump() {
	// Buffer Jump
	if (key_jump)
		jump_buffer_timer = JUMP_BUFFER_FRAMES;

	if (jump_buffer_timer <= 0)
		return;

	// Try Jumping
	if (jump_counter < JUMP_MAX)
	{
		// Regular Jump
		jump_counter++;
		jump_timer = JUMP_HOLD_FRAMES / timescale;
		jump_buffer_timer = 0;
		
		// Coyote Time
		grounded_counter = 0;
	}
	
	// Update Jump Buffer Timer
	jump_buffer_timer--;
}


function process_jump_timer() {
	if (jump_timer <= 0)
		return;
		
	if (key_jump_hold)
	{
		// Get Jump Speed
		var jump_speed = GROUNDED_JUMP_SPEED;
		if (jump_counter > 1)
			jump_speed = AIR_JUMP_SPEED;
		
		// Set Jump Speed
        mov_vsp = -jump_speed * timescale;
        jump_timer--;
    }
	else
	{
        jump_timer = 0;
    }
}


function process_glide() {
	if (current_state != PLAYER_STATES.GLIDING)
		return;
	
	mov_vsp = min(GLIDE_SPEED * timescale, mov_vsp);
}


function process_glide_toggle() {
	if (!key_glide_toggle_pressed)
		return;
	
	glide_toggle = !glide_toggle;
}


// --- Movement State ---

function reset_jump_counter() {
	// Regular Jump
	if (is_grounded()) {
		jump_counter = 0;
		grounded_counter = COYOTE_TIME_FRAMES + 1;
	}
	// Coyote Time
	else if (grounded_counter > 0) {
		jump_counter = 0;
	}
	// Double Jump
	else if (jump_counter == 0) {
        jump_counter = 1;
	}
	
	// Update Grounded Counter
	if (grounded_counter > 0)
		grounded_counter--;
}

// --- Evaluate Offscreen


function evaluate_offscreen_death() {
    var outside_room = x < 0 || x > room_width || y < 0 || y > room_height;
    if (outside_room) {
        // Increment Counter
        offscreen_frames_counter++;
        
        // Kill
        if (offscreen_frames_counter >= KILL_OFFSCREEN_FRAMES_THRESH)
			current_health = 0;
    }
	else
        offscreen_frames_counter = 0;
}


// --- Collection Functions ---

function check_collectibles_radius() {
	// Create List
	var collectibles_list = ds_list_create();
	
	// Player Center
	var player_center = get_player_center();
	
	// Check Collectibles Radius
	var num_collectibles = collision_circle_list(player_center[0], player_center[1], COLLECT_RADIUS * image_xscale, o_Entity_Collectible, false, false, collectibles_list, false);
	
	// Collect Collectibles
	for (var i = 0; i < num_collectibles; ++i;) {
	    var collectible = collectibles_list[| i];
		collectible.process_collect();
	}
	
	// Clean Up List
	ds_list_destroy(collectibles_list);
}


// --- Helper Functions ---

function get_player_center() {
    var center_x = (bbox_left + bbox_right) / 2;
    var center_y = (bbox_top + bbox_bottom) / 2;
    
    return [center_x, center_y];
}

function handle_death() {
	current_state = PLAYER_STATES.DEAD;
	APPLY_WORLD_SPEED = true;
	
	o_GameManager.handle_gameover();	
}


// --- Overrides ---

function _set_move_hspeed() {
	// Target HSP
	var target_hsp = _calculate_target_hsp();
	
	// Is Accelerating
	var is_accelerating = target_hsp != 0
	var t = is_accelerating ? ACCELERATION_T : DECELERATION_T;

	// Update Mov HSP
	mov_hsp = lerp(mov_hsp, target_hsp, t);
	if (!is_accelerating && abs(mov_hsp) < 1)
		mov_hsp = 0;
}

function _set_move_vspeed() {
	// Jump
	reset_jump_counter();
	process_jump();
	process_jump_timer();
	
	// Glide
	process_glide();
}


function _set_current_state() {
	// Dead End State
	var is_dead = current_health <= 0;
	if (is_dead) {
		handle_death();
		return;
	}
	
	// Update State
    if (vsp < 0)
        current_state = PLAYER_STATES.JUMPING;
    else if (vsp > 0) {
		if(CAN_GLIDE && (key_jump_hold || glide_toggle))
			current_state = PLAYER_STATES.GLIDING;
		else
			current_state = PLAYER_STATES.FALLING;
	}
    else if (vsp == 0 && is_grounded())
	{
		var is_idle = APPLY_WORLD_SPEED && (hsp == o_GameManager.world_speed);
        current_state = is_idle ? PLAYER_STATES.IDLE : PLAYER_STATES.WALKING;
	}
}
