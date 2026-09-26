/// @description Setup Level Controller

// --- Constants ---

// Layers
LAYER_COLLECTIBLES = "Collectibles";
LAYER_OBSTACLES = "Obstacles";

// Levels
LEVEL_JSON_NAME = "levels.json";

// Initial Delay
INITIAL_LEVEL_DELAY = 1;

// --- State ---

// Levels
levels_data_list = import_json(LEVEL_JSON_NAME)[? "default"];

// Zones
cur_zone_index = 0;
zone_level_indexes = ds_list_create();
transition_probability = 0.25;

// Time Scale
original_time_remaining_unscaled = 0;
timescale = 1;

// World Scale
worldscale = .75;

// --- Level Generation Helpers

function sample_level_index() {
	// Sample Level
	var cur_zone_level_indexes = zone_level_indexes[|cur_zone_index];
	var num_zone_levels = ds_list_size(cur_zone_level_indexes);

	var idx = irandom(num_zone_levels - 1);
	var level_idx = cur_zone_level_indexes[|idx];
	
	return level_idx;
}

function sample_random_level()
{
    // Random Level Key
    var num_levels = ds_list_size(levels_data_list);
    var level_idx = sample_level_index()
    
    // Get Level Data
    var level_data = levels_data_list[| level_idx];
    
    // Load Level
    var spawned_instances = load_level_entities(level_data);
	
	// Update Background
	update_background(level_data);
	
    return spawned_instances;
}

function load_level_entities(level_data)
{
    // Gets Layers Data
    var layers_data = level_data[? "layers"];

	// Calculate Adjusted World Offset
	var world_x_offset = (1 - worldscale) * room_width;
	var world_y_offset = (1 - worldscale) * room_height;
    
    // Iterate Over Layers
    var spawned_instances = ds_list_create();
    for (var i = 0; i < ds_list_size(layers_data); i++) {
        var layer_data = layers_data[| i];
        
        // Iterate Over Instances
        var instances_data = layer_data[? "instances"];
        for (var j = 0; j < ds_list_size(instances_data); ++j) {
            var instance_data = instances_data[| j];
			
            // Calculate Adjusted Position
            var scale_x = instance_data[? "scale_x"] * worldscale;
            var scale_y = instance_data[? "scale_y"] * worldscale;
            var adjusted_x = instance_data[? "x"] * scale_x + world_x_offset;
            var adjusted_y = instance_data[? "y"] * scale_y + world_y_offset;
            
            // Spawn Instance
            var instance = instance_create_layer(
                adjusted_x,
                adjusted_y,
                layer_data[? "layer"],
                asset_get_index(instance_data[? "obj_name"])
            );
            
            // Configure Instance
            instance.image_xscale = scale_x;
            instance.image_yscale = scale_y;
            
            // Add Result
            ds_list_add(spawned_instances, instance);
        }
    }
    
    return spawned_instances;
}


// --- Level Generation Timer Helpers

function evaluate_wait_time(spawned_instances) {
    var wait_time = 0;
    for (var i = 0; i < ds_list_size(spawned_instances); ++i) {
        var instance = spawned_instances[| i];
        
        // Instance Wait Time
        var instance_wait_time = evaluate_instance_wait_time(instance);
        wait_time = max(wait_time, abs(instance_wait_time));
    }
    
    return wait_time;
}

function evaluate_instance_wait_time(instance) {
    // Get Speeds
    var hsp = variable_instance_exists(instance, "hsp") ? instance.hsp : 0;
    
    // Get New Speed
    var instance_speed = (o_GameManager.world_speed + hsp);

    // Time to Enter Room
    var instance_wait_time = (instance.x - room_width) / instance_speed;
    return instance_wait_time;
}

function set_timer(wait_time_raw) {
	// Set Original Time
	original_time_remaining_unscaled = wait_time_raw;
	
	// Set Timer
	var wait_timescaled = wait_time_raw / timescale;
	alarm[0] = wait_timescaled;
}

// --- Time Scale Helpers ---

function set_timescale(new_timescale) {
	// Already Set
	if (new_timescale == timescale)
		return
	
	// Update Timescale
	var old_timescale = timescale;
	timescale = new_timescale;
	
	// Time Remaining
	var time_remaining_unscaled = (old_timescale == 0) ? original_time_remaining_unscaled : alarm[0] * old_timescale;
	
	// Pause & Unpause
	if (timescale == 0) {
		alarm[0] = -1;
		original_time_remaining_unscaled = time_remaining_unscaled;
		return;
	}
	
	// Set Timer
	set_timer(time_remaining_unscaled);
}

// --- Zone Logic ---

function attempt_zone_transition() {
	// Transition Zones
	var transition_zones = random(1) <= transition_probability;
	if (transition_zones) {
		var prev_zone_index = cur_zone_index;
		
		var num_zones = ds_list_size(zone_level_indexes);
		while (num_zones > 1 && prev_zone_index == cur_zone_index)
			cur_zone_index = irandom(num_zones - 1);
	}
}

function is_default_zone(room_name) {
	return !is_space_zone(room_name);
}

function is_space_zone(room_name) {
	return string_pos("space", string_lower(room_name)) > 0;
}

function filter_level_indexes(levels_data_list, filter_func) {
	var level_indexes = ds_list_create();
	for (var i = 0; i < ds_list_size(levels_data_list); ++i) {
	    var level_data = levels_data_list[|i];
		var room_name = level_data[? "room"];
		if (filter_func(room_name))
			ds_list_add(level_indexes, i);
	}
	
	return level_indexes;
}

function update_background(level_data) {
	var room_name = level_data[? "room"];
	
	// Check Zone
	var new_background_sprite = noone;
	if (is_space_zone(room_name)) {
		new_background_sprite = s_Space_Background_Light;
	}
	else {
		new_background_sprite = s_Clouds_Background_Light;
	}
	
	o_BackgroundManager.next_sprite = new_background_sprite;
}

// --- Initialize ---

// Zone Levels Indexes
var default_levels = filter_level_indexes(levels_data_list, is_default_zone);
var space_levels = filter_level_indexes(levels_data_list, is_space_zone);

ds_list_add(zone_level_indexes, default_levels);
ds_list_add(zone_level_indexes, space_levels);

// Timer
alarm[0] = INITIAL_LEVEL_DELAY;
