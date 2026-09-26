function AudioGroup(audio_group) constructor {
    // --- Attributes ---
    group = audio_group;
    target_volume = 1.0;

	// --- Loading ---
    load = function() {
        if (audio_group_is_loaded(group))
            return false;

		audio_group_load(group);
        return true;
    }

    // --- Core Volume Controls ---
    set_target_volume = function(new_target_volume, time_ms = 0) {
		// Update Target Volume
        volume = clamp(new_target_volume, 0, 1);
        target_volume = volume;
		
		// Update Gain
		set_gain(target_volume);
    }

	set_gain = function(new_gain, time_ms = 0) {
		audio_group_set_gain(group, new_gain, time_ms);
	}
	
	reset_gain = function(time_ms = 0) {
		audio_group_set_gain(group, target_volume, time_ms);
	}

    // --- Sound Control ---
    stop_all = function() {
        audio_group_stop_all(group);
    }
	
	// --- Initialization ---
    load();
}