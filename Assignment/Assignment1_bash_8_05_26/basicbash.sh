#!/bin/bash

# Print numbers from 1 to 10
echo "Numbers from 1 to 10:"
for ((index = 1; index <= 10; index++))
do
    echo "$index"
done


# Print even numbers from 1 to 10
echo "Even numbers from 1 to 10:"
for ((index = 1; index <= 10; index++))
do
    if ((index % 2 == 0))
        then
        echo "$index"
    fi
done