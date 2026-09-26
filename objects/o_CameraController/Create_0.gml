// --- State ---
active_camera = view_camera[0];

// Initial Width + Height
initial_width = camera_get_view_width(active_camera);
initial_height = camera_get_view_height(active_camera);

// Camera Scale
camera_scale = 1

// --- Helpers ---

function set_camera_size(scalar)
{
	var new_width = initial_width * scalar;
	var new_height = initial_height * scalar;
	
    camera_set_view_size(active_camera, new_width, new_height);
}

// --- Initialization ---

set_camera_size(camera_scale);
