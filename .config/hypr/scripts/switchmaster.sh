#!/bin/bash

# Check if an argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 [-d|--dracula] [-g|--gruv] [-n|--nord]"
    exit 1
fi

# Function to execute all scripts with the given argument
execute_all_scripts() {
    local arg="$1"
    
    # List of all your theme switching scripts
    scripts=(
        "$HOME/.config/hypr/scripts/switcha.sh"
        "$HOME/.config/hypr/scripts/switchb.sh"
        "$HOME/.config/hypr/scripts/switchd.sh"
        "$HOME/.config/hypr/scripts/switche.sh"
        "$HOME/.config/hypr/scripts/switchc.sh"
    )

    # Execute each script with the provided argument
    for script in "${scripts[@]}"; do
        if [ -f "$script" ]; then
            echo "Executing $script $arg"
            bash "$script" "$arg"
        else
            echo "Warning: $script not found"
        fi
    done
}

# Parse command line arguments
case "$1" in
    -d|--dracula)
        execute_all_scripts "-d"
        ;;
    -g|--gruv)
        execute_all_scripts "-g"
        ;;
    -n|--nord)
        execute_all_scripts "-n"
        ;;
    *)
        echo "Invalid argument. Usage: $0 [-d|--dracula] [-g|--gruv] [-n|--nord]"
        exit 1
        ;;
esac

echo "All theme changes have been applied."