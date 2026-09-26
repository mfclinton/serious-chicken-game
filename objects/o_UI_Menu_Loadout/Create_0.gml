// --- Inheritance ---

event_inherited();

// --- Config ---

// Elements Config
ELEMENT_LAYER = "UI";

ELEMENT_SPACING_X = 110;
ELEMENT_SPACING_Y = 110;

ELEMENT_ORIGIN_X = room_width / 2 - ELEMENT_SPACING_X / 2;
ELEMENT_ORIGIN_Y = 3 * room_height / 4;

// Grid
NAVIGATION_TYPE = NavigationType.GRID;
grid_shape = [2, 2];

// Buttons Config
BUTTON_FONT = font_MainMenu;
BUTTON_TEXT_SCALE = 0.1;
BUTTON_BACKGROUND_VISIBLE = true;

// --- State ---

global.preview_loadout_index = global.selected_loadout_index;

// --- Button Helpers ---
function configure_button(element, element_idx) {
	// Configure Button Visual
	element.sprite_index = s_MenuButton;
	
	// Configure Button Position
	var grid_pos = _calculate_row_col_grid_index(element_idx);
	element.x = ELEMENT_ORIGIN_X + grid_pos[1] * ELEMENT_SPACING_X;
	element.y = ELEMENT_ORIGIN_Y + grid_pos[0] * ELEMENT_SPACING_Y;
	
	// Configure Button Text
	element.FONT = BUTTON_FONT;
	element.TEXT_SCALE = BUTTON_TEXT_SCALE;
	element.BACKGROUND_VISIBLE = BUTTON_BACKGROUND_VISIBLE;
}

function create_loadout_select_callback(index) {
    var data = {
        idx: index
    };
    return method(data, function() {
        var loadout = global.loadouts[idx];
        if (!loadout.unlock_condition())
            return;
        
        global.selected_loadout_index = idx;
    });
}

function create_loadout_preview_callback(index, preview_player_instance) {
	var data = {
        idx: index,
		preview_player_instance: preview_player_instance
    };
    return method(data, function() {
        
		var prev_loadout = global.loadouts[global.preview_loadout_index];
		var loadout = global.loadouts[idx];

		global.preview_loadout_index = idx;
		
		// Clean
		ds_list_clear(preview_player_instance.modifiers);
		prev_loadout.modifier.clean();
		
		// Add Modifier
		ds_list_add(preview_player_instance.modifiers, loadout.modifier);
		
    });
}

function create_loadout_pressed_callback(index) {
	var data = {
        idx: index
    };
	return method(data, function() {
		global.selected_loadout_index = idx;
		o_TransitionManager.transition_to_game();	
	});
}

// --- Setup UI Elements ---

for (var i = 0; i < array_length(global.loadouts); ++i) {
	
	// Spawn Button
    var button = create_element(o_UI_Element_Button, ELEMENT_LAYER, configure_button);
	
	// Configure Button
	button.sprite_index = global.loadouts[i].button_sprite;
	
	array_push(button.on_selected_callbacks, create_loadout_preview_callback(i, o_Entity_Player));
	array_push(button.on_press_callbacks, create_loadout_pressed_callback(i));
}
