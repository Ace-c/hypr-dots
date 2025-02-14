#! /bin/bash

# Check if a Cava process is running
cava_running=$(pgrep -x cava | wc -l)

if [ "$cava_running" = "0" ]; then
    echo "Cava server not found" > /dev/null 2>&1
elif [ "$cava_running" = "1" ]; then
    killall cava 
fi

# Define the bar characters for visual representation
bar="▁▂▃▄▅▆▇█"
dict="s/;//g;"

# Create a mapping dictionary to replace numbers with bar characters
i=0
while [ $i -lt ${#bar} ]
do
    dict="${dict}s/$i/${bar:$i:1}/g;"
    i=$((i+1))
done

# Ensure the pipe file does not already exist
pipe="/tmp/cava.fifo"
if [ -p "$pipe" ]; then
    unlink "$pipe"  # Remove existing pipe
fi
mkfifo "$pipe"  # Create a new named pipe

# Generate a temporary Cava configuration file
config_file="/tmp/waybar_cava_config"
echo "
[general]
bars = 20
[output]
method = raw
raw_target = $pipe
noise_reduction = 0.7
data_format = ascii
ascii_max_range = 7
" > "$config_file"

# Start Cava with the generated config in the background
cava -p "$config_file" &

# Read data from the pipe and replace numbers with corresponding bar characters
while read -r cmd; do
    echo "$cmd" | sed "$dict"
done < "$pipe"
