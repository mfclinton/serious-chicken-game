import glob
import json
import os
import re
from collections import defaultdict

# Extracting data from the JSON file
files = glob.glob("../rooms/**/*.yy")
files.remove("../rooms\\rm_Game\\rm_Game.yy")
files.remove("../rooms\\rm_MainMenu\\rm_MainMenu.yy")
print(f"Found {len(files)} files to extract data from.")
print(f"Files: {files}")

# Config
valid_layer_names = ['Collectibles', 'Enemies', 'Blocks']

# Extract data
room_data = []
for file in files:
    with open(file) as f:
        fixed_data = re.sub(r',(\s*[}\]])', r'\1', f.read())
        data = json.loads(fixed_data)

        layers = data["layers"]

        layers_data = []
        for layer in layers:
            layer_name = layer["%Name"]
            if layer_name not in valid_layer_names:
                continue

            instances_data = []
            for instance in layer["instances"]:
                instances_data.append({
                    "x": instance["x"],
                    "y": instance["y"],
                    "scale_x": instance["scaleX"],
                    "scale_y": instance["scaleY"],
                    "obj_name":  instance["objectId"]["name"],
                    "instance_id": instance["name"],
                })
            
            if len(instances_data) > 0:
                layer_data_dict = {
                    "layer": layer_name,
                    "instances": instances_data,
                }
                layers_data.append(layer_data_dict)
        
        if len(layers_data) > 0:
            room_name = data["%Name"]
            room_data_dict = {
                "room": room_name,
                "layers": layers_data,
            }
            room_data.append(room_data_dict)


# Write Data
output_file = "../datafiles/levels.json"

with open(output_file, "w") as f:
    json.dump(room_data, f, indent=4)