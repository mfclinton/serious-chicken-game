/// @description Collision Resolution

// Resolve Collisions
if (ENABLE_WALL_COLLISIONS)
	collision_resolution();

// Update State
update_state();
process_modifiers();

// Clamp in Bounds
clamp_in_bounds();