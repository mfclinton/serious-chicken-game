/// @description Insert description here

// --- Inheritance ---

event_inherited();

// --- Config ---

// Elements Config
ELEMENT_LAYER = "UI";

ELEMENT_ORIGIN_X = room_width / 2;
ELEMENT_ORIGIN_Y = room_height / 2 - 50;

ELEMENT_SPACING_X = 0;
ELEMENT_SPACING_Y = 30;

// Buttons Config
BUTTON_FONT = font_Pause;
BUTTON_TEXT_SCALE = 0.1;
BUTTON_BACKGROUND_VISIBLE = false;

// Slider Config
SLIDER_SELECTED_ALPHA = 1;
SLIDER_UNSELECTED_ALPHA = 0.5;

// --- Helpers ---
function configure_button(element, element_idx) {
	// Configure Button Visual
	element.sprite_index = s_MenuButton;
	
	// Configure Button Position
	element.x = ELEMENT_ORIGIN_X + element_idx * ELEMENT_SPACING_X;
	element.y = ELEMENT_ORIGIN_Y + element_idx * ELEMENT_SPACING_Y;
	
	// Configure Button Text
	element.FONT = BUTTON_FONT;
	element.TEXT_SCALE = BUTTON_TEXT_SCALE;
	element.BACKGROUND_VISIBLE = BUTTON_BACKGROUND_VISIBLE;
}

function configure_slider(element, element_idx) {
	// Configure Slider Visual
	element.sprite_index = s_AudioSlider;
	
	// Configure Slider Position
	element.x = ELEMENT_ORIGIN_X + element_idx * ELEMENT_SPACING_X;
	element.y = ELEMENT_ORIGIN_Y + element_idx * ELEMENT_SPACING_Y;
}


// --- Spawn UI Elements ---

button_continue = create_element(o_UI_Element_Button, ELEMENT_LAYER, configure_button);
button_restart = create_element(o_UI_Element_Button, ELEMENT_LAYER, configure_button);
button_mainmenu = create_element(o_UI_Element_Button, ELEMENT_LAYER, configure_button);

slider_volume = create_element(o_UI_Element_Slider, ELEMENT_LAYER, configure_slider);

// --- Configure Elements ---

// Continue Button
button_continue.TEXT = "Continue";
array_push(button_continue.on_release_callbacks, o_GameManager.toggle_pause)

// Restart Button
button_restart.TEXT = "Restart";
array_push(button_restart.on_release_callbacks, o_TransitionManager.transition_to_game);

// Main Menu Button
button_mainmenu.TEXT = "Main Menu";
array_push(button_mainmenu.on_release_callbacks, o_TransitionManager.transition_to_main_menu);

// Volume Slider
slider_volume.current_p = get_master_volume();
slider_volume.alpha = SLIDER_UNSELECTED_ALPHA;
array_push(slider_volume.on_p_modified_callbacks, set_master_volume);
array_push(slider_volume.on_selected_callbacks, function () { slider_volume.alpha = SLIDER_SELECTED_ALPHA; });
array_push(slider_volume.on_unselected_callbacks, function () { slider_volume.alpha = SLIDER_UNSELECTED_ALPHA; });
