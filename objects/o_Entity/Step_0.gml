/// @description Update Entity

// On Ledge
if (ENABLE_EVALUATE_LEDGE)
	evaluate_ledge();

// Movement (Non-Collisions)
if (!ENABLE_WALL_COLLISIONS)
	move_entity();
