#!/bin/sh
echo "downloading file..."
wget -O downloaded-file.txt $1
cat downloaded-file.txt 