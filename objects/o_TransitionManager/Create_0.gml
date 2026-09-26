// --- State ---

// Visual State
current_alpha = 0;
target_alpha = 1;

is_transitioning = false;

// Room State
next_room = noone;

// --- Visual Functions

function update_alpha() {
    if (current_alpha < target_alpha) {
        current_alpha = min(current_alpha + TRANSITION_SPEED, target_alpha);
    } else if (current_alpha > target_alpha) {
        current_alpha = max(current_alpha - TRANSITION_SPEED, target_alpha);
    }
}

function draw_fade_effect() {
	// Configure
    draw_set_color(TRANSITION_COLOR);
    draw_set_alpha(current_alpha);
	
	// Draw
    draw_rectangle(0, 0, display_get_width(), display_get_height(), false);
	
	// Reset
    draw_set_alpha(1);
}

// --- Transition Functions ----

function handle_transition() {
	if (!is_transitioning || current_alpha != target_alpha)
		return;

	// Go To Room
	if (next_room != noone)
		room_goto(next_room);
		
	// Reset State
    next_room = noone;
    target_alpha = 0;
	is_transitioning = false;
}

// --- Trigger Functions ---

function trigger_fade_in() {
	if (is_transitioning)
		return;

	current_alpha = 1;
	target_alpha = 0;
	next_room = noone;
	is_transitioning = true;
}

function trigger_room_transition(target_room) {
	if (is_transitioning)
		return;

	// Set State
    target_alpha = 1;
    next_room = target_room;
	is_transitioning = true;
}

// --- Specific Room Transitions ---

function transition_to_game() {
	o_TransitionManager.trigger_room_transition(rm_Game);
}

function transition_to_main_menu() {
	o_TransitionManager.trigger_room_transition(rm_MainMenu);
}

// --- Step Functions ---

function process_transition() {
	if (!is_transitioning)
		return;

	// Visual
	update_alpha();
	draw_fade_effect();

	// Process Transition
	handle_transition();
}
