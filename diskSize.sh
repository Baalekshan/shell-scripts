#!/bin/bash
echo "Get the 10 largest files in a file system"
path="$1"

echo $path
sudo du -ah $path | sort -hr | head -n 5 > /tmp/filesize.txt

echo "List of big files in the system $path "
cat /tmp/filesize.txt