// --- Set Layer Speeds ---

function layer_set_hspeed(layer_name, spd) {
	var layer_id = layer_get_id(layer_name);
	layer_hspeed(layer_id, spd);
}


function layer_set_ripple_speed(layer_name, spd){
	var layer_id = layer_get_id(layer_name);
	var fx = layer_get_fx(layer_id);
	fx_set_parameter(fx, "g_RipplesSpeed", spd);
}
