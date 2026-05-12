#!/bin/bash

#Current working directory
echo "Current working directory: $(pwd)"

# List all files in the current directory
echo "Files in the current directory:"
ls -c -l

# Check if a file named "test.txt" exists
echo "Checking if 'test.txt' exists..."
if [ -f "test.txt" ]; then
    echo "file 'test.txt' exists."
else
    echo "file 'test.txt' does not exist."
fi

#check disk space
echo "Disk space usage:"

df -h

data=$(df -h |  awk 'NR==2{print $6}' | sed 's/%//g' )

if [ $data -gt 80 ]; then
    echo "Disk space is more than 80% used. Please free up some space."
else
    echo "Disk space usage is normal"
fi


# create 10 files named file1.txt, file2.txt, ..., file10.txt
echo "Creating files file1.txt to file10.txt..."
for i in {1..10}
do
    touch "file$i.txt"
done    

#jenkins link http://192.168.220.102:8080/job/item/1/console