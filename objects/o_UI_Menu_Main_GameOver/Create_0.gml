/// @description Insert description here

// --- Inheritance ---

event_inherited();

// --- Config ---

// Elements Config
ELEMENT_LAYER = "UI";

ELEMENT_ORIGIN_X = room_width / 2;
ELEMENT_ORIGIN_Y = room_height / 2 - 20;

ELEMENT_SPACING_X = 0;
ELEMENT_SPACING_Y = 45;

// Buttons Config
BUTTON_FONT = font_Pause;
BUTTON_TEXT_SCALE = 0.08;
BUTTON_BACKGROUND_VISIBLE = true;

// --- Menu Helpers ---
function configure_button(element, element_idx) {
	// Configure Button Visual
	element.sprite_index = s_PlayButton;
	
	// Configure Button Position
	element.x = ELEMENT_ORIGIN_X + element_idx * ELEMENT_SPACING_X;
	element.y = ELEMENT_ORIGIN_Y + element_idx * ELEMENT_SPACING_Y;
	
	// Configure Button Text
	element.FONT = BUTTON_FONT;
	element.TEXT_SCALE = BUTTON_TEXT_SCALE;
	element.BACKGROUND_VISIBLE = BUTTON_BACKGROUND_VISIBLE;
}

function load_loadout_menu() {
	menu_loadout = instance_create_layer(0, 0, "UI", o_UI_Menu_Loadout);
	instance_destroy(o_UI_Menu_Main);
}

// --- Spawn UI Elements ---

button_replay = create_element(o_UI_Element_Button, ELEMENT_LAYER, configure_button);
button_mainmenu = create_element(o_UI_Element_Button, ELEMENT_LAYER, configure_button);

// --- Configure Elements ---

// Replay Button
button_replay.TEXT = "Replay";
array_push(button_replay.on_release_callbacks, o_TransitionManager.transition_to_game);

// Main Menu Button
button_mainmenu.TEXT = "Main Menu";
button_mainmenu.image_xscale = 1.4;
array_push(button_mainmenu.on_release_callbacks, o_TransitionManager.transition_to_main_menu);
