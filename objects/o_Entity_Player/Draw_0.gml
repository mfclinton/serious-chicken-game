if (SHOW_COLLECT_RADIUS) {
	var player_center = get_player_center();
	draw_circle(player_center[0], player_center[1], COLLECT_RADIUS * image_xscale, true);	
}
