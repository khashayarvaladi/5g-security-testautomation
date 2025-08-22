import json
import os

# Path to the JSON file
json_file_path = "/home/exceeding/PCAP/nr_rrc.json"

# Check if the file exists
if not os.path.exists(json_file_path):
    print(f"File not found: {json_file_path}")
else:
    with open(json_file_path, 'r') as file:
        data = json.load(file)

    # Define the key-value pairs to check in the JSON
    key_value_pairs = [
        ("nas-5gs.security_header_type", "2")
    ]

    # Function to search for specific key-value pairs
    def search_key_value(data, key, value):
        if isinstance(data, dict):
            for k, v in data.items():
                if k == key and str(v) == str(value):
                    return True
                if search_key_value(v, key, value):
                    return True
        elif isinstance(data, list):
            for item in data:
                if search_key_value(item, key, value):
                    return True
        return False

    # Validate each key-value pair
    for key, value in key_value_pairs:
        if search_key_value(data, key, value):
            print(f"{key}: {value} found in the JSON file.")
        else:
            print(f"{key}: {value} not found in the JSON file.")
