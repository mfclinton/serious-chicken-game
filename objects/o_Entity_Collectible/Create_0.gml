/// @description Configure Collectible

// --- Inheritance ---

event_inherited();


// --- Constants ---

// States
enum COLLECTIBLE_STATES {
	IDLE,
	COLLECTING,
}

// Animation Config
ANIMATION_MOVE_SPEED = 5;
ANIMATION_DIE_SPEED = 0.01;

ANIMATION_TARGET_X = o_UI_Score.x;
ANIMATION_TARGET_Y = o_UI_Score.y;

// --- State ---

collected = false;


// --- Score Helpers ---

function process_collect() {
	if (collected)
		return;
	
	o_GameManager.total_value += VALUE;
	collected = true;
}


// --- Animation Helpers ---

function collecting_animation_set_speed() {
    // Scale Down
    image_xscale -= ANIMATION_DIE_SPEED;
    image_yscale -= ANIMATION_DIE_SPEED;

    // Fade Out
    image_alpha -= ANIMATION_DIE_SPEED;

	// Move Towards Score
    var mov = point_direction(x, y, ANIMATION_TARGET_X, ANIMATION_TARGET_Y);
    hsp = lengthdir_x(ANIMATION_MOVE_SPEED, mov);
    vsp = lengthdir_y(ANIMATION_MOVE_SPEED, mov);
}


function evaluate_destroy() {
	// Destroy
    if (image_alpha <= 0 || image_xscale <= 0) {
        instance_destroy();
    }
}


// --- Overrides ---

function _set_speed() {
	if (current_state == COLLECTIBLE_STATES.IDLE)
		hsp = 0;
	else if (current_state = COLLECTIBLE_STATES.COLLECTING)
		collecting_animation_set_speed();
}

function _set_current_state() {
	if (collected)
		current_state = COLLECTIBLE_STATES.COLLECTING;
	else
		current_state = COLLECTIBLE_STATES.IDLE;
}
