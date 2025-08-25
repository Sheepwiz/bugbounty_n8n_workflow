#!/bin/bash

# Path to wordlist and input file
wordlist=~/boom.txt
input_file="cleaned_urls.txt"
output_dir="gobuster_results"

# Create output directory if it doesn't exist
mkdir -p "$output_dir"

# Loop over each domain
while IFS= read -r domain; do
    echo "Scanning $domain ..."

    # Replace dots with underscores to make a valid filename
    safe_name=$(echo "$domain" | sed -E 's|https?://||' | tr '.' '_')
    clean_url=$(echo "$domain" | sed -E 's|https?://||')

    # Run gobuster and save output
    gobuster dir -u "$clean_url" \
        -w "$wordlist" \
        --no-color \
        -a "Mozilla/5.0 (Windows; Windows NT 6.3; x64) AppleWebKit/601.32 (KHTML, like Gecko) Chrome/49.0.1631.261 Safari/603" \
        -k > "$output_dir/${safe_name}.txt"

done < "$input_file"