
function import_json(file_name) {
	var json_string = read_file_to_string(file_name);
	
	// Parse
	var json = json_decode(json_string);
	return json;
}


function read_file_to_string(file_name) {
    // Validate
	if (!file_exists(file_name))
		return undefined;
    
    // Open File
	var file = file_text_open_read(file_name);
    
	// Read All Lines
	var content = "";
    while (!file_text_eof(file)) {
        content += file_text_read_string(file);
        file_text_readln(file);
    }
    
	// Close File
    file_text_close(file);
	
	// Result
    return content;
}
