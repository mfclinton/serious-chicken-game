// --- Inheritance ---
event_inherited();

//  --- Config ---

// State Sprites
inactive_icon_sprite = noone;
disabled_icon_sprite = s_AutoGlideButtonInactive;
enabled_icon_sprite = s_AutoGlideButtonActive;

// Scale
icon_scale = 0.75;

// --- Overrides ---

function _get_target_state() {
	if (!o_Entity_Player.CAN_GLIDE)
		return DATABIND_STATES.INACTIVE;
	else if (!o_Entity_Player.glide_toggle)
		return DATABIND_STATES.DISABLED;
	else
		return DATABIND_STATES.ENABLED;
}
