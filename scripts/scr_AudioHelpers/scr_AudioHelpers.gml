// --- Master Audio Helpers ---

function set_master_volume(vol) {
	audio_master_gain(vol);
}

function get_master_volume() {
	return audio_get_master_gain(0);
}
