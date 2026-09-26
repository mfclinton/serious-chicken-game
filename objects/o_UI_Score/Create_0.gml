// --- Inherit ---

event_inherited();

// --- Config ---

// State
state = DATABIND_STATES.ENABLED;

// State References
enabled_icon_sprite = s_Egg_Regular;
icon_sprite = enabled_icon_sprite;

// Text
text_font = font_Score;

// --- Override ---

function _get_target_value() {
	return o_GameManager.total_value;
}
