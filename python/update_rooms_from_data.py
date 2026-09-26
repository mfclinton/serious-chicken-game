import glob
import json
import os
import re

# Level Json
input_file = "..\datafiles\levels.json"
with open(input_file, "r") as f:
    data = json.load(f)

# Rooms
files = glob.glob("../rooms/**/*.yy")
files.remove("../rooms\\rm_MainMenu\\rm_MainMenu.yy")
files.remove("../rooms\\rm_Game\\rm_Game.yy")

# Code
for room_file in files:
    
    # Extract data
    level_name = os.path.basename(room_file).replace(".yy", "")

    # Find level data
    level_data = None
    for level in data:
        if level["room"] == level_name:
            level_data = level
            break

    if level_data is None:
        print(f"Level {level_name} not found in data file.")
        continue

    # Load Room
    with open(room_file, "r") as f:
        fixed_room_data = re.sub(r',(\s*[}\]])', r'\1', f.read())
        room_data = json.loads(fixed_room_data)

        # Get Layer
        layers = room_data["layers"]
        for layer in layers:

            # Find Level Layer Data
            level_data_layer = None
            for level_layer in level_data["layers"]:
                if level_layer["layer"] == layer["%Name"]:
                    level_data_layer = level_layer
                    break

            if level_data_layer is None:
                continue

            # Update Instances
            level_data_layer_instances = level_data_layer["instances"]
            for level_instance in level_data_layer_instances:
                for instance in layer["instances"]:
                    if level_instance["instance_id"] == instance["name"]:
                        instance["x"] = level_instance["x"]
                        instance["y"] = level_instance["y"]
                        instance["scaleX"] = level_instance["scale_x"]
                        instance["scaleY"] = level_instance["scale_y"]
                        instance["objectId"]["name"] = level_instance["obj_name"]
                        instance["objectId"]["path"] = f"objects/{level_instance['obj_name']}/{level_instance['obj_name']}.yy"
                        break

    # Write Room
    with open(room_file, "w") as f:
        json.dump(room_data, f, indent=4)
