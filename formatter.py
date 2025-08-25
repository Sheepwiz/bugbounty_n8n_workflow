import os
import re

folder_path = '.'  # Change if needed
results = []

for filename in os.listdir(folder_path):
    if filename.endswith('.txt'):
        with open(os.path.join(folder_path, filename), 'r', encoding='utf-8', errors='ignore') as f:
            lines = f.readlines()

        base_url = None
        for line in lines:
            if line.startswith('[+] Url:'):
                base_url = line.split(":", 1)[1].strip()
                break

        if not base_url:
            continue  # Skip if no base URL found

        for line in lines:
            match = re.search(r'\[2K(.+?)\s+\(Status:\s*200\)', line)
            if match:
                endpoint = match.group(1).strip()
                full_url = base_url.rstrip('/') + '/' + endpoint.lstrip('/')
                results.append(full_url)

# Print or return the final list
for r in results:
    print(r)

