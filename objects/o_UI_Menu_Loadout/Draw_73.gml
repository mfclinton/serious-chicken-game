/// @description Draw Preview Stuff

// --- Inherited ---

event_inherited();

// --- Draw Text ---

// Get Current Loadout
var current_loadout = global.loadouts[global.preview_loadout_index];

// Top Center Align
draw_set_halign(fa_center);
draw_set_valign(fa_top);

// Formatting Constants
var center_x = room_width/2;
var start_y = 20;

var spacing = 10;

var title_size = .5;
var desc_size = .2;

// Draw Title
draw_set_font(font_MainMenu);
draw_set_color(c_white);
var title_scale = title_size;
draw_text_transformed(center_x, start_y, current_loadout.name, title_scale, title_scale, 0);

// Get Title Text Metadata
var title_height = string_height(current_loadout.name) * title_scale;

// Draw Description
draw_set_color(c_gray);
var desc_scale = desc_size;
var desc_y = start_y + title_height + spacing;
draw_text_transformed(center_x, desc_y, current_loadout.description, desc_scale, desc_scale, 0);

// Get Description Metadata
var desc_height = string_height(current_loadout.description) * desc_scale;

// Reset Alignment
draw_set_halign(fa_left);
draw_set_valign(fa_top);
