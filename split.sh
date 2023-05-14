#!/bin/bash

# Ask user for the file name
filename=$(dialog --inputbox "Enter the file name \
(with extension, like a.zip)" 15 30 'enter here' 3>&1 1>&2 2>&3)

# Compute the hash
hash=$(sha256sum "$filename" | cut -d ' ' -f 1)

# Check if a log file with the same name already exists
logname="hash/sha256-$filename-1.txt"
count=1
while [ -e "$logname" ]
do
  ((count++))
  logname="sha256-$filename-$count.txt"
done

# Write the hash to the log file
echo "SHA256 hash for $filename: $hash" > "$logname"
echo "Log file saved as $logname"


# Check that an argument was provided
if [ -z "$filename" ]; then
  echo "Usage: $0 [filename]"
  exit 1
fi

# Create a directory to store the split files
mkdir split_files

# Split the file into 5MB parts
split -b 5M -d --suffix-length=3 "$filename" "split_files/$(basename "$filename").part"

echo "File split into 5MB parts and stored in 'split_files' directory."
