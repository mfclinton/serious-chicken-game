/// @description Insert description here

// --- Inheritance ---

event_inherited();

// --- Config ---

// Elements Config
ELEMENT_LAYER = "UI";

ELEMENT_ORIGIN_X = room_width / 2;
ELEMENT_ORIGIN_Y = room_height / 2 - 20;

ELEMENT_SPACING_X = 0;
ELEMENT_SPACING_Y = 55;

// Buttons Config
BUTTON_FONT = font_Pause;
BUTTON_TEXT_SCALE = 0.1;
BUTTON_BACKGROUND_VISIBLE = true;

// Logo Config
LOGO = s_Title;
LOGO_ORIGIN_X = room_width / 2;
LOGO_ORIGIN_Y = 50;
LOGO_SCALE = 0.5;

// --- Logo Helpers ---
function draw_logo() {
    draw_sprite_ext(
        LOGO,
        0,
        LOGO_ORIGIN_X,
        LOGO_ORIGIN_Y,
        LOGO_SCALE,
        LOGO_SCALE,
        0,
        c_white,
        1
    );
}

// --- Draw Helper Text ---
function draw_press_space() {
    // Set Properties
    draw_set_color(c_black);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    
    // Draw Text
    var text_y = button_play.y + sprite_get_height(button_play.sprite_index) / 2 + 6;
    var text_scale = 0.04;
    draw_text_transformed(
        button_play.x,
        text_y,
        "(Press Space)",
        text_scale,
        text_scale,
        0
    );
    
    // Reset Properties
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}

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

button_play = create_element(o_UI_Element_Button, ELEMENT_LAYER, configure_button);
button_quit = create_element(o_UI_Element_Button, ELEMENT_LAYER, configure_button);

// --- Configure Elements ---

// Play Button
button_play.TEXT = "Play";
array_push(button_play.on_release_callbacks, load_loadout_menu)

// Quit Button
button_quit.TEXT = "Quit";
array_push(button_quit.on_release_callbacks, game_end);
