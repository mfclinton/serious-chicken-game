/// @description Initialize Game

// --- World State Enum ---

enum GameState {
    GAMEPLAY,
    PAUSED,
    GAME_OVER
}


// --- Constants ---

// Layers
LAYER_BACKGROUND = "Background";
LAYER_RAINBOW = "RainbowBridge";
LAYER_CLOUDS = "Background_Clouds";

LAYER_UI = "UI";

// Objects
OBJECT_PAUSE_MENU = o_UI_Menu_Pause;
OBJECT_GAMEOVER_MENU = o_UI_Menu_Main_GameOver;

// --- State ---

// Input
key_pause = false;

// Game
game_state = GameState.GAMEPLAY;
total_value = 0;
world_speed = 0;


// -- Pause Game Functions ---

function check_input() {
    key_pause = keyboard_check_pressed(vk_escape) || keyboard_check_pressed(ord("P"));
}

function process_pause_input() {
	if(!key_pause)
		return;
		
	toggle_pause();
}

function toggle_pause() {
	if (game_state == GameState.GAME_OVER)
		return;
	
	// Update Game State
	game_state = game_state == GameState.PAUSED ? GameState.GAMEPLAY : GameState.PAUSED;
	var is_paused = game_state == GameState.PAUSED;
	
	// Pause World
	var new_world_speed = is_paused ? 0 : world_speed;
	set_world_speed_visual(new_world_speed);
	
	// Pause Entities
	var new_timescale = is_paused ? 0 : 1;
	with (o_Entity)
		set_timescale(new_timescale);
		
	// Pause Level Controller
	o_LevelController.set_timescale(new_timescale);

	// Pause Menu
	if (is_paused)
		// Show
		instance_create_layer(0, 0, LAYER_UI, OBJECT_PAUSE_MENU);
	else
		// Hide
		instance_destroy(OBJECT_PAUSE_MENU);
}

// --- Game Over Functions ---

function handle_gameover() {
	if (game_state == GameState.GAME_OVER)
		return;
	
	// Pause World
	set_world_speed(0);

	// Update Game State
	game_state = GameState.GAME_OVER;
	
	// Spawn UI
	instance_create_layer(0, 0, LAYER_UI, OBJECT_GAMEOVER_MENU);
}

// --- World Speed Functions ---

function set_world_speed(new_world_speed) {
	// Update World Speed
	world_speed = new_world_speed;
	
	// Update Visuals
	set_world_speed_visual(world_speed);
}

function set_world_speed_visual(visual_world_speed) {
	// Update Background
	o_BackgroundManager.scroll_speed_x = -visual_world_speed * BACKGROUND_SPEED_SCALAR;
	layer_set_hspeed(LAYER_CLOUDS, visual_world_speed * CLOUDS_SPEED_SCALAR);
	
	// Update Rainbow Bridge
	layer_set_ripple_speed(LAYER_RAINBOW, visual_world_speed * RAINBOW_SPEED_SCALAR);
}

// --- Initialize ---

set_world_speed(INITIAL_WORLD_SPEED);
