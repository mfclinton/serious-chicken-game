// --- Player Modifier Creation ---

function create_player_modifier_chicken_visual() {
    return create_modifier("Player", function(modifier, player) {
		// Visual
		update_player_sequence(modifier, player);
	})
}

function create_player_modifier_duck_visual() {
    return create_modifier("Player", function(modifier, player) {
		// Visual
		update_player_sequence(modifier, player);
		set_duck_visual_outfit(modifier);
		
		state_changed_trigger = false;
	})
}


// --- Player Sequence Updates ---

function update_player_sequence(modifier, player) {
	// Update Seq Instance
    evaluate_new_player_state(modifier, player);
	
	// Update Seq Position
    set_sequence_position(player, modifier.seq_instance_id);
	
	// Update Sequence Playback Speed
	layer_sequence_speedscale(modifier.seq_instance_id, player.timescale);
}


function evaluate_new_player_state(modifier, player) {
	// Check if State Changed
	var current_state = player.current_state;
	if (current_state == modifier.last_state)
		return;
	
	create_player_sequence(modifier, player)

	// Update Last State
	modifier.last_state = current_state;
	state_changed_trigger = true;
}


function create_player_sequence(modifier, player) {
	// Destroy Existing Seq Instance
	if (modifier.seq_instance_id != undefined)
		layer_sequence_destroy(modifier.seq_instance_id);
	
	// Create Seq Instance
    var new_seq = get_chicken_visual_sequence(player.current_state);
    modifier.seq_instance_id = create_sequence_instance(player, new_seq, modifier.seq_layer);
}


// --- Sequence Retrieval ---

// Chicken
function get_chicken_visual_sequence(player_state) {
    switch (player_state) {
        case PLAYER_STATES.IDLE:
            return seq_Chicken_Idle;
        case PLAYER_STATES.JUMPING:
            return seq_Chicken_AirUp;
        case PLAYER_STATES.FALLING:
            return seq_Chicken_AirDown;
        case PLAYER_STATES.WALKING:
            return seq_Chicken_Run;
        case PLAYER_STATES.GLIDING:
            return seq_Chicken_Glide;
		case PLAYER_STATES.DEAD:
			return seq_Chicken_Die;
        default:
            return undefined;
    }
}


function set_duck_visual_outfit(modifier) {
	if (!state_changed_trigger)
		return;

	// Get Seq Instance
	var seq_instance = get_seq_instance(modifier.seq_instance_id);
	
	// Set Outfit
	sequence_replace_obj(seq_instance, o_Chicken_Body, o_Duck_Body);
	sequence_replace_obj(seq_instance, o_Chicken_Head, o_Duck_Head);
	sequence_replace_obj(seq_instance, o_Chicken_LegL, o_Duck_LegL);
	sequence_replace_obj(seq_instance, o_Chicken_LegR, o_Duck_LegR);
	sequence_replace_obj(seq_instance, o_Chicken_Wing, o_Duck_Wing);
}


// Rabbit
function get_rabbit_visual_sequence(player_state) {
    switch (player_state) {
        case PLAYER_STATES.IDLE:
            return seq_Rabbit_Idle;
        case PLAYER_STATES.JUMPING:
            return seq_Rabbit_Idle;
        case PLAYER_STATES.FALLING:
            return seq_Rabbit_Idle;
        case PLAYER_STATES.WALKING:
            return seq_Rabbit_Run;
        case PLAYER_STATES.GLIDING:
            return seq_Rabbit_Run;
		case PLAYER_STATES.DEAD:
			return seq_Rabbit_Run;
        default:
            return undefined;
    }
}
