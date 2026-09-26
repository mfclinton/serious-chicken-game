/// @struct AudioManager
function AudioManager(_clips, _min_interval) constructor {
    clips = array_filter(_clips, function(clip) {
        return clip != noone;
    });
    min_interval = _min_interval;
    last_play_time = -infinity;

    // Plays Random Clip with Pitch Variance
    play_random = function(_pitch_variance = 0) {
		if (!_can_play())
			return;

		// Random Clip
        var clip = clips[irandom(array_length(clips) - 1)];
		
		// Random Pitch
        var pitch = 1 + random_range(-_pitch_variance, _pitch_variance);

        // Play Audio
		var sound = audio_play_sound(clip, pitch, false);
        audio_sound_pitch(sound, pitch);

        // Update Last Played Time
        last_play_time = current_time;
    };
	
	// Can Play
	_can_play = function() {
		var has_clips = array_length(clips) > 0;
		
		var has_been_long_enough = current_time - last_play_time >= min_interval;
		
		return has_clips && has_been_long_enough;
	};
}
