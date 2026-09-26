import json

from zmq import has

# Define helper functions
def is_adjacent(block1, block2, direction, block_spacing):
    """Check if block2 is adjacent to block1 in the specified direction."""
    if direction == "left":
        return block1["x"] - block2["x"] == block_spacing and block1["y"] == block2["y"]
    if direction == "right":
        return block2["x"] - block1["x"] == block_spacing and block1["y"] == block2["y"]
    if direction == "above":
        return block1["y"] - block2["y"] == block_spacing and block1["x"] == block2["x"]
    if direction == "below":
        return block2["y"] - block1["y"] == block_spacing and block1["x"] == block2["x"]
    if direction == "diagonal_tl":
        return block1["x"] - block2["x"] == block_spacing and block1["y"] - block2["y"] == block_spacing
    return False

def update_cloud(block, adjacent_blocks):
    """Update cloud block based on adjacent blocks."""
    block_spacing = 16

    has_left = any(is_adjacent(block, b, "left", block_spacing) and "Cloud" in b["obj_name"] for b in adjacent_blocks)
    has_right = any(is_adjacent(block, b, "right", block_spacing) and "Cloud" in b["obj_name"] for b in adjacent_blocks)

    if has_left and has_right:
        block["obj_name"] = "o_Cloud_Mid"
    elif has_left:
        block["obj_name"] = "o_Cloud_Right"
    elif has_right:
        block["obj_name"] = "o_Cloud_Left"

def update_logs(block, adjacent_blocks):
    """Update log block based on adjacent blocks."""
    if "Moss" in block["obj_name"] or "Beaver" in block["obj_name"] or "Split" in block["obj_name"]:
        return

    block_spacing = 32

    has_left = any(is_adjacent(block, b, "left", block_spacing) and "Logs" in b["obj_name"] for b in adjacent_blocks)
    has_right = any(is_adjacent(block, b, "right", block_spacing) and "Logs" in b["obj_name"] for b in adjacent_blocks)
    has_above = any(is_adjacent(block, b, "above", block_spacing) and "Logs" in b["obj_name"] for b in adjacent_blocks)
    has_diagonal_tl = any(is_adjacent(block, b, "diagonal_tl", block_spacing) and "Logs" in b["obj_name"] for b in adjacent_blocks)

    if has_above and has_left and not has_diagonal_tl:
        block["obj_name"] = "o_Logs_Base_Corner"
    elif has_above and has_left and has_diagonal_tl:
        block["obj_name"] = "o_Logs_BC"
    elif has_above and has_left and not has_right:
        block["obj_name"] = "o_Logs_Base_BR"
    elif not has_above and has_left and has_right:
        block["obj_name"] = "o_Logs_TC"
    elif has_above and not has_left:
        block["obj_name"] = "o_Logs_Base_BL"
    elif has_above and has_left and not has_right:
        block["obj_name"] = "o_Logs_Base_BR"
    elif not has_above and has_left and not has_right:
        block["obj_name"] = "o_Logs_Base_TR"
    elif not has_above and not has_left:
        block["obj_name"] = "o_Logs_Base_TL"
    else:
        print("No match found for block", block["obj_name"])

# Process the JSON file
def process_blocks(json_data):
    for room in json_data:
        for layer in room.get("layers", []):
            if layer["layer"] == "Blocks":
                instances = layer["instances"]
                for block in instances:
                    
                    # Update Block
                    if "Cloud" in block["obj_name"]:
                        update_cloud(block, instances)
                    elif "Logs" in block["obj_name"]:
                        update_logs(block, instances)
    return json_data

# Main logic
def main():
    # Files
    input_file = "..\datafiles\levels.json"
    output_file = "..\datafiles\levels.json"

    # Load Data
    with open(input_file, "r") as f:
        data = json.load(f)

    # Process Data
    updated_data = process_blocks(data)

    # Write Data
    with open(output_file, "w") as f:
        json.dump(updated_data, f, indent=4)

if __name__ == "__main__":
    main()
