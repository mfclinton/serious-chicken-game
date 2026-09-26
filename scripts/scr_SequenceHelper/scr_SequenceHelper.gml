// --- Entity Sequence Helpers ---

function create_sequence_instance(parent, seq, seq_layer) {
    // Create Sequence
    var seq_instance_id = layer_sequence_create(seq_layer, parent.x, parent.y, seq);

	// Scale Sequence
	layer_sequence_xscale(seq_instance_id, parent.image_xscale);
    layer_sequence_yscale (seq_instance_id, parent.image_yscale);
	
	// Return Instance
	return seq_instance_id;
}


function set_sequence_position(parent, seq_instance_id) {
    layer_sequence_x(seq_instance_id, parent.x);
	layer_sequence_y(seq_instance_id, parent.y);
}


function sequence_replace_obj(seq_instance, from_obj, to_obj) {
	sequence_instance_override_object(seq_instance, from_obj, to_obj);
}


// --- Sequence Helpers

function get_seq_instance(seq_instance_id) {
	return layer_sequence_get_instance(seq_instance_id);
}
