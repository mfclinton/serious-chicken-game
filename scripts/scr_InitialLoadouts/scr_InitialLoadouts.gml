global.selected_loadout_index = 0;

global.loadouts = [
	// --- Default ---
	{
		name: "Chicken",
	    description: "The default skin!",
		button_sprite: s_Chicken_Head,
		unlock_condition: function() {
			return true;
		},
		modifier: create_player_modifier_chicken_visual()
	},

	// --- Duck ---
	{
		name: "Duck",
	    description: "The Duck skin!",
		button_sprite: s_Duck_Head,
		unlock_condition: function() {
			return true;
		},
		modifier: create_player_modifier_duck_visual()
	},
]
