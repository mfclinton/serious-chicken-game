function create_modifier(layer_name, step_func) {
	return {
		// Constants
		seq_layer: layer_name,
		
        // State
        last_state: undefined,
        seq_instance_id: undefined,
		state_changed_trigger: false,
        
        // Step Function
        step: step_func,
		
		// Clean Function
		clean: function () {
			if (seq_instance_id != undefined) {
				layer_sequence_destroy(seq_instance_id);
				seq_instance_id = undefined;
			}
				
			last_state = undefined;
		}
    };
}