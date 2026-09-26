
// --- Inherit ---

event_inherited();

// --- State ---

cur_dir = sign(DEFAULT_MOV_HSP);

// Stored State
stored_gravity = GRAVITY;
stored_default_mov_hsp = DEFAULT_MOV_HSP;
stored_enable_wall_collisions = ENABLE_WALL_COLLISIONS;
stored_enable_evaluate_ledge = ENABLE_EVALUATE_LEDGE;

// --- Helpers ---

function _set_direction(dir) {
	cur_dir = sign(dir);
	image_xscale = abs(image_xscale) * -cur_dir;
}

// --- Override ---

function _set_move_hspeed() {
	mov_hsp = abs(DEFAULT_MOV_HSP) * sign(cur_dir);
}

function _on_horizontal_collision() {
	_set_direction(cur_dir * -1);
}

function _on_ledge_event() {
	_set_direction(cur_dir * -1);
}

function _on_entity_room_state_changed() {
	if (entity_room_state == EntityRoomState.NEW || entity_room_state == EntityRoomState.OUTSIDE_ROOM) {
		GRAVITY = 0;
		DEFAULT_MOV_HSP = 0;
		ENABLE_WALL_COLLISIONS = false;
		ENABLE_EVALUATE_LEDGE = false;
	}
	else if (entity_room_state == EntityRoomState.INSIDE_ROOM) {
		GRAVITY = stored_gravity;
		DEFAULT_MOV_HSP = stored_default_mov_hsp;
		ENABLE_WALL_COLLISIONS = stored_enable_wall_collisions;
		ENABLE_EVALUATE_LEDGE = stored_enable_evaluate_ledge;
	}
}

// --- Initialize ---

_on_entity_room_state_changed();
_set_direction(cur_dir);
