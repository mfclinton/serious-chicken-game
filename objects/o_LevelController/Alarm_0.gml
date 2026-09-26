/// @description Generates Level

// Don't Spawn Levels
if (!SPAWN_LEVELS)
	return;

// Zone Transition
attempt_zone_transition();

// Spawn Level
var spawned_instances = sample_random_level();

// Set New Wait Time
var wait_time = evaluate_wait_time(spawned_instances);
set_timer(wait_time);

// Cleanup
ds_list_destroy(spawned_instances);
