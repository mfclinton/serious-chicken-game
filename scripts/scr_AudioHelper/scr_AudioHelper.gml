// --- Audio Group Functions ---

function set_group_volume(group_name, volume, duration_ms = 0) {
    var vol = clamp(volume, 0, 1);
    audio_group_set_gain(group_name, vol, duration_ms);
}

function get_group_volume(group_name) {
    return audio_group_get_gain(group_name);
}
